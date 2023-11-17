import 'package:iziFile/ui/shared/navbar.dart';
import 'package:iziFile/ui/shared/sidebar.dart';
import 'package:flutter/material.dart';

class DashboardLayout extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Widget child;
  DashboardLayout({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      appBar: (size.width < 700) ? Navbar() : null,
      drawer: (size.width < 700) ? Sidebar(scaffoldKey: _scaffoldKey) : null,
      body: Row(
        children: [
          if (size.width >= 700) Sidebar(scaffoldKey: _scaffoldKey),
          Expanded(
            child: Container(
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
