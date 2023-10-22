import 'package:flutter/material.dart';

class SearchText extends StatefulWidget {
  final ValueChanged<String>? onChanged;

  SearchText({this.onChanged});

  @override
  _SearchTextState createState() => _SearchTextState();
}

class _SearchTextState extends State<SearchText> {
  bool isHovered = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          isHovered = true;
        });
      } else {
        setState(() {
          isHovered = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white, // Cambio aquí: fondo blanco
        border: isHovered
            ? Border.all(width: 2.0, color: Color.fromARGB(255, 19, 108, 252))
            : Border.all(width: 2.0, color: Colors.transparent),
      ),
      child: MouseRegion(
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
        child: TextField(
          focusNode: _focusNode,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.search_outlined,
              color: Color.fromARGB(255, 162, 165, 170),
            ),
            hintText: 'Buscar',
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            hintStyle: TextStyle(
                color: Color.fromARGB(255, 162, 165, 170), fontSize: 18),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}
