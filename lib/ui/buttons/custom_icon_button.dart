import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomIconButton extends StatelessWidget {
  final Function onPressed;
  final String text;
  final Color color;
  final bool isFilled;
  final IconData icon;

  const CustomIconButton({
    Key? key,
    required this.onPressed,
    required this.text,
    required this.icon,
    this.color = const Color.fromARGB(255, 10, 125, 243),
    this.isFilled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(StadiumBorder()),
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return color.withOpacity(0.7);
            }
            return color;
          },
        ),
        elevation: MaterialStateProperty.all(4), // Añade elevación
        padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 20, vertical: 20)), // Relleno
      ),
      onPressed: () => onPressed(),
      child: Row(
        mainAxisSize:
            MainAxisSize.min, // Ajusta el tamaño del Row a su contenido
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 10), // Espaciado entre el ícono y el texto
          Text(
            text,
            style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
          )
        ],
      ),
    );
  }
}
