import 'package:flutter/material.dart';

class H1 extends StatelessWidget {
  const H1(this.text,
      {super.key, this.color}); //siempre agregar al constructor la varible
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    );
  }
}
