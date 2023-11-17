import 'package:iziFile/providers/auth_provider.dart';
import 'package:iziFile/ui/views/dashboard_view.dart';
import 'package:iziFile/ui/views/login_view.dart';
import 'package:iziFile/ui/views/register_view.dart';
import 'package:iziFile/ui/views/verification_view.dart';
import 'package:fluro/fluro.dart';

import 'package:provider/provider.dart';

class AdminHandlers {
  static Handler login = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);
    if (authProvider.authStatus == AuthStatus.notAuthenticated) {
      return LoginView();
    } else {
      return DashboardView();
    }
  });

  static Handler register = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);

    if (authProvider.authStatus == AuthStatus.notAuthenticated) {
      return const RegisterView();
    } else {
      return DashboardView();
    }
  });
  static Handler verification = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);

    if (authProvider.authStatus == AuthStatus.notAuthenticated) {
      return const VerificationView();
    }
  });
}
