import 'package:flutter/material.dart';

class CalculatorButton extends StatelessWidget {
  final String text;
  final Function callback;
  final Color color;
  final Color textColor;
  final FontWeight fontWeight;

  CalculatorButton(this.text, this.callback, {this.color = Colors.black, this.textColor = Colors.white, this.fontWeight = FontWeight.normal,});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: textColor, backgroundColor: color,
            textStyle: TextStyle(fontSize: 26, fontWeight: FontWeight.w400), // Aumentar o tamanho dos textos dentro dos botões
          ),
          onPressed: () => callback(text),
          child: Text(text),
        ),
      ),
    );
  }
}
