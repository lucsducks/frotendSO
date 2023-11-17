import 'package:iziFile/providers/auth_provider.dart';
import 'package:iziFile/providers/sidemenu_provider.dart';
import 'package:iziFile/router/router.dart';
import 'package:iziFile/services/navigation_service.dart';
import 'package:iziFile/ui/shared/widgets/logo.dart';
import 'package:iziFile/ui/shared/widgets/menu_item.dart';
import 'package:iziFile/ui/shared/widgets/text_separator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    final size = MediaQuery.of(context).size;
    final sideMenuProvider = Provider.of<SideMenuProvider>(context);

    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 10, 125, 243),
        ),
        height: size.height,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            physics: const ClampingScrollPhysics(),
            children: [
              DrawerHeader(child: Logo()),
              const SizedBox(height: 10),
              ...buildMenuItems(context, sideMenuProvider),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildMenuItems(
      BuildContext context, SideMenuProvider sideMenuProvider) {
    final user = Provider.of<AuthProvider>(context).user!;
    final allowedRoles = ["DEV_ROLE"];

    Map<String, String> roleMap = {
      'DEV_ROLE': 'Developer',
      'USER_ROLE': 'Usuario'
    };
    String? readableRole = roleMap[user.rol];

    String nombreUser = user.nombre;

    return [
      const TextSeparator(text: 'Main'),
      const SizedBox(height: 10),
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
      // MenuItem(
      //   text: 'Terminal',
      //   icon: Icons.post_add_outlined,
      //   onPressed: () => navigateTo(Flurorouter.blankRoute, context),
      //   isActive: sideMenuProvider.currentPage == Flurorouter.blankRoute,
      // ),
      const SizedBox(height: 50),
      const TextSeparator(text: 'Cuenta'),
      const SizedBox(height: 10),
      Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: Colors.white),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Icon(
              Icons.person,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
              child: SizedBox(
            height: 60,
            child: Column(children: [
              Expanded(
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      (nombreUser.toString()),
                      style: GoogleFonts.poppins(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.white, // Texto azul
                      ),
                    )),
              ),
              Container(
                height: 0.5,
                width: double.maxFinite,
                color: Colors.white.withOpacity(0.1),
              ),
              Expanded(
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      (readableRole.toString()),
                      style: GoogleFonts.poppins(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w200,
                        color: Colors.white, // Texto azul
                      ),
                    )),
              )
            ]),
          ))
        ],
      ),
      const SizedBox(height: 50),
      const TextSeparator(text: 'Exit'),
      const SizedBox(height: 10),
      MenuItem(
          text: 'Cerrar sesión',
          icon: Icons.exit_to_app_outlined,
          onPressed: () {
            Provider.of<AuthProvider>(context, listen: false).logout();
          }),
    ];
  }
}
