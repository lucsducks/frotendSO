import 'package:dashboardadmin/providers/auth_provider.dart';
import 'package:dashboardadmin/providers/sidemenu_provider.dart';
import 'package:dashboardadmin/router/router.dart';
import 'package:dashboardadmin/services/navigation_service.dart';
import 'package:dashboardadmin/ui/shared/widgets/logo.dart';
import 'package:dashboardadmin/ui/shared/widgets/menu_item.dart';
import 'package:dashboardadmin/ui/shared/widgets/search_text.dart';
import 'package:dashboardadmin/ui/shared/widgets/text_separator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Sidebar extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const Sidebar({super.key, required this.scaffoldKey});

  void navigateTo(String routeName, BuildContext context) {
    // Navega a la nueva ruta

    NavigationService.replaceTo(routeName);
    // Verifica si estamos en un dispositivo móvil
    if (MediaQuery.of(context).size.width < 700) {
      // Verifica si el Navigator tiene al menos una pantalla antes de hacer pop
      scaffoldKey.currentState?.openEndDrawer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final sideMenuProvider = Provider.of<SideMenuProvider>(context);

    return Drawer(
      child: Container(
        decoration: buildBoxDecoration(),
        child: ListView(
          physics: ClampingScrollPhysics(),
          children: [
            DrawerHeader(child: Logo()), // Encabezado del Drawer
            SearchText(),
            SizedBox(height: 5),
            ...buildMenuItems(context, sideMenuProvider),
          ],
        ),
      ),
    );
  }

  List<Widget> buildMenuItems(
      BuildContext context, SideMenuProvider sideMenuProvider) {
    final user = Provider.of<AuthProvider>(context).user!;
    final allowedRoles = ["DEV_ROLE"];

    return [
      TextSeparator(text: ' Main'),
      MenuItem(
        text: 'Hosts',
        icon: Icons.compass_calibration_outlined,
        onPressed: () => navigateTo(Flurorouter.dashboardRoute, context),
        isActive: sideMenuProvider.currentPage == Flurorouter.dashboardRoute,
      ),
      MenuItem(
        text: 'SFTP',
        icon: Icons.folder_open_outlined,
        onPressed: () => navigateTo(Flurorouter.iconsRoute, context),
        isActive: sideMenuProvider.currentPage == Flurorouter.iconsRoute,
      ),
      if (allowedRoles.any((role) => user.rol.contains(role)))
        MenuItem(
          text: 'Usuarios',
          icon: Icons.person_pin_outlined,
          onPressed: () => navigateTo(Flurorouter.usuarioSinRoleRoute, context),
          isActive:
              sideMenuProvider.currentPage == Flurorouter.usuarioSinRoleRoute,
        ),
      SizedBox(height: 10),
      MenuItem(
        text: 'Terminal',
        icon: Icons.post_add_outlined,
        onPressed: () => navigateTo(Flurorouter.blankRoute, context),
        isActive: sideMenuProvider.currentPage == Flurorouter.blankRoute,
      ),
      SizedBox(height: 10),
      TextSeparator(text: 'Exit'),
      MenuItem(
          text: 'Logout',
          icon: Icons.exit_to_app_outlined,
          onPressed: () {
            Provider.of<AuthProvider>(context, listen: false).logout();
          }),
    ];
  }

  BoxDecoration buildBoxDecoration() => BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: const Color.fromARGB(31, 247, 12, 12),
              blurRadius: 10,
              spreadRadius: 1)
        ],
      );
}
