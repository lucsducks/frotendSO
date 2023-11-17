import 'package:iziFile/router/admin_handlers.dart';
import 'package:iziFile/router/dashboard_handlers.dart';
import 'package:iziFile/router/no_page_found_handlers.dart';
import 'package:fluro/fluro.dart';

class Flurorouter {
  static final FluroRouter router = FluroRouter();

  static String rootRoute = '/';
  // Auth Router
  static String loginRoute = '/auth/login';
  static String registerRoute = '/auth/register';
  static String verificationRoute = '/auth/verification';

  static String dashboardRoute = '/dashboard';
  static String hostperonalRoute = '/dashboard/host/:hostid/owner/:ownerid';
  static String sftpRoute = '/dashboard/sftp/:hostid/owner/:ownerid';
  static String iconsRoute = '/dashboard/icons';
  static String blankRoute = '/dashboard/blank';
  static String usuarioSinRoleRoute = '/dashboard/usuarios/sinroles';

  static void configureRoutes() {
    // Auth Routes
    router.define(rootRoute,
        handler: AdminHandlers.login, transitionType: TransitionType.none);
    router.define(loginRoute,
        handler: AdminHandlers.login, transitionType: TransitionType.none);
    router.define(registerRoute,
        handler: AdminHandlers.register, transitionType: TransitionType.none);
    router.define(verificationRoute,
        handler: AdminHandlers.verification,
        transitionType: TransitionType.none);

    // Dashboard
    router.define(dashboardRoute,
        handler: DashboardHandlers.dashboard,
        transitionType: TransitionType.fadeIn);
    router.define(iconsRoute,
        handler: DashboardHandlers.icons,
        transitionType: TransitionType.fadeIn);
    router.define(blankRoute,
        handler: DashboardHandlers.blank,
        transitionType: TransitionType.fadeIn);
    router.define(usuarioSinRoleRoute,
        handler: DashboardHandlers.usuarioSinRol,
        transitionType: TransitionType.fadeIn);
    router.define(hostperonalRoute,
        handler: DashboardHandlers.hostSeleccionado,
        transitionType: TransitionType.fadeIn);

    // 404
    router.notFoundHandler = NoPageFoundHandlers.noPageFound;
  }
}
