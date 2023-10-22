import 'package:flutter/material.dart';

class CustomOutlinedButton extends StatelessWidget {
  final Function onPressed;
  final String text;
  final Color color;
  final bool isFilled;
  final IconData? icon;

  const CustomOutlinedButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.color = Colors.blue,
    this.isFilled = false,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double redi = (size.width < 600) ? 60 : 20;
    return Container(
      width: 430,
      child: OutlinedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          side: MaterialStateProperty.all(
            BorderSide(color: color),
          ),
          backgroundColor: MaterialStateProperty.all(
            isFilled ? color.withOpacity(0.3) : Colors.transparent,
          ),
        ),
        onPressed: () => onPressed(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: redi, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) Icon(icon, color: color),
              if (icon != null) SizedBox(width: 10),
              Text(
                text,
                style: TextStyle(fontSize: 16, color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
