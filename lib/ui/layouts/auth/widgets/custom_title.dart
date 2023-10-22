import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTitle extends StatelessWidget {
  const CustomTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //image.asset()
          // Image.asset(
          //   'sumaq.png',
          //   width: 1000,
          //   height: 500,
          // ),
          Container(
            width: 200,
            height: 100,
            child: Image.asset(
              'assets/images/1.png',
              width: 200,
              height: 100,
              fit: BoxFit.contain,
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text(
                "IzIFILE",
                style: GoogleFonts.abel (
                    fontSize: 40,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
