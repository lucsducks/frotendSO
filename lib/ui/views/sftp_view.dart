import 'dart:io';
import 'dart:typed_data';

import 'package:dartssh2/dartssh2.dart';
import 'package:dashboardadmin/providers/sftp_provider.dart';
import 'package:dashboardadmin/services/notificacion_service.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class SftpView extends StatefulWidget {
  final String hostid;
  final String password;
  final String direccionip;
  final String usuario;
  final int port;
  final VoidCallback onBackToList;
  final String ownerid;

  const SftpView(
      {super.key,
      required this.hostid,
      required this.password,
      required this.direccionip,
      required this.usuario,
      required this.port,
      required this.onBackToList,
      required this.ownerid});
  @override
  _SftpViewState createState() => _SftpViewState();
}

class _SftpViewState extends State<SftpView> {
  ValueNotifier<bool> shouldNavigateToDashboard = ValueNotifier(false);
  List<SftpFileDetails> files = [];
  String? remotePath;
  String? localFileName;
  late Offset _tapPosition;
  String? selectedDirectory;
  bool isconnected = false;
  bool _triedToSubmit = false;

  @override
  void initState() {
    super.initState();
    initSFTP();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<SSHClient?> createClient() async {
    try {
      var socket = await SSHSocket.connect(widget.direccionip, widget.port);
      return SSHClient(socket,
          username: widget.usuario, onPasswordRequest: () => widget.password);
    } on SocketException catch (e) {
      NotificationsService.showSnackbarError(
          'Error al conectar con el servidor');
      return null; // Devuelve null si la conexión falla
    }
  }

  void closeConnections(
      SSHClient? client, SftpClient? sftp, SSHSocket? socket) async {
    try {
      sftp?.close();
      client?.close();
      await socket?.close();
    } catch (e) {
      NotificationsService.showSnackbarError('Error al cerrar la conexión: $e');
    }
  }

  initSFTP({String path = './'}) async {
    SSHClient? client;
    SftpClient? sftp;
    SSHSocket? socket;
    try {
      client = await createClient();
      if (client == null) {
        setState(() {
          isconnected = false;
          widget.onBackToList();
        });
        return;
      }
      sftp = await client.sftp();
      listDirectories(path, sftp);

      var filess = await sftp.listdir(path);

      setState(() {
        isconnected = true;
        files = filess.map((item) {
          final permissions = item.longname.split(' ')[0];
          return SftpFileDetails(name: item.filename, permissions: permissions);
        }).toList();
        selectedDirectory = path;
      });
    } catch (e) {
      NotificationsService.showSnackbarError(
          'Error al conectar con el servidor');
      setState(() {
        isconnected = false;
        widget.onBackToList();
      });
      return;
    } finally {
      closeConnections(client, sftp, socket);
    }
  }

  void onFileLongPress(BuildContext context, SftpFileDetails fileDetail) {
    final RenderBox overlay =
        Overlay.of(context)!.context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      _tapPosition & const Size(40, 40), // Smaller rect, the touch area
      Offset.zero & overlay.size, // Bigger rect, the entire screen
    );

    showMenu<String>(
      context: context,
      position: position,
      items: [
        _buildMenuItem(Icons.note_add, 'Crear archivo', 'create', Colors.green),
        _buildMenuItem(
            Icons.cloud_upload, 'Subir archivo', 'upload', Colors.blue),
        _buildMenuItem(Icons.create_new_folder, 'Crear carpeta',
            'createDirectory', Colors.orange),
        _buildMenuItem(
            Icons.cloud_download, 'Descargar', 'download', Colors.lightBlue),
        PopupMenuDivider(height: 10),
        _buildMenuItem(Icons.delete_forever, 'Eliminar', 'delete', Colors.red),
      ],
    ).then((value) => handleMenuAction(value, fileDetail, context));
  }

