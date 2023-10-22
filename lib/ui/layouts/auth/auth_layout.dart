import 'package:dashboardadmin/ui/layouts/auth/widgets/backgroundcustom.dart';
import 'package:dashboardadmin/ui/layouts/auth/widgets/custom_title.dart';
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
          (size.width > 1000)
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
    double containerWidth = (size.width > 1300) ? 600 : 480;
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/fon5.jpg'), //fondo
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Container(
          width: size.width - 50,
          height: size.height - 100,
          color: Colors.white,
          child: Row(
            children: [
              BackgroundCustom(),
              Container(
                width: containerWidth,
                height: double.infinity,
                color: Colors.white,
                child: Column(
                  children: [
                    CustomTitle(),
                    SizedBox(
                      height: 30,
                    ),
                    Expanded(child: child),
                  ],
                ),
              )
            ],
          ),
        ),
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
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/nos3.jpeg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 80),
        child: Container(
          width: size.width - 40,
          height: size.height - 160,
          color: Colors.white,
          child: Column(
            children: [
              const CustomTitle(),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}
