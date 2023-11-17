import 'package:iziFile/ui/layouts/auth/widgets/backgroundcustom.dart';
import 'package:flutter/material.dart';

class AuthLayout extends StatelessWidget {
  final Widget child;

  const AuthLayout({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: Scrollbar(
      child: ListView(
        children: [
          (size.width > 700)
              ? _DesktopBody(child: child)
              : _MobileBody(child: child),
        ],
      ),
    ));
  }
}

class _DesktopBody extends StatelessWidget {
  final Widget child;

  const _DesktopBody({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double widthResponsive = (size.width > 1300) ? 1200 : 600;
    bool isResponsive = MediaQuery.of(context).size.width > 1300;
    return Container(
      height: size.height,
      width: size.width,
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [
          Color.fromARGB(255, 47, 149, 252),
          Color.fromARGB(255, 79, 191, 255),
          Colors.white
        ]),
      ),
      child: Center(
        child: Container(
            width: widthResponsive,
            height: 700,
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(80, 0, 0, 0),
                  offset: Offset(10, 10),
                  blurRadius: 10.0,
                  spreadRadius: 2.0,
                ),
              ],
            ),
            child: isResponsive
                ? Row(
                    children: [
                      const BackgroundCustom(),
                      Expanded(
                          child: Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(50),
                          child: child,
                        ),
                      ))
                    ],
                  )
                : Column(
                    children: [
                      const BackgroundCustom(),
                      Expanded(
                          child: Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 50, right: 50),
                          child: child,
                        ),
                      ))
                    ],
                  )),
      ),
    );
  }
}

class _MobileBody extends StatelessWidget {
  final Widget child;

  const _MobileBody({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height,
      width: size.width,
      child: Column(
        children: [
          const BackgroundCustom(),
          Expanded(
            child: Container(
                color: Colors.white,
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: child),
          )
        ],
      ),
    );
  }
}
