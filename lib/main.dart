import 'package:dashboardadmin/api/restApi.dart';
import 'package:dashboardadmin/providers/auth_provider.dart';
import 'package:dashboardadmin/providers/sidemenu_provider.dart';
import 'package:dashboardadmin/providers/usuario_provider.dart';
import 'package:dashboardadmin/router/router.dart';
import 'package:dashboardadmin/services/localStorage.dart';
import 'package:dashboardadmin/services/navigation_service.dart';
import 'package:dashboardadmin/services/notificacion_service.dart';
import 'package:dashboardadmin/ui/layouts/auth/auth_layout.dart';
import 'package:dashboardadmin/ui/layouts/dashboard/dashboard_layout.dart';
import 'package:dashboardadmin/ui/layouts/splash/splash_layout.dart';
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
          create: (_) => AuthProvider(), //lazy inicializa
        ),
        ChangeNotifierProvider(
          lazy: false,
          create: (_) => SideMenuProvider(),
        ),
        ChangeNotifierProvider(
          lazy: false,
          create: (_) => UsuariosSistemaProvider(),
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

        // Aquí envolvemos el layout seleccionado dentro de un SafeArea
        return SafeArea(child: layout);
      },
      theme: ThemeData.light().copyWith(
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
