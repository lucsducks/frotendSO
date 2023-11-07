import 'package:dashboardadmin/services/navigation_service.dart';
import 'package:dashboardadmin/services/notificacion_service.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dartssh2/dartssh2.dart';
import 'package:xterm/xterm.dart';

class TerminalManager extends ChangeNotifier {
  // La lista para mantener las instancias de los terminales.
  final List<TerminalProvider> _terminals = [];

  // Getter para acceder a los terminales de forma segura.
  List<TerminalProvider> get terminals => List.unmodifiable(_terminals);

  // Método para crear y añadir un nuevo TerminalProvider a la lista.
  void createTerminal({
    required String host,
    required int port,
    required String username,
    required String password,
  }) {
    final terminalProvider = TerminalProvider();
    // Aquí se inicia el terminal con los datos proporcionados.
    terminalProvider.initTerminal(
      host: host,
      port: port,
      username: username,
      password: password,
    );
    // Añadir el nuevo terminal a la lista.
    _terminals.add(terminalProvider);
    // Notificar a los listeners que hay un nuevo terminal disponible.
    notifyListeners();
  }

  // Método para obtener un TerminalProvider específico por index.
  TerminalProvider getTerminal(int index) => _terminals[index];

  // Método para cerrar y eliminar un terminal de la lista.
  void closeAndRemoveTerminal(int index) {
    // Asumiendo que hay un método `closeConnection` en `TerminalProvider` para cerrar la sesión SSH.
    _terminals[index].closeConnection();
    // Eliminar el terminal de la lista.
    _terminals.removeAt(index);
    // Notificar a los oyentes que un terminal ha sido eliminado.
    notifyListeners();
  }

  // Cerrar todas las conexiones cuando se desecha el TerminalManager.
  @override
  void dispose() {
    for (var terminal in _terminals) {
      terminal.closeConnection();
    }
    super.dispose();
  }
}

class TerminalProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late Terminal terminal;
  bool isConnected = false;
  bool isExit = false;
  SSHClient? sshClient;
  Function onCommandEntered = () {};
  SSHSession? session;
  SSHSocket? socket;
  TerminalProvider() {
    terminal = Terminal();
  }

  Future<void> initTerminal({
    required String host,
    required int port,
    required String username,
    required String password,
  }) async {
    try {
      isExit = false;
      terminal.write('Connecting...\r\n');

      socket = await SSHSocket.connect(host, port);
      sshClient = SSHClient(
        socket!,
        username: username,
        onPasswordRequest: () => password,
      );
      terminal.write('Connected\r\n');

      session = await sshClient!.shell(
        pty: SSHPtyConfig(
          width: terminal.viewWidth,
          height: terminal.viewHeight,
        ),
      );

      terminal.buffer.clear();
      terminal.buffer.setCursor(0, 0);

      terminal.onOutput = (data) {
        session!.write(utf8.encode(data) as Uint8List);
      };

      session!.stdout
          .cast<List<int>>()
          .transform(Utf8Decoder())
          .listen(terminal.write);

      session!.stderr
          .cast<List<int>>()
          .transform(Utf8Decoder())
          .listen(terminal.write);

      session!.done.then((_) {
        isConnected = false;
        isExit = true;

        notifyListeners();
      });

      isConnected = true;
      notifyListeners();
      return;
    } catch (e) {
      if (session != null) session?.close();
      if (sshClient != null) sshClient?.close();
      if (socket != null) await socket?.close();
      terminal.write('Error: $e\r\n');
      isConnected = false;
      NavigationService.navigateTo('/dashboard');
      NotificationsService.showSnackbarError(e.toString());

      notifyListeners();
      throw e;
    } finally {
      // La lógica de limpieza siempre se ejecuta, independientemente de si ocurrió una excepción o no
      if (sshClient == null || session == null || !isConnected) {
        // Solo intenta cerrar los recursos si no se estableció una conexión exitosa
        session?.close(); // Es seguro llamar close incluso si ya está cerrado
        sshClient?.close();
        await socket?.close();

        // Asegúrate de actualizar el estado de la UI si es necesario

        isConnected = false;
        notifyListeners();
      }
    }
  }

  Future<void> closeConnection() async {
    // Si hay una sesión activa, la cierras.
    if (session != null) {
      session?.close();
      session = null; // Limpiar la referencia a la sesión.
    }

    // Si hay un cliente SSH, lo cierras.
    if (sshClient != null) {
      sshClient?.close();
      sshClient = null; // Limpiar la referencia al cliente SSH.
    }

    // Si hay un socket abierto, también lo cierras.
    if (socket != null) {
      await socket?.close();
      socket = null; // Limpiar la referencia al socket.
    }

    // Actualizar el estado para reflejar que la conexión está cerrada.
    isConnected = false;
    isExit = true;
    notifyListeners(); // Notificar a los oyentes sobre el cambio de estado.
  }
}
