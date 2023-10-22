import 'dart:convert';

class UsuarioT {
  UsuarioT({
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

  factory UsuarioT.fromJson(String str) => UsuarioT.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UsuarioT.fromMap(Map<String, dynamic> json) => UsuarioT(
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
  @override
  String toString() {
    return 'UsuarioT(rol: $rol, estado: $estado, id: $id, nombre: $nombre, correo: $correo,fechaCreacion: $fechaCreacion, v: $v)';
  }
}
