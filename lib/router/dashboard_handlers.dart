import 'package:iziFile/providers/auth_provider.dart';
import 'package:iziFile/providers/sidemenu_provider.dart';
import 'package:iziFile/router/router.dart';
import 'package:iziFile/ui/views/blank_view.dart';
import 'package:iziFile/ui/views/dashboard_view.dart';
import 'package:iziFile/ui/views/host_personal_view.dart';
import 'package:iziFile/ui/views/icons_view.dart';
import 'package:iziFile/ui/views/login_view.dart';
import 'package:iziFile/ui/views/sftp_view.dart';
import 'package:iziFile/ui/views/usuarios_general_view.dart';
import 'package:fluro/fluro.dart';
import 'package:provider/provider.dart';

class DashboardHandlers {
  static Handler dashboard = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);
    Provider.of<SideMenuProvider>(context, listen: false)
        .setCurrentPageUrl(Flurorouter.dashboardRoute);
    if (authProvider.authStatus != AuthStatus.authenticated) {
      return LoginView();
    } else {
      return DashboardView();
    }
  });
  static Handler icons = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);
    Provider.of<SideMenuProvider>(context, listen: false)
        .setCurrentPageUrl(Flurorouter.iconsRoute);

    if (authProvider.authStatus == AuthStatus.authenticated)
      return IconsView();
    else
      return LoginView();
  });
  static Handler usuarioSinRol = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);
    Provider.of<SideMenuProvider>(context, listen: false)
        .setCurrentPageUrl(Flurorouter.usuarioSinRoleRoute);

    if (authProvider.authStatus == AuthStatus.authenticated)
      return UsuarioSinRoleView();
    else
      return LoginView();
  });
  static Handler hostSeleccionado = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);
    Provider.of<SideMenuProvider>(context, listen: false)
        .setCurrentPageUrl(Flurorouter.hostperonalRoute);

    if (authProvider.authStatus == AuthStatus.authenticated) {
      if (params['hostid']?.first != null && params['ownerid']?.first != null) {
        return HostPersonalView(
          hostid: params['hostid']!.first,
          ownerid: params['ownerid']!.first,
        );
      } else {
        return DashboardView();
      }
    } else {
      return LoginView();
    }
  });

  static Handler blank = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);
    Provider.of<SideMenuProvider>(context, listen: false)
        .setCurrentPageUrl(Flurorouter.blankRoute);

    if (authProvider.authStatus == AuthStatus.authenticated)
      return BlankView();
    else
      return LoginView();
  });
}
