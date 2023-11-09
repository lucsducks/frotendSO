import 'dart:io';

import 'package:dartssh2/dartssh2.dart';
import 'package:dashboardadmin/providers/sftp_provider.dart';
import 'package:dashboardadmin/providers/sshconexion_provider.dart';
import 'package:dashboardadmin/providers/terminal_provider.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:dashboardadmin/ui/cards/white_card.dart';
import 'package:dashboardadmin/ui/labels/custom_labels.dart';

class SftpView extends StatefulWidget {
  final String hostid;
  final String password;
  final String direccionip;
  final String usuario;
  final int port;

  final String ownerid;

  const SftpView(
      {super.key,
      required this.hostid,
      required this.password,
      required this.direccionip,
      required this.usuario,
      required this.port,
      required this.ownerid});

  @override
  _SftpViewState createState() => _SftpViewState();
}

class _SftpViewState extends State<SftpView> {
  ValueNotifier<bool> shouldNavigateToDashboard = ValueNotifier(false);
  List<SftpName> files = [];
  String? remotePath;
  String? localFileName;
  String? selectedDirectory;
  @override
  void initState() {
    super.initState();
    initSFTP();
  }

  @override
  void dispose() {
    super.dispose();
  }

  initSFTP({String path = './'}) async {
    SSHClient? client;
    SftpClient? sftp;

    try {
      client = SSHClient(
        await SSHSocket.connect(widget.direccionip, widget.port),
        username: widget.usuario,
        onPasswordRequest: () => widget.password,
      );

      sftp = await client.sftp();
      listDirectories(path, sftp);

      var files = await sftp!.listdir(path);

      setState(() {
        this.files = files;
        this.selectedDirectory = path;
      });
    } catch (e) {
      print('Error al conectar con SFTP: $e');
      // Considera usar un SnackBar o algún otro mecanismo para mostrar el error en la UI.
    } finally {
      sftp?.close();
    }
  }

  Future<void> listDirectories(String path, SftpClient sftp) async {
    if (sftp == null) {
      print('Cliente SFTP no está conectado.');
      return;
    }

    try {
      final items = await sftp!.listdir(path);
      files = items.where((item) {
        return item.longname.startsWith('d');
      }).toList();
    } catch (e) {
      print('Error al listar directorios: $e');
    }
  }

  void onFileDoubleTap(SftpName file) {
    String filePath = "${selectedDirectory}/${file.filename}";
    print('Double tap on file: $filePath');
    downloadFileFromServer(filePath);
  }

  Future<bool> _requestPermission(Permission permission) async {
    AndroidDeviceInfo build = await DeviceInfoPlugin().androidInfo;
    if (build.version.sdkInt >= 30) {
      var re = await Permission.manageExternalStorage.request();
      if (re.isGranted) {
        return true;
      } else {
        return false;
      }
    } else {
      if (await permission.isGranted) {
        return true;
      } else {
        var result = await permission.request();
        if (result.isGranted) {
          return true;
        } else {
          return false;
        }
      }
    }
  }

  Future<void> downloadFileFromServer(String remotePath) async {
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage) == true) {
          print("Permission is granted");
        } else {
          print("permission is not granted");
        }
      }
      PermissionStatus status =
          await Permission.manageExternalStorage.request();

      if (status.isGranted) {
        final client = SSHClient(
          await SSHSocket.connect(widget.direccionip, widget.port),
          username: widget.usuario,
          onPasswordRequest: () => widget.password,
        );

        final sftp = await client.sftp();
        final remoteFile = await sftp.open(remotePath);
        final fileContent = await remoteFile.readBytes();

        final directoryPath = await FilePicker.platform.getDirectoryPath();

        if (directoryPath == null) {
          return;
        }

        String fileName = remotePath.split('/').last;

        final file = File('$directoryPath/$fileName');
        await file.writeAsBytes(fileContent);

        client.close();
        sftp.close();
      } else if (status.isPermanentlyDenied) {
      } else {}
    } catch (e) {}
  }

  void navigateBack() {
    if (selectedDirectory != './') {
      // Obtén el directorio padre
      final parentDir = selectedDirectory!
          .split('/')
          .sublist(0, selectedDirectory!.split('/').length - 1)
          .join('/');
      // Actualiza el directorio seleccionado
      setState(() {
        selectedDirectory = parentDir.isNotEmpty ? parentDir : './';
      });
      // Actualiza la lista de directorios
      initSFTP(path: selectedDirectory!);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Accede al proveedor de SFTP
    final sftpProvider = Provider.of<SftpProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('SFTP Directories'),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              navigateBack();
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              initSFTP(path: selectedDirectory!);
            },
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              // Desconecta la sesión SFTP
              sftpProvider.disconnect();
              // Navega al dashboard
              Navigator.pushNamed(context, '/dashboard');
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Material(
              child: ListView.separated(
                itemCount: files.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (BuildContext context, int index) {
                  final file = files[index];
                  var isDirectory = file.longname.startsWith('d');
                  return InkWell(
                    onDoubleTap: () {
                      if (isDirectory) {
                        initSFTP(path: '${selectedDirectory}/${file.filename}');
                      }
                    },
                    // onDoubleTap: () {
                    //   if (!isDirectory) {
                    //     onFileDoubleTap(file);
                    //   }
                    // },
                    onLongPress: () {
                      if (!isDirectory) {
                        onFileDoubleTap(file);
                      }
                    },
                    child: ListTile(
                      leading: Icon(
                        isDirectory ? Icons.folder : Icons.insert_drive_file,
                        color: isDirectory ? Colors.amber : Colors.blue,
                      ),
                      title: Text(
                        file.filename,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight:
                              isDirectory ? FontWeight.bold : FontWeight.normal,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
