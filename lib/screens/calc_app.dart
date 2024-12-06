import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

import '../components/calc_button.dart';

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String input = '';
  String result = '0';
  bool showCursor = true;

  void buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'AC') {
        input = '';
        result = '0';
      } else if (buttonText == '⌫') {
        input = input.isNotEmpty ? input.substring(0, input.length - 1) : '';
        _updateResult();
      } else if (buttonText == '=') {
        _evaluateExpression();
      } else if (buttonText == '%') {
        if (input.isNotEmpty) {
          try {
            double value = double.parse(input.replaceAll(',', '.'));
            result = _formatNumber(value / 100);
          } catch (e) {
            result = 'Erro';
          }
        }
      } else if (buttonText == '√') {
        if (input.isNotEmpty) {
          try {
            double value = double.parse(input.replaceAll(',', '.'));
            if (value < 0) {
              result = 'Erro'; // Não permite raízes quadradas de números negativos
            } else {
              result = _formatNumber(sqrt(value));
            }
          } catch (e) {
            result = 'Erro';
          }
        }
      } else {
        input += buttonText == ',' ? '.' : buttonText;
        _updateResult();
      }
    });
  }

  void _updateResult() {
    if (input.isEmpty || "+-×÷".contains(input[input.length - 1])) return;
    try {
      Parser p = Parser();
      Expression exp = p.parse(
        input.replaceAll(',', '.')
             .replaceAll('×', '*')
             .replaceAll('÷', '/'),
      );
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      result = _formatNumber(eval);
    } catch (e) {
      result = 'Erro';
    }
  }

  void _evaluateExpression() {
    try {
      Parser p = Parser();
      Expression exp = p.parse(
        input.replaceAll(',', '.')
             .replaceAll('×', '*')
             .replaceAll('÷', '/'),
      );
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      result = _formatNumber(eval);
      input = result.replaceAll('.', ','); // Atualiza o input com o resultado
    } catch (e) {
      result = 'Erro';
    }
  }

  String _formatNumber(double value) {
    if (value == value.toInt()) {
      // Para inteiros
      int intValue = value.toInt();
      if (intValue.abs() >= 1000) {
        return intValue.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+$)'),
          (Match match) => '${match.group(1)}.',
        );
      } else {
        return intValue.toString();
      }
    } else {
      // Para decimais
      return value.toStringAsFixed(2).replaceAll('.', ',');
    }
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(milliseconds: 500), (Timer timer) {
      setState(() {
        showCursor = !showCursor;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        title: const Text(
          'Calculadora',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400, letterSpacing: 1.5),
        ),
      ),
      body: Column(
        children: <Widget>[
          // Display do input
          SizedBox(height: 30),
          
          Container(
            padding: EdgeInsets.symmetric(horizontal: 35, vertical: 20),
            alignment: Alignment.bottomRight,
            constraints: const BoxConstraints(
              maxHeight: 200, // Limite de altura para evitar rolagem
            ),
            child: SingleChildScrollView(
              reverse: true, // Rola para o final automaticamente
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  Text(
                    input.isEmpty ? '' : input.replaceAll('.', ','),
                    style: TextStyle(
                      fontSize: input.length > 20 ? 30 : 50, // Reduz o tamanho da fonte
                      color: Colors.white,
                      height: 1.2, // Ajusta o espaça entre linhas
                    ),
                    textAlign: TextAlign.right,
                    softWrap: true, // Permite quebra de linha
                    maxLines: 3, // Limita para 3 linhas máximo
                    overflow: TextOverflow.ellipsis, // Adiciona reticências se exceder
                  ),
                  Positioned(
                    right: -3,
                    child: Text(
                      showCursor ? '|' : '',
                      style: TextStyle(
                        fontSize: input.length > 20 ? 30 : 50,
                        color: Color.fromARGB(255, 177, 163, 84),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 25.0),

          // Display do resultado
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
            alignment: Alignment.bottomRight,
            child: Text(
              result,
              style: const TextStyle(fontSize: 35, color: Colors.white54),
            ),
          ),

          SizedBox(height: 20.0),

          // Divisória entre display e teclado
          const Divider(
            thickness: 2,
            color: Colors.grey,
            indent: 20,
            endIndent: 20,
          ),

          SizedBox(height: 20.0),

          // Teclado
          Expanded(
            child: GridView.count(
              crossAxisCount: 4,
              childAspectRatio: 1.5,
              mainAxisSpacing: 0,
              crossAxisSpacing: 0,
              padding: EdgeInsets.zero,
              children: [
                CalculatorButton('AC', buttonPressed, color: const Color.fromARGB(255, 182, 124, 36)),
                CalculatorButton('⌫', buttonPressed, textColor: Colors.orange),
                CalculatorButton('%', buttonPressed, textColor: Colors.green),
                CalculatorButton('√', buttonPressed, textColor: Colors.green),
                CalculatorButton('7', buttonPressed),
                CalculatorButton('8', buttonPressed),
                CalculatorButton('9', buttonPressed),
                CalculatorButton('÷', buttonPressed, textColor: Colors.green),
                CalculatorButton('4', buttonPressed),
                CalculatorButton('5', buttonPressed),
                CalculatorButton('6', buttonPressed),
                CalculatorButton('×', buttonPressed, textColor: Colors.green),
                CalculatorButton('1', buttonPressed),
                CalculatorButton('2', buttonPressed),
                CalculatorButton('3', buttonPressed),
                CalculatorButton('-', buttonPressed, textColor: Colors.green),
                CalculatorButton('0', buttonPressed),
                CalculatorButton(',', buttonPressed),
                CalculatorButton('=', buttonPressed, color: Colors.green, textColor: Colors.black),
                CalculatorButton('+', buttonPressed, textColor: Colors.green),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
