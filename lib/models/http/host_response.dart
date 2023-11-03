import 'dart:convert';

class HostResponse {
  int total;
  List<Conexiones> conexiones;

  HostResponse({
    required this.total,
    required this.conexiones,
  });

  factory HostResponse.fromJson(String str) =>
      HostResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory HostResponse.fromMap(Map<String, dynamic> json) => HostResponse(
        total: json["total"],
        conexiones: List<Conexiones>.from(
            json["conexiones"].map((x) => Conexiones.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "total": total,
        "conexioness": List<dynamic>.from(conexiones.map((x) => x.toMap())),
      };
}

class Conexiones {
  bool estado;
  String id;
  String nombre;
  String owner;
  String usuario;
  String direccionip;
  String password;
  int v;
  String fechaCreacion;

  Conexiones({
    required this.estado,
    required this.id,
    required this.nombre,
    required this.owner,
    required this.usuario,
    required this.direccionip,
    required this.password,
    required this.v,
    required this.fechaCreacion,
  });
  Conexiones.initial()
      : estado = false, // false ya que suponemos que no está conectado
        id = '0', // Un valor predeterminado que indica que no hay un ID válido
        nombre = 'Sin nombre',
        owner = 'Sin propietario',
        usuario = 'Sin usuario',
        direccionip = '0.0.0.0',
        password = '',
        v = 0, // Versión del documento inicial
        fechaCreacion = DateTime.now().toIso8601String();
  factory Conexiones.fromJson(String str) =>
      Conexiones.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Conexiones.fromMap(Map<String, dynamic> json) => Conexiones(
        estado: json["estado"] ?? true,
        id: json["_id"] ?? "",
        nombre: json["nombre"] ?? "",
        owner: json["owner"] ?? "",
        usuario: json["usuario"] ?? "",
        direccionip: json["direccionip"] ?? "",
        password: json["password"] ?? "",
        v: json["__v"] ?? 0,
        fechaCreacion: json["fechaCreacion"] ?? "",
      );

  Map<String, dynamic> toMap() => {
        "estado": estado,
        "_id": id,
        "nombre": nombre,
        "owner": owner,
        "usuario": usuario,
        "direccionip": direccionip,
        "password": password,
        "__v": v,
        "fechaCreacion": fechaCreacion,
      };
}
