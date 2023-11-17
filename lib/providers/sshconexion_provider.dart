import 'package:iziFile/api/restApi.dart';
import 'package:iziFile/models/http/host_response.dart';
import 'package:iziFile/providers/terminal_provider.dart';
import 'package:iziFile/services/notificacion_service.dart';
import 'package:flutter/material.dart';

class sshConexionProvider extends ChangeNotifier {
  List<Conexiones> conexiones = [];
  List<Conexiones> conexionUsuario = [];
  List<String> conexionActivaUsuario = [];
  final Map<String, TerminalProvider> terminalProviders = {};

  late Conexiones conexion = Conexiones.initial();
  void newConexion(String id) {
    // Verifica si el arreglo ya contiene el id
    if (!conexionActivaUsuario.contains(id)) {
      conexionActivaUsuario.add(id);
      notifyListeners();
    }
  }

  void removeConexion(String id) {
    // Remueve el id del arreglo si este existe.
    if (conexionActivaUsuario.contains(id)) {
      conexionActivaUsuario.remove(id);
      notifyListeners();
    }
  }

  TerminalProvider getTerminalProviderForHostId(String hostId) {
    if (!terminalProviders.containsKey(hostId)) {
      terminalProviders[hostId] =
          TerminalProvider(); // Crear una nueva instancia si no existe
      // Aquí deberías inicializar tu terminal con los detalles de conexión
    }
    return terminalProviders[hostId]!;
  }

  void removeTerminalProviderById(String id) {
    terminalProviders.remove(id);
    notifyListeners();
  }

  // Método para limpiar el proveedor del terminal, si es necesario.
  void disposeTerminalProviderForHostId(String hostId) {
    terminalProviders[hostId]?.closeConnection();
    terminalProviders.remove(hostId);
  }

  getconexionesHost(String owner) async {
    final resp = await restApi.httpGet("/host/listar/$owner");
    final hostResponse = HostResponse.fromMap(resp);
    conexiones = hostResponse.conexiones;
    notifyListeners();
  }

  Future<Conexiones> getinformacionHost(String id) async {
    final resp = await restApi.httpGet("/host/hostpersonal/$id");
    final hostResponse = Conexiones.fromMap(resp);
    conexion = hostResponse;
    notifyListeners();
    return hostResponse; // Devuelve el objeto Conexiones
  }

  Future postConexion(String nombre, String usuario, String owner,
      String direccionip, int port, String password, String img) async {
    final data = {
      'nombre': nombre,
      'usuario': usuario,
      'owner': owner,
      'direccionip': direccionip,
      'port': port,
      'password': password,
      'img': img
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

  Future actualizarConexion(
      String nombre,
      String usuario,
      String id,
      String direccionip,
      String password,
      int port,
      String owner,
      String img) async {
    final data = {
      'nombre': nombre,
      'usuario': usuario,
      'direccionip': direccionip,
      'password': password,
      'port': port,
      'img': img,
    };
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
