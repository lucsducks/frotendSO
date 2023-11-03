import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dartssh2/dartssh2.dart';
import 'package:xterm/xterm.dart';

class TerminalProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late Terminal terminal;
  bool isConnected = false;
  bool isExit = false;
  SSHClient? sshClient;
  Function onCommandEntered = () {};

  TerminalProvider() {
    terminal = Terminal();
  }

  void initTerminal({
    required String host,
    required int port,
    required String username,
    required String password,
  }) async {
    try {
      isExit = false;
      terminal.write('Connecting...\r\n');

      sshClient = SSHClient(
        await SSHSocket.connect(host, port),
        username: username,
        onPasswordRequest: () => password,
      );

      terminal.write('Connected\r\n');

      final session = await sshClient!.shell(
        pty: SSHPtyConfig(
          width: terminal.viewWidth,
          height: terminal.viewHeight,
        ),
      );

      terminal.buffer.clear();
      terminal.buffer.setCursor(0, 0);

      terminal.onOutput = (data) {
        session.write(utf8.encode(data) as Uint8List);
      };

      session.stdout
          .cast<List<int>>()
          .transform(Utf8Decoder())
          .listen(terminal.write);

      session.stderr
          .cast<List<int>>()
          .transform(Utf8Decoder())
          .listen(terminal.write);

      session.done.then((_) {
        isConnected = false;
        isExit = true;
        notifyListeners();
      });

      isConnected = true;
      notifyListeners();
    } catch (e) {
      terminal.write('Error: $e\r\n');
      isConnected = false;
      notifyListeners();
    }
  }
}
