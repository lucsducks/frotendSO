import 'package:dashboardadmin/ui/views/sftp_view.dart';
import 'package:dashboardadmin/ui/views/visorhost_view.dart';
import 'package:flutter/material.dart';

class IconsView extends StatefulWidget {
  const IconsView({super.key});

  @override
  State<IconsView> createState() => _IconsViewState();
}

class _IconsViewState extends State<IconsView> with TickerProviderStateMixin {
  // Agrega un controlador de tab para administrar las pestañas
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return size.width > 700
        ? Row(
            children: [
              Expanded(
                // Envuelve SftpView en un Expanded
                child: VisorHostView(),
              ),
              Expanded(
                // Envuelve el segundo SftpView en otro Expanded
                child: VisorHostView(),
              ),
            ],
          )
        : DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                title: Text('SFTP'),
                bottom: TabBar(
                  controller: _tabController, // Asocia el controlador de tab
                  tabs: [
                    Tab(text: 'Host 1'),
                    Tab(text: 'Host 2'),
                  ],
                ),
              ),
              body: TabBarView(
                controller: _tabController, // Asocia el controlador de tab
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: VisorHostView(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: VisorHostView(),
                  ),
                ],
              ),
            ),
          );
  }
}
