import 'dart:math';

import 'package:dashboardadmin/ui/labels/custom_labels.dart';
import 'package:dashboardadmin/providers/sshconexion_provider.dart';
import 'package:dashboardadmin/providers/terminal_provider.dart';
import 'package:dashboardadmin/services/navigation_service.dart';
import 'package:dashboardadmin/ui/views/terminal_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HostPersonalView extends StatefulWidget {
  final String hostid;
  final String ownerid;

  const HostPersonalView(
      {Key? key, required this.hostid, required this.ownerid})
      : super(key: key);

  @override
  _HostPersonalViewState createState() => _HostPersonalViewState();
}

class _HostPersonalViewState extends State<HostPersonalView>
    with TickerProviderStateMixin {
  TabController? _tabController;
  List<String> _hostIds = [];
  Map<String, Widget> _hostViews = {};
  Map<String, TerminalProvider> terminalProviders = {};

  @override
  void initState() {
    super.initState();
    _hostIds = Provider.of<sshConexionProvider>(context, listen: false)
        .conexionActivaUsuario;
    _tabController = TabController(vsync: this, length: _hostIds.length)
      ..addListener(_handleTabSelection);
    _hostViews[widget.hostid] = createHostView(widget.hostid);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Podrías usar Provider aquí para buscar datos actualizados si es necesario.

    // Luego actualiza la vista de la pestaña actual.
    if (_tabController != null && _hostIds.isNotEmpty) {
      setState(() {
        _hostViews[_hostIds[_tabController!.index]] =
            createHostView(_hostIds[_tabController!.index]);
      });
    }
  }

  void _handleTabSelection() {
    if (_tabController!.indexIsChanging) {
      setState(() {
        // Aquí reconstruyes la vista para la pestaña seleccionada
        _hostViews[_hostIds[_tabController!.index]] =
            createHostView(_hostIds[_tabController!.index]);
      });
    }
  }

  @override
  void dispose() {
    _tabController?.removeListener(_handleTabSelection);
    _tabController?.dispose();
    super.dispose();
  }

  void checkAndAddHostId(String newHostId) {
    setState(() {
      if (!_hostIds.contains(newHostId)) {
        _hostIds.add(newHostId);
        _hostViews[newHostId] = createHostView(newHostId);
        // Asegúrate de actualizar el controlador con el nuevo número de tabs
        _tabController?.dispose();
        _tabController = TabController(
            vsync: this,
            length: _hostIds.length,
            initialIndex: _hostIds.length - 1);
      } else {
        // Si el host ID ya existe, solo navega a la pestaña correspondiente
        int index = _hostIds.indexOf(newHostId);
        _tabController?.animateTo(index);
      }
    });
    // Asegúrate de seleccionar el nuevo Tab inmediatamente después de añadirlo
    _tabController?.animateTo(_hostIds.indexOf(newHostId));
  }

  Widget createHostView(String hostId) {
    terminalProviders = Provider.of<sshConexionProvider>(context, listen: false)
        .terminalProviders;
    TerminalProvider terminalProvider = terminalProviders[hostId]!;

    return TerminalViewPage(
      hostid: hostId,
      ownerid: widget.ownerid,
      terminalProvider: terminalProvider,
    );
  }

  // Modificación dentro del método build
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double paddText = size.width > 1300 ? 0 : 20;
    double sizedHeight = size.width > 1300 ? 20 : 0;
    double paddTerminal = size.width > 1300 ? 50 : 0;
    return Padding(
      padding: EdgeInsets.all(paddTerminal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(paddText),
            child: Text('Terminal View', style: CustomLabels.h1),
          ),
          SizedBox(height: sizedHeight),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Scaffold(
                appBar: AppBar(
                  bottom: _hostIds.isNotEmpty
                      ? TabBar(
                          controller: _tabController,

                          isScrollable:
                              true, // Añadir esto si quieres que las pestañas sean deslizables
                          tabs: _hostIds
                              .map((id) => Tab(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('Servidor $id'),
                                        GestureDetector(
                                          onTap: () {
                                            _closeTab(id);
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.only(left: 8),
                                            child: Icon(Icons.close, size: 10),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))
                              .toList(),
                        )
                      : null,
                ),
                body: IndexedStack(
                  index: _tabController?.index,
                  children: _hostIds
                      .map((id) => _hostViews[id] ?? Container())
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

// Método para cerrar una pestaña
  // Método para cerrar una pestaña
  void _closeTab(String hostId) {
    if (_hostIds.contains(hostId)) {
      setState(() {
        int indexToRemove = _hostIds.indexOf(hostId);
        bool wasSelected = _tabController?.index == indexToRemove;

        // Limpieza del estado
        _hostIds.removeAt(indexToRemove);
        _hostViews.remove(hostId);

        // Actualizar el sshConexionProvider para limpiar las conexiones y terminales
        final sshConexionprovider =
            Provider.of<sshConexionProvider>(context, listen: false);
        sshConexionprovider.removeConexion(hostId);
        sshConexionprovider.removeTerminalProviderById(hostId);

        // Comprobamos si todavía quedan pestañas después de eliminar una
        if (_hostIds.isEmpty) {
          // Si no quedan pestañas, regresamos al dashboard
          NavigationService.navigateTo('/dashboard');
        } else {
          // Si quedan pestañas, creamos un nuevo TabController con la longitud correcta
          _tabController?.dispose();
          _tabController = TabController(vsync: this, length: _hostIds.length);

          if (wasSelected) {
            // Si la pestaña cerrada estaba seleccionada, actualizamos la pestaña seleccionada
            _tabController?.index = min(indexToRemove, _hostIds.length - 1);
          }

          // Escuchar los cambios de selección de pestañas
          _tabController?.addListener(_handleTabSelection);
        }
      });
    }
  }
}
