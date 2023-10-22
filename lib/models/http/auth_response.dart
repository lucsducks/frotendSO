// To parse this JSON data, do
//
//     final authResponse = authResponseFromMap(jsonString);
import 'dart:convert';

class AuthResponse {
  AuthResponse({
    required this.usuario,
    required this.token,
  });

  Usuario usuario;
  String token;

  factory AuthResponse.fromJson(String str) =>
      AuthResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AuthResponse.fromMap(Map<String, dynamic> json) => AuthResponse(
        usuario: Usuario.fromMap(json["usuario"]),
        token: json["token"],
      );

  Map<String, dynamic> toMap() => {
        "usuario": usuario.toMap(),
        "token": token,
      };
}

class Usuario {
  Usuario({
    required this.rol,
    required this.estado,
    required this.id,
    required this.nombre,
    required this.correo,
    required this.fechaCreacion,
    required this.v,
  });

  String rol;
  bool estado;
  String id;
  String nombre;
  String correo;
  DateTime fechaCreacion;
  int v;

  factory Usuario.fromJson(String str) => Usuario.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Usuario.fromMap(Map<String, dynamic> json) => Usuario(
        rol: json["rol"] ?? "",
        estado: json["estado"] ?? true,
        id: json["_id"] ?? "",
        nombre: json["nombre"] ?? "",
        correo: json["correo"] ?? "",
        fechaCreacion: DateTime.parse(json["fechaCreacion"]) ?? DateTime.now(),
        v: json["__v"] ?? 0,
      );

  Map<String, dynamic> toMap() => {
        "rol": rol,
        "estado": estado,
        "_id": id,
        "nombre": nombre,
        "correo": correo,
        "fechaCreacion": fechaCreacion.toIso8601String(),
        "__v": v,
      };
}
