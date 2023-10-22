import 'package:dashboardadmin/models/usuario.dart';
import 'package:dashboardadmin/providers/usuario_provider.dart';
import 'package:dashboardadmin/services/notificacion_service.dart';
import 'package:dashboardadmin/ui/buttons/custom_outlined_button.dart';
import 'package:dashboardadmin/ui/inputs/custom_inputs.dart';
import 'package:dashboardadmin/ui/labels/custom_labels.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConexionModal extends StatefulWidget {
  final UsuarioT? usuario;

  const ConexionModal({Key? key, this.usuario}) : super(key: key);

  @override
  _ConexionModalState createState() => _ConexionModalState();
}

class _ConexionModalState extends State<ConexionModal> {
  String nombre = '';

  String? id;

  @override
  void initState() {
    super.initState();

    id = widget.usuario?.id;
    nombre = widget.usuario?.nombre ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final usuarioProvider =
        Provider.of<UsuariosSistemaProvider>(context, listen: false);

    return Container(
      padding: EdgeInsets.symmetric(
          vertical: 20, horizontal: 30), // Ajuste el padding
      height: 350, // Ajuste la altura
      width: 500,
      decoration: buildBoxDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.usuario?.nombre ?? 'Nueva usuario',
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
          TextFormField(
            initialValue: widget.usuario?.nombre ?? '',
            onChanged: (value) => nombre = value,
            decoration: CustomInputs.loginInputDecoration(
              hint: 'Nombre de la usuario',
              label: 'nombre',
              icon: Icons.new_releases_outlined,
            ).copyWith(
              fillColor: Colors.white24, // Añadido color de fondo
              filled: true, // Añadido background al input
              hintStyle:
                  TextStyle(color: Colors.white60), // Ajuste del color del hint
              labelStyle: TextStyle(
                  color: Colors.white70), // Ajuste del color del label
            ),
            style: TextStyle(color: Colors.white),
          ),
          CustomOutlinedButton(
            onPressed: () async {
              try {
                if (id == null) {
                  // Crear
                  // await UsuarioProfesorProvider.postSeccion(nombre);
                  // NotificationsService.showSnackbar('$nombre creado!');
                } else {
                  print('nombre: $nombre');
                  // Actualizar
                  await usuarioProvider.actualizarUsuario(id!, nombre);
                  NotificationsService.showSnackbar('$nombre Actualizado!');
                }

                Navigator.of(context).pop();
              } catch (e) {
                Navigator.of(context).pop();
                NotificationsService.showSnackbarError(e.toString());
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
