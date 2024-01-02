import 'package:flutter/material.dart';

class TabsWidget extends StatelessWidget {
  final String text;
  final Color color;
  final Function function;
  final double fontSize;
  const TabsWidget({
    Key? key,
    required this.text,
    required this.color,
    required this.function,
    required this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        function();
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
