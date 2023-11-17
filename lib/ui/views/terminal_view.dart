import 'package:iziFile/providers/sshconexion_provider.dart';
import 'package:iziFile/providers/terminal_provider.dart';
import 'package:iziFile/services/navigation_service.dart';
import 'package:iziFile/services/notificacion_service.dart';
import 'package:iziFile/services/virtual_keyboard.dart';
import 'package:iziFile/ui/labels/custom_labels.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:xterm/xterm.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TerminalViewPage extends StatefulWidget {
  final String hostid;
  final String ownerid;
  final TerminalProvider terminalProvider;
  const TerminalViewPage({
    super.key,
    required this.hostid,
    required this.ownerid,
    required this.terminalProvider,
  });

  @override
  _TerminalViewPageState createState() => _TerminalViewPageState();
}

class _TerminalViewPageState extends State<TerminalViewPage> {
  ValueNotifier<bool> shouldNavigateToDashboard = ValueNotifier(false);
  @override
  void initState() {
    super.initState();
    initSSHConnections();
    widget.terminalProvider.addListener(navigateToDashboardIfNeeded);
  }

  @override
  void dispose() {
    widget.terminalProvider.removeListener(navigateToDashboardIfNeeded);
    super.dispose();
  }

  void navigateToDashboardIfNeeded() {
    if (widget.terminalProvider.isExit) {
      // Eliminar la conexión y el proveedor de terminal.
      final sshConexionprovider =
          Provider.of<sshConexionProvider>(context, listen: false);
      sshConexionprovider.removeConexion(widget.hostid);
      sshConexionprovider.removeTerminalProviderById(widget.hostid);

      // Navegar al dashboard.
      NavigationService.navigateTo('/dashboard');
    }
  }

  void initSSHConnections() {
    final sshProvider =
        Provider.of<sshConexionProvider>(context, listen: false);
    sshProvider.getinformacionHost(widget.hostid).then((_) {
      final conexionHost = sshProvider.conexion;
      // Usa el terminalProvider del widget, no solicites uno nuevo del Provider
      if (!widget.terminalProvider.isConnected) {
        widget.terminalProvider
            .initTerminal(
          host: conexionHost.direccionip,
          port: conexionHost.port,
          username: conexionHost.usuario,
          password: conexionHost.password,
        )
            .then((_) {
          // Actualizar la interfaz de usuario en caso de éxito.
          if (mounted) {
            setState(() {
              // La conexión fue exitosa.
              widget.terminalProvider.isConnected = true;
            });
          }
        }).catchError((error) {
          // Actualizar la interfaz de usuario en caso de error.
          if (mounted) {
            setState(() {
              // La conexión falló.
              widget.terminalProvider.isConnected = false;
              Provider.of<sshConexionProvider>(context, listen: false)
                  .removeConexion(widget.hostid);
              Provider.of<sshConexionProvider>(context, listen: false)
                  .removeTerminalProviderById(widget.hostid);
              // Si hay un error, presumiblemente queremos volver al dashboard.
              shouldNavigateToDashboard.value = true;
            });
          }
        });
      } else if (widget.terminalProvider.isExit) {
        // Si el estado isExit es true, entonces establecemos que debemos navegar al dashboard.
        shouldNavigateToDashboard.value = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return buildTerminalView();
  }

  Widget buildTerminalView() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          VirtualKeyboardView(widget.terminalProvider.keyboard),
          Expanded(
            child: widget.terminalProvider.isConnected
                ? TerminalView(widget.terminalProvider.terminal)
                : buildConnectingView(),
          ),
        ],
      ),
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
            Text(
              'Conectando...',
              style: GoogleFonts.poppins(
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
