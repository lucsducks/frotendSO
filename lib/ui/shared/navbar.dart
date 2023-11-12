// import 'package:dashboardadmin/ui/shared/widgets/navbar_avatar.dart';
// import 'package:dashboardadmin/ui/shared/widgets/notifications_indicator.dart';
import 'package:flutter/material.dart';

class Navbar extends AppBar {
  Navbar({Key? key})
      : super(
          key: key,
          backgroundColor: const Color.fromARGB(255, 10, 125, 243),
          elevation: 5,
          title: Builder(
            builder: (BuildContext context) {
              final size = MediaQuery.of(context).size;
              if (size.width > 390) {
                return ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 250),
                  child: Container(),
                );
              }
              return SizedBox
                  .shrink(); // Si no se cumple la condición, no mostrar nada
            },
          ),
          actions: [
            Spacer(),
            // NotificationsIndicator(),
            SizedBox(width: 10),
            // NavbarAvatar(),
            SizedBox(width: 10)
          ],
          leading: Builder(
            builder: (BuildContext context) {
              final size = MediaQuery.of(context).size;
              if (size.width <= 700) {
                return IconButton(
                  color: Colors.white,
                  icon: Icon(Icons.menu_outlined),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                );
              }
              return SizedBox
                  .shrink(); // No mostrar nada si la pantalla es más grande
            },
          ),
        );
}
