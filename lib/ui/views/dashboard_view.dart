import 'package:dashboardadmin/providers/auth_provider.dart';
import 'package:dashboardadmin/ui/cards/white_card.dart';
import 'package:dashboardadmin/ui/labels/custom_labels.dart';
import 'package:dashboardadmin/ui/shared/widgets/colores_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user!;
    return Container(
      child: ListView(
        physics: ClampingScrollPhysics(),
        children: [
          Text('Dashboard View', style: CustomLabels.h1),
          SizedBox(height: 10),
          WhiteCard(
              title: user.nombre,
              child: Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Container(
                      height: 70, // Altura especificada
                      width: 300, // Ancho especificado
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // Imagen
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.asset(
                                ImgSample.get("fondo.png"),
                                height:
                                    60, // Ajusta para que sea proporcional al height de la tarjeta
                                width: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                                width: 10), // Espacio entre imagen y texto
                            // Textos
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment
                                  .center, // Centrar verticalmente
                              children: <Widget>[
                                Text(
                                  "Ubuntu Server",
                                  style: MyTextSample.title(context)!.copyWith(
                                    color: MyColorsSample.grey_80,
                                  ),
                                ),
                                Container(height: 5),
                                Text(
                                  "191.168.18.32",
                                  style: MyTextSample.body1(context)!.copyWith(
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ))
        ],
      ),
    );
  }
}
