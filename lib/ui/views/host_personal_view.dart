import 'package:dashboardadmin/providers/sshconexion_provider.dart';
import 'package:dashboardadmin/providers/terminal_provider.dart';
import 'package:dashboardadmin/services/navigation_service.dart';
import 'package:dashboardadmin/ui/labels/custom_labels.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xterm/xterm.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HostPersonalView extends StatefulWidget {
  final String hostid;
  final String ownerid;

  const HostPersonalView(
      {super.key, required this.hostid, required this.ownerid});

  @override
  State<HostPersonalView> createState() => _HostPersonalViewState();
}

class _HostPersonalViewState extends State<HostPersonalView> {
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    initSSHConnections();
  }

  void initSSHConnections() {
    final sshProvider =
        Provider.of<sshConexionProvider>(context, listen: false);
    sshProvider.getinformacionHost(widget.hostid).then((_) {
      final conexionHost = sshProvider.conexion;
      if (!Provider.of<TerminalProvider>(context, listen: false).isConnected) {
        Provider.of<TerminalProvider>(context, listen: false).initTerminal(
          host: conexionHost.direccionip,
          port: conexionHost.port,
          username: conexionHost.usuario,
          password: conexionHost.password,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Define la cantidad de pestañas que necesites aquí
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(text: 'Servidor 1'),
              Tab(text: 'Servidor 2'),
              // Añade más pestañas según necesites
            ],
          ),
          title: Text('Terminal View', style: CustomLabels.h1),
        ),
        body: TabBarView(
          children: [
            buildTerminalView(), // para el servidor 1
            buildTerminalView(), // para el servidor 2
            // Añade más vistas según necesites
          ],
        ),
      ),
    );
  }

  Widget buildTerminalView() {
    final terminalProvider = Provider.of<TerminalProvider>(context);
    if (!terminalProvider.isConnected && terminalProvider.isExit) {
      terminalProvider.isExit = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(seconds: 1), () {
          NavigationService.navigateTo('/dashboard');
        });
      });
    }
    return Column(
      children: [
        const SizedBox(height: 10),
        Expanded(
          child: terminalProvider.isConnected
              ? TerminalView(terminalProvider.terminal)
              : buildConnectingView(),
        ),
      ],
    );
  }

  Widget buildConnectingView() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.1, 0.5, 0.9],
          colors: [
            Colors.blue[700]!,
            Colors.blue[500]!,
            Colors.blue[300]!,
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(60),
                shadowColor: Colors.black38,
                elevation: 10,
              ),
              onPressed: () {},
              child: FaIcon(
                FontAwesomeIcons.dashboard,
                color: Colors.blue[700],
                size: 50.0,
              ),
            ),
            const SizedBox(height: 30),
            const SpinKitThreeBounce(
              color: Colors.white,
              size: 30.0,
            ),
            const SizedBox(height: 20),
            const Text(
              'Verificando...',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.5,
                shadows: [
                  Shadow(
                    blurRadius: 8.0,
                    color: Colors.black38,
                    offset: Offset(2.0, 2.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
