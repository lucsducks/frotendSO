import 'package:iziFile/models/http/host_response.dart';
import 'package:iziFile/providers/sshconexion_provider.dart';
import 'package:iziFile/services/notificacion_service.dart';
import 'package:iziFile/ui/modals/conexiones_modal.dart';
import 'package:iziFile/ui/shared/widgets/colores_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HostCard extends StatefulWidget {
  final String? logoPath;
  final String? nombre;
  final String? usuariohost;
  final String? password;
  final String? img;
  final String? idHost;
  final String? direccionIp;
  final int? port;
  final Color? cardColor;
  final Color? textColor;
  final VoidCallback? onTap;
  final int v;
  final String fechaCreacion;
  final bool estado;
  final String owner;
  final IconData? iconData;

  const HostCard({
    Key? key,
    this.logoPath = 'server.png',
    this.iconData = Icons.window,
    required this.nombre,
    required this.idHost,
    required this.usuariohost,
    required this.password,
    required this.img,
    required this.direccionIp,
    required this.port,
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
        port: widget.port!,
        img: widget.img!,
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
        onDoubleTap: widget.onTap,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Container(
            width: 350,
            color: _isHovering
                ? const Color.fromARGB(255, 230, 242, 255)
                : const Color.fromARGB(255, 241, 247, 255),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      // Imagen
                      ClipRRect(
                        child: SvgPicture.asset(
                          widget.img!,
                          height: 60,
                          width: 60,
                          color: const Color.fromARGB(255, 10, 125, 243),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment:
                            MainAxisAlignment.center, // Centrar verticalmente
                        children: <Widget>[
                          Text(
                            widget.nombre!,
                            style: MyTextSample.title(context)!.copyWith(
                              color: const Color.fromARGB(255, 7, 31, 78),
                            ),
                          ),
                          Container(height: 5),
                          Text(
                            widget.direccionIp!,
                            style: MyTextSample.body1(context)!.copyWith(
                              color: const Color.fromARGB(255, 133, 133, 133),
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
                          showCupertinoModalPopup(
                              context: context,
                              builder: (_) =>
                                  ConexionModal(conexion: conexion));
                        },
                        icon: const Icon(
                          Icons.edit_outlined,
                          color: Color.fromARGB(255, 7, 31, 78),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          final dialog = AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            title: Text(
                              'Eliminar Host',
                              style: GoogleFonts.poppins(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromARGB(255, 7, 31, 78),
                              ),
                            ),
                            content: Text(
                              '¿Está seguro de eliminar el host?',
                              style: GoogleFonts.poppins(
                                fontSize: 16.0,
                                fontWeight: FontWeight.normal,
                                color: const Color.fromARGB(255, 133, 133, 133),
                              ),
                            ),
                            actions: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.red,
                                ),
                                child: Text(
                                  'Cancelar',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.red,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor:
                                        const Color.fromARGB(255, 10, 125, 243),
                                  ),
                                  child: Text(
                                    'Aceptar',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.normal,
                                      color: const Color.fromARGB(
                                          255, 10, 125, 243),
                                    ),
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

                          showDialog(context: context, builder: (_) => dialog);
                        },
                        icon: const Icon(
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
    );
  }
}
