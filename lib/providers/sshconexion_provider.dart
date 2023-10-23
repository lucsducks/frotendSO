import 'package:dashboardadmin/api/restApi.dart';
import 'package:dashboardadmin/models/http/host_response.dart';
import 'package:dashboardadmin/models/http/usuario_response.dart';
import 'package:dashboardadmin/services/notificacion_service.dart';
import 'package:flutter/material.dart';

class sshConexionProvider extends ChangeNotifier {
  List<Conexiones> conexiones = [];

  getconexionesHost(String owner) async {
    final resp = await restApi.httpGet("/host/listar/$owner");
    final hostResponse = HostResponse.fromMap(resp);
    conexiones = hostResponse.conexiones;
    notifyListeners();
  }

  Future postConexion(String nombre, String usuario, String owner,
      String direccionip, String password) async {
    final data = {
      'nombre': nombre,
      'usuario': usuario,
      'owner': owner,
      'direccionip': direccionip,
      'password': password
    };

    try {
      final json = await restApi.post('/host', data);
      final nuevoHost = Conexiones.fromMap(json);
      getconexionesHost(owner);
      // usuarios.add(nuevoUsuario);
      notifyListeners();
    } catch (e) {
      NotificationsService.showSnackbarError(e.toString());
      throw e;
    }
  }

  Future actualizarConexion(String nombre, String usuario, String id,
      String direccionip, String password, String owner) async {
    final data = {
      'nombre': nombre,
      'usuario': usuario,
      'direccionip': direccionip,
      'password': password
    };
    print(data);
    try {
      await restApi.put('/host/$id', data);

      getconexionesHost(owner);
      notifyListeners();
    } catch (e) {
      NotificationsService.showSnackbarError(e.toString());
      throw e;
    }
  }

  Future eliminarHost(String id, String owner) async {
    try {
      await restApi.delete('/host/$id');
      getconexionesHost(owner);
      notifyListeners();
    } catch (e) {
      NotificationsService.showSnackbarError(e.toString());
      throw e;
    }
  }
}
