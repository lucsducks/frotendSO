import 'package:dashboardadmin/providers/auth_provider.dart';
import 'package:dashboardadmin/providers/sshconexion_provider.dart';
import 'package:dashboardadmin/services/navigation_service.dart';
import 'package:dashboardadmin/ui/buttons/custom_icon_button.dart';
import 'package:dashboardadmin/ui/cards/host_card.dart';
import 'package:dashboardadmin/ui/cards/white_card.dart';
import 'package:dashboardadmin/ui/labels/custom_labels.dart';
import 'package:dashboardadmin/ui/modals/conexiones_modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    Provider.of<sshConexionProvider>(context, listen: false)
        .getconexionesHost(user!.id);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double paddHost = size.width > 1300 ? 50 : 0;
    double paddText = size.width > 1300 ? 0 : 20;
    double sizedHeight = size.width > 1300 ? 20 : 0;

    final user = Provider.of<AuthProvider>(context).user!;
    final conexiones = Provider.of<sshConexionProvider>(context).conexiones;
    final conexionesUsuario =
        Provider.of<sshConexionProvider>(context).conexionActivaUsuario;
    print(conexiones);
    return Padding(
      padding: EdgeInsets.all(paddHost),
      child: ListView(
        physics: ClampingScrollPhysics(),
        children: [
          Padding(
            padding: EdgeInsets.all(paddText),
            child: Text('Host View', style: CustomLabels.h1),
          ),
          SizedBox(height: sizedHeight),
          WhiteCard(
              margin: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomIconButton(
                      onPressed: () {
                        showCupertinoModalPopup(
                            context: context,
                            builder: (_) => ConexionModal(conexion: null));
                      },
                      text: 'Nuevo Host',
                      icon: Icons.add),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10,
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
                                  Provider.of<sshConexionProvider>(context,
                                          listen: false)
                                      .newConexion(e.id);
                                  Provider.of<sshConexionProvider>(context,
                                          listen: false)
                                      .getTerminalProviderForHostId(e.id);
                                  NavigationService.replaceTo(
                                      '/dashboard/host/${e.id}/owner/${e.owner}');
                                },
                              ))
                          .toList(),
                    ),
                  )
                ],
              ))
        ],
      ),
    );
  }
}
