import 'package:flutter/material.dart';

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
    this.color = Colors.indigo,
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
        elevation: MaterialStateProperty.all(5.0), // Añade elevación
        padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(horizontal: 20, vertical: 10)), // Relleno
      ),
      onPressed: () => onPressed(),
      child: Row(
        mainAxisSize:
            MainAxisSize.min, // Ajusta el tamaño del Row a su contenido
        children: [
          Icon(icon, color: Colors.white),
          SizedBox(width: 10), // Espaciado entre el ícono y el texto
          Text(
            text,
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }
}
