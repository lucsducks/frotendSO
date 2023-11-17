import 'dart:convert';

import 'package:iziFile/models/usuario.dart';

class UsuarioResponse {
  UsuarioResponse({
    required this.total,
    required this.usuarios,
  });

  int total;
  List<UsuarioT> usuarios;

  factory UsuarioResponse.fromJson(String str) =>
      UsuarioResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UsuarioResponse.fromMap(Map<String, dynamic> json) => UsuarioResponse(
        total: json["total"],
        usuarios: List<UsuarioT>.from(
            json["usuarios"].map((x) => UsuarioT.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "total": total,
        "usuarios": List<dynamic>.from(usuarios.map((x) => x.toMap())),
      };
}
