import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextSeparator extends StatelessWidget {
  final String text;

  const TextSeparator({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      margin: EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 0.5,
            color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.1),
          ),
        ),
      ),
      child: Text(
        text.toUpperCase(),
        style: GoogleFonts.roboto(
          color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
