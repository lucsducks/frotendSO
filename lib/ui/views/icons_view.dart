import 'package:dashboardadmin/ui/views/visorhost_view.dart';
import 'package:flutter/material.dart';
import 'package:dashboardadmin/ui/labels/custom_labels.dart';

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
    double paddText = size.width > 1300 ? 0 : 20;
    double paddSFTP = size.width > 1300 ? 50 : 0;
    double sizedHeight = size.width > 1300 ? 20 : 0;
    return size.width > 700
        ? Padding(
            padding: EdgeInsets.all(paddSFTP),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(paddText),
                  child: Text('SFTP View', style: CustomLabels.h1),
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
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Expanded(
                            child: VisorHostView(),
                          ),
                          SizedBox(width: 20,),
                          Expanded(
                            child: VisorHostView(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
