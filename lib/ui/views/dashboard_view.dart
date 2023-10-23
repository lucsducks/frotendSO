import 'package:dashboardadmin/providers/auth_provider.dart';
import 'package:dashboardadmin/providers/sshconexion_provider.dart';
import 'package:dashboardadmin/ui/buttons/custom_icon_button.dart';
import 'package:dashboardadmin/ui/cards/host_card.dart';
import 'package:dashboardadmin/ui/cards/white_card.dart';
import 'package:dashboardadmin/ui/labels/custom_labels.dart';
import 'package:dashboardadmin/ui/modals/conexiones_modal.dart';
import 'package:dashboardadmin/ui/shared/widgets/colores_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardView extends StatefulWidget {
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
    final user = Provider.of<AuthProvider>(context).user!;
    final conexiones = Provider.of<sshConexionProvider>(context).conexiones;
    print(conexiones);
    return Container(
      child: ListView(
        physics: ClampingScrollPhysics(),
        children: [
          Text('Dashboard View', style: CustomLabels.h1),
          SizedBox(height: 10),
          WhiteCard(
              title: user.nombre,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomIconButton(
                      onPressed: () {
                        showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (_) => ConexionModal(conexion: null));
                      },
                      text: 'Nuevo Host',
                      icon: Icons.add),
                  SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    children: conexiones
                        .map((e) => HostCard(
                              logoPath: 'ubuntu.png',
                              direccionIp: e.direccionip,
                              nombre: e.nombre,
                              password: e.password,
                              usuariohost: e.usuario,
                              idHost: e.id,
                              estado: e.estado,
                              owner: e.owner,
                              v: e.v,
                              fechaCreacion: e.fechaCreacion,
                            ))
                        .toList(),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