  PopupMenuEntry<String> _buildMenuItem(
      IconData icon, String text, String value, Color color) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 10),
          Text(text),
        ],
      ),
    );
  }

  void handleMenuAction(
      String? value, SftpFileDetails fileDetail, BuildContext context) {
    switch (value) {
      case 'create':
        onAddFileButtonPressed();
        break;
      case 'createDirectory':
        onAddDirectoryButtonPressed();
        break;
      case 'upload':
        selectAndUploadFile(fileDetail.name);
        break;
      case 'download':
        downloadFileFromServer(fileDetail.name);
        break;
      case 'delete':
        confirmDelete(context, fileDetail);
        break;
    }
  }

  void onAddFileButtonPressed() {
    TextEditingController _newFileNameController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Crear nuevo archivo'),
          content: TextField(
            autofocus: true,
            controller: _newFileNameController,
            decoration: InputDecoration(
              hintText: "Ingrese el nombre del archivo",
              border:
                  OutlineInputBorder(), // Agrega un borde para definir mejor el campo
              errorText: _newFileNameController.text.isEmpty && _triedToSubmit
                  ? 'El nombre no puede estar vacío'
                  : null,
            ),
            onSubmitted: (_) => _submitFileName(_newFileNameController.text),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.red),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Crear'),
              onPressed: () => _submitFileName(_newFileNameController.text),
            ),
          ],
        );
      },
    );
  }

  void _submitFileName(String fileName) {
    if (fileName.isNotEmpty) {
      String fullPath = '${selectedDirectory}/$fileName';
      createFile(fullPath);
      Navigator.of(context).pop();
    } else {
      setState(() {
        _triedToSubmit =
            true; // Una variable de estado que se pone a true cuando se intenta enviar el formulario
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('El nombre del archivo no puede estar vacío'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void onAddDirectoryButtonPressed() {
    TextEditingController _newDirectoryNameController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Crear nueva carpeta'),
          content: TextField(
            autofocus: true,
            controller: _newDirectoryNameController,
            decoration: InputDecoration(
              hintText: "Ingrese el nombre de la carpeta",
              border: OutlineInputBorder(),
            ),
            onSubmitted: (_) =>
                _submitDirectoryName(_newDirectoryNameController.text),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.red),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Crear'),
              onPressed: () =>
                  _submitDirectoryName(_newDirectoryNameController.text),
            ),
          ],
        );
      },
    );
  }

  void _submitDirectoryName(String directoryName) {
    directoryName = directoryName
        .trim(); // Quita espacios en blanco al principio y al final
    if (directoryName.isNotEmpty) {
      String fullPath = '${selectedDirectory}/$directoryName';
      createDirectory(fullPath);
      Navigator.of(context).pop();
    } else {
      NotificationsService.showSnackbarError(
          'El nombre de la carpeta no puede estar vacío');
    }
  }

  void confirmDelete(BuildContext context, SftpFileDetails fileDetail) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content:
              Text('¿Estás seguro de que quieres eliminar ${fileDetail.name}?'),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
            ),
            ElevatedButton(
              child: const Text('Eliminar'),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
                deleteFile(
                    '${selectedDirectory}/${fileDetail.name}'); // Elimina el archivo
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> listDirectories(String path, SftpClient sftp) async {
    if (sftp == null) {
      print('SFTP client is null');
      return;
    }
    try {
      final items = await sftp.listdir(path);
      List<SftpFileDetails> fileDetailsList = items.map((item) {
        final permissions = item.longname.split(' ')[0];
        return SftpFileDetails(name: item.filename, permissions: permissions);
      }).toList();

      // Separar los directorios de los archivos
      var directories = fileDetailsList
          .where((item) => item.permissions.startsWith('d'))
          .toList();
      var files = fileDetailsList
          .where((item) => !item.permissions.startsWith('d'))
          .toList();

      directories
          .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      files
          .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

      fileDetailsList = directories + files;

      setState(() {
        this.files = fileDetailsList;
      });
    } catch (e) {
      NotificationsService.showSnackbar('Error al listar directorios: $e');
    }
  }

  Future<void> deleteFile(String path) async {
    SSHClient? client;
    SftpClient? sftp;
    SSHSocket? socket;
    try {
      client = await createClient();
      if (client == null) {
        setState(() {
          isconnected = false;
          widget.onBackToList();
        });
        return;
      }
      sftp = await client.sftp();
      await sftp.remove(path);
      initSFTP(path: selectedDirectory!);
      NotificationsService.showSnackbarError('Archivo eliminado');
    } catch (e) {
      NotificationsService.showSnackbarError(
          'Error al eliminar el archivo: $e');
    } finally {
      closeConnections(client, sftp, socket);
    }
  }

  Future<void> createFile(String path) async {
    SSHClient? client;
    SftpClient? sftp;
    SSHSocket? socket;
    try {
      client = await createClient();
      if (client == null) {
        setState(() {
          isconnected = false;
          widget.onBackToList();
        });
        return;
      }
      sftp = await client.sftp();
      final file = await sftp.open(path,
          mode: SftpFileOpenMode.write | SftpFileOpenMode.create);
      await file.close();
      initSFTP(path: selectedDirectory!);
      NotificationsService.showSnackbar('Archivo creado');
    } catch (e) {
      NotificationsService.showSnackbarError('Error al crear el archivo: $e');
    } finally {
      closeConnections(client, sftp, socket);
    }
  }

  Future<void> createDirectory(String path) async {
    SSHClient? client;
    SftpClient? sftp;
    SSHSocket? socket;
    try {
      client = await createClient();
      if (client == null) {
        setState(() {
          isconnected = false;
          widget.onBackToList();
        });
        return;
      }
      sftp = await client.sftp();
      await sftp.mkdir(path);
      initSFTP(path: selectedDirectory!);
      NotificationsService.showSnackbar('Carpeta creado');
    } catch (e) {
      NotificationsService.showSnackbarError(
          'Error al crear la carpeta,Ya existe');
    } finally {
      closeConnections(client, sftp, socket);
    }
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

  //! Todavia no probado
  Future<void> transferFileBetweenServers(
    String sourceFilePath,
    String destinationFilePath,
    String destinationHost,
    String destinationUser,
    String destinationPassword,
    int destinationPort,
  ) async {
    Uint8List? fileData;

    try {
      var sourceClient = SSHClient(
        await SSHSocket.connect(widget.direccionip, widget.port),
        username: widget.usuario,
        onPasswordRequest: () => widget.password,
      );

      var sourceSftp = await sourceClient.sftp();
      var sourceFile = await sourceSftp.open(sourceFilePath);
      fileData = await sourceFile.readBytes();
      await sourceFile.close();
      sourceClient.close();
    } catch (e) {
      print('Error al descargar el archivo del servidor fuente: $e');
      return;
    }

    // Paso 2: Subir el archivo al servidor destino
    try {
      var destinationClient = SSHClient(
        await SSHSocket.connect(destinationHost, destinationPort),
        username: destinationUser,
        onPasswordRequest: () => destinationPassword,
      );

      var destinationSftp = await destinationClient.sftp();
      var destinationFile = await destinationSftp.open(destinationFilePath,
          mode: SftpFileOpenMode.create | SftpFileOpenMode.write);
      await destinationFile.write(Stream.value(fileData));
      await destinationFile.close();
      destinationClient.close();
    } catch (e) {
      print('Error al subir el archivo al servidor destino: $e');
      return;
    }
    print(
        'Archivo transferido con éxito del servidor fuente al servidor destino.');
  }

  void onfilePath(SftpName file) {
    String filePath = "${selectedDirectory}/${file.filename}";
    createFile(filePath);
  }

  Future<void> selectAndUploadFile(String remoteDirectoryPath) async {
    if (Platform.isAndroid && !(await _requestPermission(Permission.storage))) {
      NotificationsService.showSnackbarError(
          'Permiso de almacenamiento no concedido');
      return;
    }
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      String localFilePath = result.files.single.path!;
      String remoteFileName = result.files.single.name;
      String remoteFilePath = '$remoteDirectoryPath/$remoteFileName';
      await uploadFileToServer(localFilePath, remoteFilePath);
    } else {
      NotificationsService.showSnackbarError('No se seleccionó ningún archivo');
    }
  }

  Future<void> uploadFileToServer(
      String localFilePath, String remoteFilePath) async {
    SSHClient? client;
    SftpClient? sftp;
    SSHSocket? socket;
    try {
      client = await createClient();
      if (client == null) {
        setState(() {
          isconnected = false;
          widget.onBackToList();
        });
        return;
      }
      sftp = await client.sftp();
      final file = await sftp.open(remoteFilePath,
          mode: SftpFileOpenMode.create | SftpFileOpenMode.write);
      final localFileStream = File(localFilePath).openRead();
      await file.write(localFileStream.cast());
      await file.close();
      initSFTP(path: selectedDirectory!);
      NotificationsService.showSnackbar('Archivo subido con éxito');
    } catch (e) {
      NotificationsService.showSnackbarError('Error al subir el archivo: $e');
    } finally {
      closeConnections(client, sftp, socket);
    }
  }

  Future<void> downloadFileFromServer(String remotePath) async {
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage) == true) {
          NotificationsService.showSnackbar(
              'Permiso de almacenamiento concedido');
        } else {
          NotificationsService.showSnackbarError(
              'Permiso de almacenamiento no concedido');
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
          NotificationsService.showSnackbarError(
              'No se seleccionó ningún directorio');
          return;
        }
        String fileName = remotePath.split('/').last;
        final file = File('$directoryPath/$fileName');
        await file.writeAsBytes(fileContent);
        client.close();
        sftp.close();
        NotificationsService.showSnackbar('Archivo descargado');
      } else if (status.isPermanentlyDenied) {
        NotificationsService.showSnackbarError(
            'Por favor, habilita el permiso de almacenamiento en la configuración de la aplicación.');
      } else {
        NotificationsService.showSnackbarError(
            'Por favor, habilita el permiso de almacenamiento en la configuración de la aplicación.');
      }
    } catch (e) {
      NotificationsService.showSnackbarError('Error al descargar archivo: $e');
    }
  }

  void navigateBack() {
    if (selectedDirectory != './') {
      final parentDir = selectedDirectory!
          .split('/')
          .sublist(0, selectedDirectory!.split('/').length - 1)
          .join('/');
      setState(() {
        selectedDirectory = parentDir.isNotEmpty ? parentDir : './';
      });
      initSFTP(path: selectedDirectory!);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Accede al proveedor de SFTP

    return Scaffold(
      appBar: AppBar(
        title: Text('SFTP Directories'),
        actions: isconnected
            ? <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceEvenly, // Distribuye los botones de manera uniforme
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      color: Colors.blue, // O el color principal de tu app
                      tooltip:
                          'Atrás', // Texto que aparece al pasar el cursor por encima
                      onPressed: () {
                        navigateBack();
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.refresh),
                      color: Colors.green, // O el color principal de tu app
                      tooltip:
                          'Actualizar', // Texto que aparece al pasar el cursor por encima
                      onPressed: () {
                        initSFTP(path: selectedDirectory!);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.create_new_folder),
                      color: Colors.orange, //
                      tooltip: 'Crear floder',
                      onPressed: () {
                        onAddDirectoryButtonPressed();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.note_add),
                      color: Color.fromARGB(255, 11, 156, 23),
                      tooltip: 'Crear archivo',
                      onPressed: () {
                        onAddFileButtonPressed();
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.cloud_upload),
                      color: Colors.blue, // O el color principal de tu app
                      tooltip:
                          'Subir archivo', // Texto que aparece al pasar el cursor por encima
                      onPressed: () {
                        selectAndUploadFile(selectedDirectory!);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.exit_to_app),
                      color: Colors
                          .red, // Color que indica una acción potencialmente peligrosa
                      tooltip:
                          'Salir', // Texto que aparece al pasar el cursor por encima
                      onPressed: widget.onBackToList,
                    ),
                  ],
                )
              ]
            : <Widget>[Container()],
      ),
      body: isconnected
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(
                        8.0), // Añade padding alrededor de la lista
                    child: Material(
                      elevation: 1, // Añade sombra para dar profundidad
                      borderRadius:
                          BorderRadius.circular(8), // Bordes redondeados
                      child: ListView.separated(
                        itemCount: files.length,
                        separatorBuilder: (context, index) => Divider(
                            indent:
                                72), // Indenta los divisores para alinearlos con los títulos
                        itemBuilder: (BuildContext context, int index) {
                          final fileDetail = files[index];
                          var isDirectory =
                              fileDetail.permissions.startsWith('d');
                          var iconData = isDirectory
                              ? Icons.folder
                              : Icons
                                  .description; // Usa iconos de descripción para archivos

                          return InkWell(
                            onTap: () {
                              if (isDirectory) {
                                initSFTP(
                                    path:
                                        '${selectedDirectory}/${fileDetail.name}');
                              }
                            },
                            onTapDown: (TapDownDetails details) {
                              _tapPosition = details
                                  .globalPosition; // Guardar la posición del tap
                            },
                            onLongPress: () {
                              if (!isDirectory) {
                                onFileLongPress(context, fileDetail);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical:
                                      8.0), // Añade un poco de espacio vertical para cada elemento
                              child: ListTile(
                                leading: Icon(
                                  iconData,
                                  color: isDirectory
                                      ? Colors.amber
                                      : Colors.blue[300],
                                ),
                                title: Text(
                                  fileDetail.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight
                                        .w500, // Hace que el texto sea un poco más grueso
                                    color: Colors
                                        .grey[800], // Color de texto más suave
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  fileDetail.permissions,
                                  style: TextStyle(color: Colors.grey[500]),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}

class SftpFileDetails {
  String name;
  String permissions;

  SftpFileDetails({required this.name, required this.permissions});
  @override
  String toString() {
    return 'SftpFileDetails{name: $name, permissions: $permissions}';
  }
}