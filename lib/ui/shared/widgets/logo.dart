import 'package:dashboardadmin/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Logo extends StatefulWidget {
  @override
  _LogoState createState() => _LogoState();
}

class _LogoState extends State<Logo> with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: _controller!,
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user!;
    final size = MediaQuery.of(context).size;
    Map<String, String> roleMap = {'DEV_ROLE': 'Dev', 'USER_ROLE': 'Usuario'};
    String? readableRole = roleMap[user.rol];
    if (size.width > 700) {
      return Container(
        padding: EdgeInsets.only(top: 20.0),
        decoration: BoxDecoration(
          color: Colors.white, // Solo mantendremos el color de fondo blanco
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _animation!,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.bubble_chart_outlined,
                    size: 40,
                    color: Color.fromARGB(255, 0, 108, 252)), // Ícono azul
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                (readableRole.toString()),
                style: GoogleFonts.roboto(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w200,
                  color: Color(0xff092044), // Texto azul
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.only(top: 20.0),
        decoration: BoxDecoration(
          color: Colors.white, // Solo mantendremos el color de fondo blanco
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _animation!,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.bubble_chart_outlined,
                    size: 40,
                    color: Color.fromARGB(255, 0, 108, 252)), // Ícono azul
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                readableRole.toString(),
                style: GoogleFonts.roboto(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w200,
                  color: Color(0xff092044), // Texto azul
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
