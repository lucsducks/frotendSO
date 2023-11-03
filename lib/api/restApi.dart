import 'package:dashboardadmin/services/localStorage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class restApi {
  static Dio _dio = Dio();
  static void configureDio() {
    // Base del url
    _dio.options.baseUrl = 'http://161.132.55.27:3000/api';;

    // Configurar Headers
    _dio.options.headers = {
      'x-token': LocalStorage.prefs.getString('token') ?? ''
    };
  }

  static Future httpGet(String path) async {
    try {
      final resp = await _dio.get(path);

      return resp.data;
    } catch (e) {
      print(e);
      throw ('Error en el GET');
    }
  }

  static Future post(String path, Map<String, dynamic> data) async {
    final formData = FormData.fromMap(data);

    try {
      final resp = await _dio.post(path, data: formData);
      debugPrint("respuesta$resp");
      return resp.data;
    } catch (e) {
      print(e);
      if (e is DioException && e.response != null) {
        // Capturamos el mensaje específico del error
        String errorMsg = e.response!.data['msg'] ?? 'Error desconocido';
        throw errorMsg;
      } else {
        throw ('Error en el POST');
      }
    }
  }

  static Future put(String path, Map<String, dynamic> data) async {
    final formData = FormData.fromMap(data);

    try {
      final resp = await _dio.put(path, data: formData);
      debugPrint("respuesta PUT: $resp");
      return resp.data;
    } catch (e) {
      print(e);
      if (e is DioException && e.response != null) {
        // Capturamos el mensaje específico del error
        String errorMsg = e.response!.data['msg'] ?? 'Error desconocido';
        throw errorMsg;
      } else {
        throw ('Error en el PUT');
      }
    }
  }

  static Future delete(String path) async {
    try {
      final resp = await _dio.delete(path);
      debugPrint("respuesta DELETE: $resp");
      return resp.data;
    } catch (e) {
      print(e);
      if (e is DioException && e.response != null) {
        // Capturamos el mensaje específico del error
        String errorMsg = e.response!.data['msg'] ?? 'Error desconocido';
        throw errorMsg;
      } else {
        throw ('Error en el DELETE');
      }
    }
  }

  static Future<Map<String, dynamic>> googleLogin(String idToken) async {
    final data = {'id_token': idToken};
    debugPrint("data$data");
    try {
      final resp = await _dio.post('/auth/google', data: data);
      debugPrint("respuesta$resp");

      return resp.data;
    } catch (e) {
      debugPrint(("error$e"));
      throw e;
    }
  }
}
