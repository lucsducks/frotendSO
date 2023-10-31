import 'package:dashboardadmin/providers/sshconexion_provider.dart';
import 'package:dashboardadmin/services/navigation_service.dart';
import 'package:dashboardadmin/ui/cards/white_card.dart';
import 'package:dashboardadmin/ui/labels/custom_labels.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HostPersonalView extends StatefulWidget {
  final String hostid;
  final String ownerid;

  const HostPersonalView(
      {super.key, required this.hostid, required this.ownerid});

  @override
  State<HostPersonalView> createState() => _HostPersonalViewState();
}

class _HostPersonalViewState extends State<HostPersonalView> {
  final focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    Provider.of<sshConexionProvider>(context, listen: false)
        .getinformacionHost(widget.hostid);
  }

  @override
  Widget build(BuildContext context) {
    final conexionHost = Provider.of<sshConexionProvider>(context).conexion;
    return Container(
      child: ListView(
        physics: ClampingScrollPhysics(),
        children: [
          Text('Terminal View', style: CustomLabels.h1),
          SizedBox(height: 10),
          WhiteCard(
            title: 'Flutter Terminal',
            child: Column(
              children: [
                Container(
                  child: Text("data"),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
