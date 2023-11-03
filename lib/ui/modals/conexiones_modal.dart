import 'package:dashboardadmin/models/http/host_response.dart';
import 'package:dashboardadmin/providers/auth_provider.dart';
import 'package:dashboardadmin/providers/sshconexion_provider.dart';
import 'package:dashboardadmin/services/notificacion_service.dart';
import 'package:dashboardadmin/ui/buttons/custom_filled_button.dart';
import 'package:dashboardadmin/ui/inputs/custom_inputs.dart';
import 'package:dashboardadmin/ui/labels/custom_labels.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  String? id;
  @override
  void initState() {
    super.initState();
    id = widget.conexion?.id;
    nombre = widget.conexion?.nombre ?? '';
    usuario = widget.conexion?.usuario ?? '';
    owner = widget.conexion?.owner ?? '';
    password = widget.conexion?.password ?? '';
    direccionip = widget.conexion?.direccionip ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final conexionHostProvider =
        Provider.of<sshConexionProvider>(context, listen: false);
    final user = Provider.of<AuthProvider>(context).user!;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      height: 400,
      width: 500,
      decoration: buildBoxDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.conexion?.nombre ?? 'Nueva Host',
                style: CustomLabels.h1.copyWith(color: Colors.white),
              ),
              IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          SizedBox(height: 10),
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
              hintStyle: TextStyle(color: Colors.white60),
              labelStyle: TextStyle(color: Colors.white70),
            ),
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 10),
          TextFormField(
            initialValue: widget.conexion?.direccionip ?? '',
            onChanged: (value) => direccionip = value,
            decoration: CustomInputs.loginInputDecoration(
              hint: 'Direccion ip del host',
              label: 'direccion ip',
              icon: Icons.new_releases_outlined,
            ).copyWith(
              fillColor: Colors.white24,
              filled: true,
              hintStyle: TextStyle(color: Colors.white60),
              labelStyle: TextStyle(color: Colors.white70),
            ),
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 10),
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
              hintStyle: TextStyle(color: Colors.white60),
              labelStyle: TextStyle(color: Colors.white70),
            ),
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 10),
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
              hintStyle: TextStyle(color: Colors.white60),
              labelStyle: TextStyle(color: Colors.white70),
            ),
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 20),
          CustomFilledButton(
            onPressed: () async {
              if (id == null) {
                try {
                  owner = user.id;

                  await conexionHostProvider.postConexion(
                      nombre, usuario, owner, direccionip, password);
                  NotificationsService.showSnackbar('Creado Exitosamente!');

                  Navigator.of(context).pop();
                } catch (e) {
                  Navigator.of(context).pop();
                  NotificationsService.showSnackbarError(e.toString());
                }
              } else {
                try {
                  await conexionHostProvider.actualizarConexion(
                      nombre, usuario, id!, direccionip, password, owner);
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
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  BoxDecoration buildBoxDecoration() => BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        color: Color.fromARGB(255, 54, 131, 255),
        boxShadow: [
          BoxShadow(color: Colors.black26, spreadRadius: 1, blurRadius: 5)
        ], // Ajuste del boxShadow
      );
}
