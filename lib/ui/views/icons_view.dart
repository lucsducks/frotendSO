import 'package:dashboardadmin/providers/sftp_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dashboardadmin/ui/cards/white_card.dart';
import 'package:dashboardadmin/ui/labels/custom_labels.dart';

class IconsView extends StatefulWidget {
  @override
  _IconsViewState createState() => _IconsViewState();
}

class _IconsViewState extends State<IconsView> {
  final _hostController = TextEditingController(text: 'example.com');
  final _portController = TextEditingController(text: '22');
  final _usernameController = TextEditingController(text: 'user');
  final _passwordController = TextEditingController(text: 'pass');

  @override
  void dispose() {
    _hostController.dispose();
    _portController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _connectAndListDirectories() {
    final String host = _hostController.text;
    final int port = int.tryParse(_portController.text) ??
        22; // Default to port 22 if not specified
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    // Obtén el proveedor de SFTP y llama a connectSftp
    final sftpProvider = Provider.of<SftpProvider>(context, listen: false);
    sftpProvider
        .connectSftp(
      host: host,
      port: port,
      username: username,
      password: password,
    )
        .then((_) {
      // Luego de conectar, lista los directorios
      sftpProvider.listDirectories('/');
    }).catchError((error) {
      // Maneja el error de conexión aquí
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al conectar: $error')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Accede al proveedor de SFTP
    final sftpProvider = Provider.of<SftpProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('SFTP Directories'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _hostController,
                  decoration: InputDecoration(labelText: 'Host'),
                ),
                TextField(
                  controller: _portController,
                  decoration: InputDecoration(labelText: 'Puerto'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(labelText: 'Nombre de usuario'),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Contraseña'),
                  obscureText: true,
                ),
                ElevatedButton(
                  onPressed: _connectAndListDirectories,
                  child: Text('Conectar y Listar Directorios'),
                ),
              ],
            ),
          ),
          Expanded(
            child: sftpProvider.directories.isEmpty
                ? Center(child: Text('No hay directorios para mostrar.'))
                : ListView.builder(
                    itemCount: sftpProvider.directories.length,
                    itemBuilder: (context, index) {
                      final directory = sftpProvider.directories[index];
                      return ListTile(
                        leading: Icon(Icons.folder, color: Colors.amber),
                        title: Text(directory
                            .filename), // Asumiendo que 'filename' es el nombre del directorio
                        onTap: () {
                          // Aquí puedes manejar la acción cuando se toca un directorio, por ejemplo, navegar a él
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
