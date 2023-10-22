import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SplashLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.1, 0.5, 0.9],
            colors: [
              Colors.blue[700]!,
              Colors.blue[500]!,
              Colors.blue[300]!,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(60),
                  shadowColor: Colors.black38,
                  elevation: 10,
                ),
                onPressed:
                    () {}, // Actualiza esta función según tus necesidades
                child: FaIcon(
                  FontAwesomeIcons.dashboard, // Cambio de ícono
                  color: Colors.blue[700],
                  size: 50.0,
                ),
              ),
              SizedBox(height: 30),
              SpinKitThreeBounce(
                color: Colors.white,
                size: 30.0,
              ),
              SizedBox(height: 20),
              Text(
                'Verificando...',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.5,
                  shadows: [
                    Shadow(
                      blurRadius: 8.0,
                      color: Colors.black38,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
