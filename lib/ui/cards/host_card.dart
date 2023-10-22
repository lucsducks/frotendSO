import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HostCard extends StatefulWidget {
  final String? logoPath;
  final String? nombre;
  final String? direccionIp;
  final Color? cardColor;
  final Color? textColor;
  final VoidCallback? onTap;

  const HostCard({
    Key? key,
    required this.logoPath,
    required this.nombre,
    required this.direccionIp,
    this.cardColor = Colors.blueGrey,
    this.textColor = Colors.white,
    this.onTap,
  }) : super(key: key);

  @override
  _HostCardState createState() => _HostCardState();
}

class _HostCardState extends State<HostCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          transform: Matrix4.identity()..scale(_isHovering ? 0.95 : 1.0),
          child: Container(
            width: 200,
            height: 80,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: widget.cardColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipOval(
                  clipBehavior: Clip.hardEdge,
                  child: Image.network(
                    widget.logoPath!,
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.nombre!,
                      style: TextStyle(
                          color: widget.textColor, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.direccionIp!,
                      style: TextStyle(color: widget.textColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
