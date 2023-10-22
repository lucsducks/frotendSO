import 'package:dashboardadmin/api/restApi.dart';
import 'package:dashboardadmin/models/http/usuario_response.dart';
import 'package:dashboardadmin/models/usuario.dart';
import 'package:dashboardadmin/services/notificacion_service.dart';
import 'package:flutter/material.dart';

class UsuariosSistemaProvider extends ChangeNotifier {
  List<UsuarioT> usuarios = [];
  List<UsuarioT> usuariosEstudiantes = [];

  getSinRoles() async {
    final resp = await restApi.httpGet("/usuarios/user");
    final usuarioResponde = UsuarioResponse.fromMap(resp);
    usuarios = usuarioResponde.usuarios;
    notifyListeners();
  }

  // Future postUsuario(String name) async {
  //   final data = {'nombre': name};

  //   try {
  //     final json = await restApi.post('/usuarios', data);
  //     final nuevoUsuario = Usuario.fromMap(json);
  //     usuarios.add(nuevoUsuario);

  //     // usuarios.add(nuevoUsuario);
  //     notifyListeners();
  //   } catch (e) {
  //     NotificationsService.showSnackbarError(e.toString());
  //     throw e;
  //   }
  // }

  Future actualizarUsuario(String id, String name) async {
    final data = {'nombre': name};

    try {
      await restApi.put('/usuarios/$id', data);
      usuarios = usuarios.map((usuario) {
        if (usuario.id != id) return usuario;
        usuario.nombre = name;
        return usuario;
      }).toList();

      // usuarios.add(nuevoUsuario);
      notifyListeners();
    } catch (e) {
      NotificationsService.showSnackbarError(e.toString());
      throw e;
    }
  }

  Future privilegiarUsuario(String id, String rol) async {
    final data = {'rol': rol};

    try {
      await restApi.put('/usuarios/pri/$id', data);
      usuarios.removeWhere((usuario) => usuario.id == id);
      notifyListeners();
    } catch (e) {
      NotificationsService.showSnackbarError(e.toString());
      throw e;
    }
  }

//TODO falta
  Future desactivarUsuario(String id) async {
    try {
      await restApi.delete('/usuarios/$id');
      final usuarioToUpdate =
          usuarios.firstWhere((usuario) => usuario.id == id);
      usuarioToUpdate.estado = !usuarioToUpdate.estado;
      notifyListeners();
    } catch (e) {
      print(e);
      print('Error al crear categoria');
    }
  }
}
