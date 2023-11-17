import 'dart:io';
import 'dart:typed_data';

import 'package:dartssh2/dartssh2.dart';
import 'package:dashboardadmin/providers/auth_provider.dart';
import 'package:dashboardadmin/providers/sshconexion_provider.dart';
import 'package:dashboardadmin/services/notificacion_service.dart';
import 'package:dashboardadmin/ui/cards/host_card.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:dashboardadmin/ui/inputs/custom_inputs.dart';

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
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    Provider.of<sshConexionProvider>(context, listen: false)
        .getconexionesHost(user!.id);
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

  void _mostrarListaConexiones(BuildContext context, String filePath) {
    final conexiones =
        Provider.of<sshConexionProvider>(context, listen: false).conexiones;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          title: Text(
            'Seleccione una conexión',
            style: GoogleFonts.poppins(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
              color: const Color.fromARGB(255, 7, 31, 78),
            ),
          ),
          content: Container(
            width: double.maxFinite, // Esto asegura que el diálogo sea ancho
            child: ListView.builder(
              shrinkWrap:
                  true, // Esto es necesario para que ListView funcione dentro de un diálogo
              itemCount: conexiones.length,
              itemBuilder: (BuildContext context, int index) {
                final e = conexiones[index];
                return HostCard(
                  direccionIp: e.direccionip,
                  nombre: e.nombre,
                  port: e.port,
                  img: e.img,
                  password: e.password,
                  usuariohost: e.usuario,
                  idHost: e.id,
                  estado: e.estado,
                  owner: e.owner,
                  v: e.v,
                  fechaCreacion: e.fechaCreacion,
                  onTap: () {
                    transferFileBetweenServers(
                        filePath, e.direccionip, e.usuario, e.password, e.port);
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: Text(
                'Cancelar',
                style: GoogleFonts.poppins(
                  fontSize: 16.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.red,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
            ),
          ],
        );
      },
    );
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
        _buildMenuItem(Icons.create_new_folder, 'Crear carpeta',
            'createDirectory', Colors.orange),
        _buildMenuItem(Icons.note_add, 'Crear archivo', 'create', Colors.green),
        _buildMenuItem(Icons.upload, 'Subir archivo', 'upload', Colors.blue),
        _buildMenuItem(
            Icons.download, 'Descargar', 'download', Colors.lightBlue),
        _buildMenuItem(Icons.delete_forever, 'Eliminar', 'delete', Colors.red),
        _buildMenuItem(Icons.settings_ethernet, 'Transferir', 'showConexiones',
            Colors.grey),
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
          Text(
            text,
            style:
                GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400),
          ),
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
        downloadFileFromServer('${selectedDirectory}/${fileDetail.name}');
        break;
      case 'delete':
        confirmDelete(context, fileDetail);
        break;
      case 'showConexiones':
        _mostrarListaConexiones(context, fileDetail.name);
        break;
    }
  }

  void onAddFileButtonPressed() {
    TextEditingController _newFileNameController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          title: Text(
            'Crear nuevo archivo',
            style: GoogleFonts.poppins(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
              color: const Color.fromARGB(255, 7, 31, 78),
            ),
          ),
          content: TextField(
            autofocus: true,
            controller: _newFileNameController,
            style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: const Color.fromARGB(255, 7, 31, 78)),
            decoration: CustomInputs.loginInputDecoration(
                    hint: 'Ingrese el nombre del archivo',
                    label: 'Nombre del archivo',
                    icon: Icons.insert_drive_file)
                .copyWith(
              errorText: _newFileNameController.text.isEmpty && _triedToSubmit
                  ? 'El nombre no puede estar vacío'
                  : null,
            ),
            onSubmitted: (_) => _submitFileName(_newFileNameController.text),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: Text(
                'Cancelar',
                style: GoogleFonts.poppins(
                  fontSize: 16.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.red,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 10, 125, 243),
              ),
              child: Text(
                'Crear',
                style: GoogleFonts.poppins(
                  fontSize: 16.0,
                  fontWeight: FontWeight.normal,
                  color: const Color.fromARGB(255, 10, 125, 243),
                ),
              ),
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
        const SnackBar(
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          title: Text(
            'Crear nuevo carpeta',
            style: GoogleFonts.poppins(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
              color: const Color.fromARGB(255, 7, 31, 78),
            ),
          ),
          content: TextField(
            autofocus: true,
            controller: _newDirectoryNameController,
            decoration: CustomInputs.loginInputDecoration(
                hint: 'Ingrese el nombre de la carpeta',
                label: 'Nombre de la carpeta',
                icon: Icons.folder_rounded),
            onSubmitted: (_) =>
                _submitDirectoryName(_newDirectoryNameController.text),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: Text(
                'Cancelar',
                style: GoogleFonts.poppins(
                  fontSize: 16.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.red,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 10, 125, 243),
              ),
              child: Text(
                'Crear',
                style: GoogleFonts.poppins(
                  fontSize: 16.0,
                  fontWeight: FontWeight.normal,
                  color: const Color.fromARGB(255, 10, 125, 243),
                ),
              ),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          title: Text(
            'Confirmar eliminación',
            style: GoogleFonts.poppins(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
              color: const Color.fromARGB(255, 7, 31, 78),
            ),
          ),
          content: Text(
            '¿Estás seguro de que quieres eliminar ${fileDetail.name}?',
            style: GoogleFonts.poppins(
              fontSize: 16.0,
              fontWeight: FontWeight.normal,
              color: const Color.fromARGB(255, 133, 133, 133),
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: Text(
                'Cancelar',
                style: GoogleFonts.poppins(
                  fontSize: 16.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.red,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 10, 125, 243),
              ),
              child: Text(
                'Aceptar',
                style: GoogleFonts.poppins(
                  fontSize: 16.0,
                  fontWeight: FontWeight.normal,
                  color: const Color.fromARGB(255, 10, 125, 243),
                ),
              ),
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
    print(path);
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
      NotificationsService.showSnackbar('Carpeta creada');
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

  Future<void> transferFileBetweenServers(
    String sourceFilePath,
    String destinationHost,
    String destinationUser,
    String destinationPassword,
    int destinationPort,
  ) async {
    Uint8List? fileData;

    String destinationDirectory = './/izifileDownload';
    String filename = sourceFilePath.split('/').last;
    String destinationFilePath = '$destinationDirectory/$filename';

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
    try {
      var destinationClient = SSHClient(
        await SSHSocket.connect(destinationHost, destinationPort),
        username: destinationUser,
        onPasswordRequest: () => destinationPassword,
      );

      var destinationSftp = await destinationClient.sftp();

      try {
        await destinationSftp.mkdir(destinationDirectory);
      } catch (e) {
        // Maneja específicamente el error de "directorio ya existe" aquí
        print('El directorio ya existe o no se pudo crear: $e');
        // No necesitas retornar aquí, el proceso puede continuar
      }

      var destinationFile = await destinationSftp.open(destinationFilePath,
          mode: SftpFileOpenMode.create | SftpFileOpenMode.write);
      await destinationFile.write(Stream.value(fileData));
      await destinationFile.close();
      destinationClient.close();
      initSFTP(path: selectedDirectory!);
      NotificationsService.showSnackbar('Archivo transferido con éxito');
    } catch (e) {
      print('Error al subir el archivo al servidor destino: $e');
      return;
    }
    NotificationsService.showSnackbar('Archivo transferido con éxito');
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
        print(fileName);
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

  Future<String> resolveSymbolicLinkPath(String path) async {
    SSHClient? client;
    SftpClient? sftp;
    try {
      client = await createClient();
      if (client == null) {
        throw Exception('No se pudo crear el cliente SSH');
      }
      sftp = await client.sftp();

      // Usa la función readlink para obtener la ruta a la que apunta el enlace simbólico
      final targetPath = await sftp.readlink(path);
      return targetPath;
    } catch (e) {
      print('Error al resolver el enlace simbólico: $e');
      return path; // Devuelve la ruta original si no se puede resolver el enlace
    } finally {
      closeConnections(client, sftp, null);
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('SFTP Directories'),
        actions: isconnected
            ? <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceEvenly, // Distribuye los botones de manera uniforme
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      color: Colors.blue, // O el color principal de tu app
                      tooltip:
                          'Atrás', // Texto que aparece al pasar el cursor por encima
                      onPressed: () {
                        navigateBack();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      color: Colors.green, // O el color principal de tu app
                      tooltip:
                          'Actualizar', // Texto que aparece al pasar el cursor por encima
                      onPressed: () {
                        initSFTP(path: selectedDirectory!);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.create_new_folder),
                      color: Colors.orange, //
                      tooltip: 'Crear floder',
                      onPressed: () {
                        onAddDirectoryButtonPressed();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.note_add),
                      color: const Color.fromARGB(255, 11, 156, 23),
                      tooltip: 'Crear archivo',
                      onPressed: () {
                        onAddFileButtonPressed();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.upload),
                      color: Colors.blue, // O el color principal de tu app
                      tooltip:
                          'Subir archivo', // Texto que aparece al pasar el cursor por encima
                      onPressed: () {
                        selectAndUploadFile(selectedDirectory!);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.exit_to_app),
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
                        separatorBuilder: (context, index) => const Divider(
                            indent:
                                72), // Indenta los divisores para alinearlos con los títulos
                        itemBuilder: (BuildContext context, int index) {
                          final fileDetail = files[index];
                          var isDirectory =
                              fileDetail.permissions.startsWith('d');
                          var isSymbolicLink =
                              fileDetail.permissions.startsWith('l');

                          var iconData = isDirectory || isSymbolicLink
                              ? Icons.folder
                              : Icons
                                  .description; // Usa iconos de descripción para archivos

                          return InkWell(
                            onTap: () {
                              if (isDirectory || isSymbolicLink) {
                                (() async {
                                  try {
                                    var newPath = isDirectory
                                        ? '${selectedDirectory}/${fileDetail.name}'
                                        : await resolveSymbolicLinkPath(
                                            '${selectedDirectory}/${fileDetail.name}');
                                    initSFTP(path: newPath);
                                  } catch (e) {
                                    print('Error: $e');
                                    // Opcionalmente manejar el error aquí
                                  }
                                })();
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
                                  color: isDirectory || isSymbolicLink
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
          : const Center(child: CircularProgressIndicator()),
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
