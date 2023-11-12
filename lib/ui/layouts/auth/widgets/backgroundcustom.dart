import 'package:flutter/material.dart';

class BackgroundCustom extends StatelessWidget {
  const BackgroundCustom({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    bool isResponsive = MediaQuery.of(context).size.width > 1300;
    bool isMovil = MediaQuery.of(context).size.width > 700;
    return Container(
        width: isMovil ? 600 : size.width,
        height: isResponsive ? 700 : 110,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 79, 191, 255),
                Color.fromARGB(255, 47, 149, 252),
                Color.fromARGB(255, 10, 125, 243),
                Color.fromARGB(255, 12, 110, 246),
                Color.fromARGB(255, 7, 78, 245)
              ]),
        ),
        child: Center(
            child: Padding(
                padding: const EdgeInsets.only(left: 50, right: 50),
                child: isResponsive
                    ? const Image(
                        image: AssetImage('assets/images/Logo-horizontal.png'),
                        width: 400,
                      )
                    : const Image(
                        image: AssetImage('assets/images/Logo-vertical.png'),
                        height: 60,
                      ))));
  }
}
