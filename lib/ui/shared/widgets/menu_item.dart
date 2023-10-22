import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuItem extends StatefulWidget {
  final String text;
  final IconData icon;
  final bool isActive;
  final Function onPressed;

  const MenuItem({
    Key? key,
    required this.text,
    required this.icon,
    required this.onPressed,
    this.isActive = false,
  }) : super(key: key);

  @override
  _MenuItemState createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double espacioMARGIN = (size.width >= 700) ? 8 : 0;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: espacioMARGIN),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(espacioMARGIN),
        color: widget.isActive
            ? Color.fromARGB(255, 19, 108, 252)
            : Colors.transparent,
      ),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 250),
        child: Material(
          borderRadius: BorderRadius.circular(espacioMARGIN),
          color: widget.isActive
              ? Color.fromARGB(255, 19, 108, 252)
              : Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(espacioMARGIN),
            onTap: widget.isActive ? null : () => widget.onPressed(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              child: MouseRegion(
                onEnter: (_) => setState(() => isHovered = true),
                onExit: (_) => setState(() => isHovered = false),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(widget.icon,
                        color: widget.isActive
                            ? Colors.white
                            : Color.fromARGB(255, 162, 165, 170),
                        size: 20),
                    SizedBox(width: 15),
                    Text(
                      widget.text,
                      style: GoogleFonts.roboto(
                          fontSize: 18,
                          color: widget.isActive
                              ? Colors.white
                              : Color.fromARGB(255, 162, 165, 170)),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
