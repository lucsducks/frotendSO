import 'package:iziFile/api/restApi.dart';
import 'package:iziFile/providers/auth_provider.dart';
import 'package:iziFile/providers/sftp_provider.dart';
import 'package:iziFile/providers/sidemenu_provider.dart';
import 'package:iziFile/providers/sshconexion_provider.dart';
import 'package:iziFile/providers/terminal_provider.dart';
import 'package:iziFile/providers/usuario_provider.dart';
import 'package:iziFile/router/router.dart';
import 'package:iziFile/services/localStorage.dart';
import 'package:iziFile/services/navigation_service.dart';
import 'package:iziFile/services/notificacion_service.dart';
import 'package:iziFile/ui/layouts/auth/auth_layout.dart';
import 'package:iziFile/ui/layouts/dashboard/dashboard_layout.dart';
import 'package:iziFile/ui/layouts/splash/splash_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.configurePrefs();
  restApi.configureDio();
  Flurorouter.configureRoutes();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  runApp(AppState());
}

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          lazy: false,
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          lazy: false,
          create: (_) => SideMenuProvider(),
        ),
        ChangeNotifierProvider(
          lazy: false,
          create: (_) => UsuariosSistemaProvider(),
        ),
        ChangeNotifierProvider(
          lazy: false,
          create: (_) => sshConexionProvider(),
        ),
        ChangeNotifierProvider(
          lazy: false,
          create: (_) => TerminalProvider(),
        ),
        ChangeNotifierProvider(
          lazy: false,
          create: (_) => SftpProvider(),
        ),
        ChangeNotifierProvider(
          lazy: false,
          create: (_) => TerminalManager(),
        ),
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Admin dashboard',
      initialRoute: '/',
      onGenerateRoute: Flurorouter.router.generator,
      navigatorKey: NavigationService.navigatorKey,
      scaffoldMessengerKey: NotificationsService.messengerKey,
      builder: (_, child) {
        final authProvider = Provider.of<AuthProvider>(context);

        Widget layout;
        if (authProvider.authStatus == AuthStatus.checking) {
          layout = SplashLayout();
        } else if (authProvider.authStatus == AuthStatus.authenticated) {
          layout = DashboardLayout(child: child!);
        } else {
          layout = AuthLayout(child: child!);
        }

        return SafeArea(child: layout);
      },
      theme: ThemeData.light().copyWith(
          useMaterial3: true,
          scrollbarTheme: ScrollbarThemeData().copyWith(
            thumbColor: MaterialStateProperty.all(
                const Color.fromARGB(52, 199, 193, 193)),
          ),
          dataTableTheme: DataTableThemeData(
            headingRowColor: MaterialStateProperty.all(Colors.white),
            dataRowColor: MaterialStateProperty.all(
                Colors.white), // El color que quieras para las filas de datos
          )),
    );
  }
}
