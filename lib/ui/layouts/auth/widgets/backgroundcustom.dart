import 'package:flutter/material.dart';

class BackgroundCustom extends StatelessWidget {
  const BackgroundCustom({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: buidBackground(),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Center(
                // child: Image(
                //   image: AssetImage('sumaq.png'),
                //   width: 700,
                // ),
                ),
          ),
        ),
      ),
    );
  }

  BoxDecoration buidBackground() {
    return const BoxDecoration(
      image: DecorationImage(
          image: AssetImage('assets/images/fon3.png'), fit: BoxFit.cover),
    );
  }
}
