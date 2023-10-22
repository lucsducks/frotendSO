import 'package:flutter/material.dart';

class CustomOutlinedButton extends StatelessWidget {
  final Function onPressed;
  final String text;
  final Color color;
  final bool isFilled;
  final IconData? icon; // New parameter for the icon

  const CustomOutlinedButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.color = Colors.blue,
    this.isFilled = false,
    this.icon, // Initialize the icon parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double redi = (size.width < 600) ? 60 : 20;
    return OutlinedButton(
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
          mainAxisSize:
              MainAxisSize.min, // To make the Row's width as small as possible
          children: [
            if (icon != null)
              Icon(icon, color: color), // Display the icon if it's provided
            if (icon != null)
              SizedBox(width: 10), // Add a space between the icon and the text
            Text(
              text,
              style: TextStyle(fontSize: 16, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
