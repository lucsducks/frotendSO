import 'package:iziFile/providers/auth_provider.dart';
import 'package:iziFile/providers/sshconexion_provider.dart';
import 'package:iziFile/providers/terminal_provider.dart';
import 'package:iziFile/services/navigation_service.dart';
import 'package:iziFile/ui/buttons/custom_icon_button.dart';
import 'package:iziFile/ui/cards/host_card.dart';
import 'package:iziFile/ui/cards/white_card.dart';
import 'package:iziFile/ui/labels/custom_labels.dart';
import 'package:iziFile/ui/modals/conexiones_modal.dart';
import 'package:iziFile/ui/views/sftp_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VisorHostView extends StatefulWidget {
  @override
  State<VisorHostView> createState() => _VisorHostViewState();
}

class _VisorHostViewState extends State<VisorHostView> {
  bool mostrarSftp = false;
  String? hostIdSeleccionado;
  String? ownerIdSeleccionado;
  String? password;
  String? direccionip;
  String? usuario;
  int? port;

  Map<String, TerminalProvider> terminalProviders = {};
  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    Provider.of<sshConexionProvider>(context, listen: false)
        .getconexionesHost(user!.id);
  }

  void _mostrarDetallesSftp(
      String hostId,
      String ownerId,
      TerminalProvider terminalProvider,
      String password,
      String direccionip,
      String usuario,
      int port) {
    setState(() {
      mostrarSftp = true;
      hostIdSeleccionado = hostId;
      ownerIdSeleccionado = ownerId;
      terminalProviders = terminalProviders;
      this.password = password;
      this.direccionip = direccionip;
      this.usuario = usuario;
      this.port = port;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user!;
    final conexiones = Provider.of<sshConexionProvider>(context).conexiones;
    final conexionesUsuario =
        Provider.of<sshConexionProvider>(context).conexionActivaUsuario;
    if (mostrarSftp &&
        hostIdSeleccionado != null &&
        ownerIdSeleccionado != null) {
      // Si se seleccionó un host, muestra la vista SFTP
      return SftpView(
        onBackToList: () {
          setState(() {
            mostrarSftp = false;
          });
        },
        hostid: hostIdSeleccionado!,
        ownerid: ownerIdSeleccionado!,
        password: password!,
        direccionip: direccionip!,
        usuario: usuario!,
        port: port!,
      );
    } else {
      return ListView(
        children: conexiones
            .map((e) => HostCard(
                  direccionIp: e.direccionip,
                  nombre: e.nombre,
                  port: e.port,
                  img: e.img,
                  password: e.password,
                  usuariohost: e.usuario,
                  idHost: e.id,
                  estado: e.estado,
                  owner: e.owner,
                  v: e.v,
                  fechaCreacion: e.fechaCreacion,
                  onTap: () {
                    Provider.of<sshConexionProvider>(context, listen: false)
                        .newConexion(e.id);
                    Provider.of<sshConexionProvider>(context, listen: false)
                        .getTerminalProviderForHostId(e.id);
                    terminalProviders =
                        Provider.of<sshConexionProvider>(context, listen: false)
                            .terminalProviders;
                    TerminalProvider terminalProvider =
                        terminalProviders[e.id]!;
                    _mostrarDetallesSftp(e.id, e.owner, terminalProvider,
                        e.password, e.direccionip, e.usuario, e.port);
                  },
                ))
            .toList(),
      );
    }
  }
}
