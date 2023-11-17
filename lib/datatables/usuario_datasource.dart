import 'package:iziFile/models/usuario.dart';
import 'package:iziFile/providers/auth_provider.dart';
import 'package:iziFile/providers/usuario_provider.dart';
import 'package:iziFile/ui/modals/usuario_modal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class usuarioDTS extends DataTableSource {
  final BuildContext context;
  final List<UsuarioT> usuariosOriginal;
  List<UsuarioT> usuarios;
  usuarioDTS(this.context, this.usuarios)
      : usuariosOriginal = List.from(usuarios);
  void setFiltro(String? estado) {
    if (estado == "Activo") {
      usuarios =
          usuariosOriginal.where((usuario) => usuario.estado == true).toList();
    } else if (estado == "Desactivado") {
      usuarios =
          usuariosOriginal.where((usuario) => usuario.estado == false).toList();
    } else {
      usuarios = List.from(usuariosOriginal);
    }
    notifyListeners();
  }

  void filterByDate(DateTimeRange? dateRange) {
    if (dateRange == null) {
      usuarios = List.from(usuariosOriginal);
    } else {
      usuarios = usuariosOriginal.where((usuario) {
        final fechaCreacion = usuario.fechaCreacion;
        return fechaCreacion.isAfter(dateRange.start) &&
            fechaCreacion.isBefore(dateRange.end);
      }).toList();
    }

    notifyListeners();
  }

  void setFiltroPorNombre(String? nombre) {
    if (nombre == null || nombre.isEmpty) {
      usuarios = List.from(usuariosOriginal);
    } else {
      usuarios = usuariosOriginal
          .where((usuario) =>
              usuario.nombre.toLowerCase().contains(nombre.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  @override
  DataRow getRow(int index) {
    final usuario = this.usuarios[index];
    final user = Provider.of<AuthProvider>(context).user!;

    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(usuario.id)),
        DataCell(Text(usuario.nombre.toUpperCase())),
        DataCell(Text(usuario.correo.toLowerCase())),
        DataCell(Text(
            "${usuario.fechaCreacion.day.toString().padLeft(2, '0')}/${usuario.fechaCreacion.month.toString().padLeft(2, '0')}/${usuario.fechaCreacion.year.toString()}")),
        DataCell(
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              usuario.estado ? 'Activo' : 'Desactivado',
              style: TextStyle(
                color: usuario.estado ? Colors.green : Colors.red,
              ),
            ),
          ),
        ),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.edit_outlined),
                onPressed: () {
                  showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (_) => UsuarioModal(usuario: usuario));
                },
                tooltip: 'Editar',
              ),
              (user.rol == "DEV_ROLE")
                  ? IconButton(
                      icon: Icon(
                        Icons.privacy_tip_outlined,
                        color:
                            Color.fromARGB(255, 16, 201, 16).withOpacity(0.8),
                      ),
                      onPressed: () {
                        String? selectedRole = usuario.rol;
                        final Map<String, String> roles = {
                          'USER_ROLE': 'Usuario',
                          'DEV_ROLE': 'Desarrollador',
                        };

                        final dialog = AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          title: Text(
                            'Asignar Rol',
                            style: TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey,
                            ),
                          ),
                          content: StatefulBuilder(
                            builder:
                                (BuildContext context, StateSetter setState) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Elije el rol para el usuario:',
                                      style: TextStyle(fontSize: 16.0)),
                                  SizedBox(height: 10.0),
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.blueGrey, width: 1.0),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Container(
                                      width: double.infinity,
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: selectedRole,
                                          style: TextStyle(
                                              color: Colors.blueGrey,
                                              fontSize: 16.0),
                                          items: roles.entries.map((e) {
                                            return DropdownMenuItem<String>(
                                              value: e.key,
                                              child: Text(e.value),
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              selectedRole = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          actions: [
                            TextButton(
                              child: Text('Cancelar'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                primary:
                                    usuario.estado ? Colors.red : Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                backgroundColor: usuario.estado
                                    ? Colors.red.withOpacity(0.2)
                                    : Colors.green.withOpacity(0.2),
                              ),
                              child: Text(
                                'Okay',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () async {
                                if (selectedRole != null) {
                                  // Aquí puedes procesar el rol seleccionado (selectedRole) si es necesario
                                  await Provider.of<UsuariosSistemaProvider>(
                                          context,
                                          listen: false)
                                      .privilegiarUsuario(
                                          usuario.id, selectedRole!);
                                  Navigator.of(context).pop();
                                } else {
                                  // Posiblemente mostrar un mensaje de que el rol no ha sido seleccionado
                                }
                              },
                            ),
                          ],
                        );

                        showDialog(context: context, builder: (_) => dialog);
                      },
                      tooltip: 'Privilegiar',
                    )
                  : Container(),
              IconButton(
                icon: Icon(Icons.delete_outline,
                    color: Colors.red.withOpacity(0.8)),
                onPressed: () {
                  final dialog = AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Personaliza los bordes
                    ),
                    title: Text(
                      '¿Está seguro de ${usuario.estado ? 'Desactivarlo' : 'Activarlo'}?',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    actions: [
                      TextButton(
                        child: Text('No'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor:
                                Colors.red, // Cambia el color del botón Borrar
                          ),
                          child: Text(
                            usuario.estado ? 'Desactivar' : 'Activar',
                            style: TextStyle(
                              color: usuario.estado ? Colors.red : Colors.green,
                            ),
                          ),
                          onPressed: () async {
                            await Provider.of<UsuariosSistemaProvider>(context,
                                    listen: false)
                                .desactivarUsuario(usuario
                                    .id); // Suponiendo que tienes un método para borrar secciones en tu provider.
                            Navigator.of(context).pop();
                          }),
                    ],
                  );

                  showDialog(context: context, builder: (_) => dialog);
                },
                tooltip: 'Eliminar',
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => usuarios.length;

  @override
  int get selectedRowCount => 0;
}
