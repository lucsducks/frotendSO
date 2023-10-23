import 'package:dashboardadmin/models/http/host_response.dart';
import 'package:dashboardadmin/providers/sshconexion_provider.dart';
import 'package:dashboardadmin/services/notificacion_service.dart';
import 'package:dashboardadmin/ui/modals/conexiones_modal.dart';
import 'package:dashboardadmin/ui/shared/widgets/colores_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HostCard extends StatefulWidget {
  final String? logoPath;
  final String? nombre;
  final String? usuariohost;
  final String? password;
  final String? idHost;
  final String? direccionIp;
  final Color? cardColor;
  final Color? textColor;
  final VoidCallback? onTap;
  final int v;
  final String fechaCreacion;
  final bool estado;
  final String owner;
  const HostCard({
    Key? key,
    required this.logoPath,
    required this.nombre,
    required this.idHost,
    required this.usuariohost,
    required this.password,
    required this.direccionIp,
    required this.estado,
    required this.owner,
    required this.v,
    required this.fechaCreacion,
    this.cardColor = Colors.blueGrey,
    this.textColor = Colors.white,
    this.onTap,
  }) : super(key: key);

  @override
  _HostCardState createState() => _HostCardState();
}

class _HostCardState extends State<HostCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    Conexiones conexion = Conexiones(
        id: widget.idHost!,
        nombre: widget.nombre!,
        usuario: widget.usuariohost!,
        direccionip: widget.direccionIp!,
        password: widget.password!,
        estado: widget.estado,
        owner: widget.owner,
        v: widget.v,
        fechaCreacion: widget.fechaCreacion);
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          child: Card(
            color: _isHovering ? Colors.grey[300] : null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Container(
              height: 70, // Altura especificada
              width: 350, // Ancho especificado
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Imagen
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.asset(
                            ImgSample.get(widget.logoPath!),
                            height:
                                60, // Ajusta para que sea proporcional al height de la tarjeta
                            width: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(width: 10), // Espacio entre imagen y texto
                        // Textos
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment:
                              MainAxisAlignment.center, // Centrar verticalmente
                          children: <Widget>[
                            Text(
                              widget.nombre!,
                              style: MyTextSample.title(context)!.copyWith(
                                color: MyColorsSample.grey_80,
                              ),
                            ),
                            Container(height: 5),
                            Text(
                              widget.direccionIp!,
                              style: MyTextSample.body1(context)!.copyWith(
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (_) =>
                                    ConexionModal(conexion: conexion));
                          },
                          icon: Icon(Icons.edit_outlined),
                        ),
                        IconButton(
                          onPressed: () {
                            final dialog = AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    10.0), // Personaliza los bordes
                              ),
                              title: Text(
                                '¿Está seguro de eliminar el host?',
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
                                      foregroundColor: Colors
                                          .red, // Cambia el color del botón Borrar
                                    ),
                                    child: Text(
                                      'Si',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    onPressed: () async {
                                      await Provider.of<sshConexionProvider>(
                                              context,
                                              listen: false)
                                          .eliminarHost(
                                              widget.idHost!, widget.owner);
                                      Navigator.of(context).pop();
                                      NotificationsService.showSnackbar(
                                          'Eliminado correctamente');
                                    }),
                              ],
                            );

                            showDialog(
                                context: context, builder: (_) => dialog);
                          },
                          icon: Icon(
                            Icons.cancel_rounded,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
