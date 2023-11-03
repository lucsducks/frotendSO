import 'package:dashboardadmin/models/http/host_response.dart';
import 'package:dashboardadmin/providers/auth_provider.dart';
import 'package:dashboardadmin/providers/sshconexion_provider.dart';
import 'package:dashboardadmin/services/notificacion_service.dart';
import 'package:dashboardadmin/ui/buttons/custom_outlined_button.dart';
import 'package:dashboardadmin/ui/inputs/custom_inputs.dart';
import 'package:dashboardadmin/ui/labels/custom_labels.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ConexionModal extends StatefulWidget {
  final Conexiones? conexion;

  const ConexionModal({Key? key, this.conexion}) : super(key: key);

  @override
  _ConexionModalState createState() => _ConexionModalState();
}

class _ConexionModalState extends State<ConexionModal> {
  String nombre = '';
  String usuario = '';
  String owner = '';
  String password = '';
  String direccionip = '';
  String port = '22';
  String? id;
  final List<String> iconsList = [
    'assets/icons/sound_file.svg',
    'assets/icons/server.svg',
    'assets/icons/excel_file.svg',
  ];
  String? selectedIconPath;

  @override
  void initState() {
    super.initState();
    id = widget.conexion?.id;
    nombre = widget.conexion?.nombre ?? '';
    usuario = widget.conexion?.usuario ?? '';
    owner = widget.conexion?.owner ?? '';
    password = widget.conexion?.password ?? '';
    direccionip = widget.conexion?.direccionip ?? '';
    port = (widget.conexion?.port ?? 22).toString();
    selectedIconPath = 'assets/icons/server.svg';
  }

  @override
  Widget build(BuildContext context) {
    final conexionHostProvider =
        Provider.of<sshConexionProvider>(context, listen: false);
    final user = Provider.of<AuthProvider>(context).user!;
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          height: MediaQuery.of(context).size.height,
          width: screenWidth < 700 ? screenWidth : 350,
          decoration: buildBoxDecoration(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Host',
                    style: CustomLabels.h1.copyWith(color: Colors.blue),
                  ),
                  DropdownButton<String>(
                    value: selectedIconPath,
                    items: iconsList.map((String path) {
                      return DropdownMenuItem<String>(
                        value: path,
                        child: SvgPicture.asset(path,
                            width: 24,
                            height:
                                24), // Puedes ajustar el tamaño según lo que necesites
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedIconPath = newValue;
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.blue,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              TextFormField(
                initialValue: widget.conexion?.nombre ?? '',
                onChanged: (value) => nombre = value,
                decoration: CustomInputs.loginInputDecoration(
                  hint: 'Nombre de la conexion',
                  label: 'nombre',
                  icon: Icons.new_releases_outlined,
                ).copyWith(
                  fillColor: Colors.white24,
                  filled: true,
                  hintStyle:
                      TextStyle(color: const Color.fromARGB(153, 62, 61, 61)),
                  labelStyle:
                      TextStyle(color: const Color.fromARGB(179, 66, 65, 65)),
                ),
                style: TextStyle(color: const Color.fromARGB(255, 78, 78, 78)),
              ),
              TextFormField(
                initialValue: widget.conexion?.direccionip ?? '',
                onChanged: (value) => direccionip = value,
                decoration: CustomInputs.loginInputDecoration(
                  hint: 'Direccion ip o dominio del host',
                  label: 'direccion ip o dominio',
                  icon: Icons.new_releases_outlined,
                ).copyWith(
                  fillColor: Colors.white24,
                  filled: true,
                  hintStyle:
                      TextStyle(color: const Color.fromARGB(153, 62, 61, 61)),
                  labelStyle:
                      TextStyle(color: const Color.fromARGB(179, 66, 65, 65)),
                ),
                style: TextStyle(color: const Color.fromARGB(255, 78, 78, 78)),
              ),
              TextFormField(
                initialValue: (widget.conexion?.port ?? '22').toString(),
                onChanged: (value) => port = value,
                decoration: CustomInputs.loginInputDecoration(
                  hint: 'Puerto del host',
                  label: 'Puerto',
                  icon: Icons.new_releases_outlined,
                ).copyWith(
                  fillColor: Colors.white24,
                  filled: true,
                  hintStyle:
                      TextStyle(color: const Color.fromARGB(153, 62, 61, 61)),
                  labelStyle:
                      TextStyle(color: const Color.fromARGB(179, 66, 65, 65)),
                ),
                style: TextStyle(color: const Color.fromARGB(255, 78, 78, 78)),
              ),
              TextFormField(
                initialValue: widget.conexion?.usuario ?? '',
                onChanged: (value) => usuario = value,
                decoration: CustomInputs.loginInputDecoration(
                  hint: 'Nombre del usuario',
                  label: 'usuario',
                  icon: Icons.new_releases_outlined,
                ).copyWith(
                  fillColor: Colors.white24,
                  filled: true,
                  hintStyle:
                      TextStyle(color: const Color.fromARGB(153, 62, 61, 61)),
                  labelStyle:
                      TextStyle(color: const Color.fromARGB(179, 66, 65, 65)),
                ),
                style: TextStyle(color: const Color.fromARGB(255, 78, 78, 78)),
              ),
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                initialValue: widget.conexion?.password ?? '',
                onChanged: (value) => password = value,
                decoration: CustomInputs.loginInputDecoration(
                  hint: 'Password del usuario',
                  label: 'password',
                  icon: Icons.new_releases_outlined,
                ).copyWith(
                  fillColor: Colors.white24,
                  filled: true,
                  hintStyle:
                      TextStyle(color: const Color.fromARGB(153, 62, 61, 61)),
                  labelStyle:
                      TextStyle(color: const Color.fromARGB(179, 66, 65, 65)),
                ),
                style: TextStyle(color: const Color.fromARGB(255, 78, 78, 78)),
              ),
              SizedBox(height: 20),
              CustomOutlinedButton(
                onPressed: () async {
                  int? portNumber = int.tryParse(port);
                  if (portNumber == null) {
                    NotificationsService.showSnackbarError(
                        'El puerto debe ser un número');
                    return;
                  }
                  if (id == null) {
                    try {
                      owner = user.id;
                      print(port);

                      await conexionHostProvider.postConexion(nombre, usuario,
                          owner, direccionip, portNumber, password);
                      NotificationsService.showSnackbar('Creado Exitosamente!');

                      Navigator.of(context).pop();
                    } catch (e) {
                      Navigator.of(context).pop();
                      NotificationsService.showSnackbarError(e.toString());
                    }
                  } else {
                    try {
                      await conexionHostProvider.actualizarConexion(
                          nombre,
                          usuario,
                          id!,
                          direccionip,
                          password,
                          portNumber,
                          owner);
                      NotificationsService.showSnackbar(
                          'Actualizado Exitosamente!');

                      Navigator.of(context).pop();
                    } catch (e) {
                      Navigator.of(context).pop();
                      NotificationsService.showSnackbarError(e.toString());
                    }
                  }
                },
                text: 'Guardar',
                color: Colors.blue,
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration buildBoxDecoration() => BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black26, spreadRadius: 1, blurRadius: 5)
        ],
      );
}
