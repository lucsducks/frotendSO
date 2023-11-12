import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      return const Center(
        child: Image(
          image: AssetImage('assets/images/Logo-vertical.png'),
          width: 200, 
        ),
      );
  }
}
