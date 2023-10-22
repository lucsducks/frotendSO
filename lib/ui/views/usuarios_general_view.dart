import 'package:dashboardadmin/datatables/usuario_datasource.dart';
import 'package:dashboardadmin/providers/usuario_provider.dart';
import 'package:dashboardadmin/ui/cards/white_card.dart';
import 'package:dashboardadmin/ui/dropdate/custom_drop_date.dart';
import 'package:dashboardadmin/ui/shared/widgets/search_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsuarioSinRoleView extends StatefulWidget {
  @override
  State<UsuarioSinRoleView> createState() => _UsuarioSinRoleViewState();
}

class _UsuarioSinRoleViewState extends State<UsuarioSinRoleView> {
  int _rowsPerpage = PaginatedDataTable.defaultRowsPerPage;
  usuarioDTS? dataSource;
  String? filtroEstado;

  @override
  void initState() {
    super.initState();
    Provider.of<UsuariosSistemaProvider>(context, listen: false).getSinRoles();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final usuarios = Provider.of<UsuariosSistemaProvider>(context).usuarios;
    dataSource = usuarioDTS(context, usuarios);
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600;
    return WhiteCard(
      child: Expanded(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(16), // Espaciado uniforme
                physics: ClampingScrollPhysics(),
                children: [
                  Text(
                    'Usuarios en el sistema',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight
                            .bold), // Haciendo el título más prominente
                  ),
                  SizedBox(height: 20),
                  SearchText(
                    onChanged: (value) {
                      dataSource?.setFiltroPorNombre(value);
                    },
                  ),
                  SizedBox(height: 16),
                  isMobile
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            DropdownButtonFormField<String>(
                              value: filtroEstado,
                              items: [
                                DropdownMenuItem(
                                    value: null, child: Text("Todos")),
                                DropdownMenuItem(
                                    value: "Activo", child: Text("Activo")),
                                DropdownMenuItem(
                                    value: "Desactivado",
                                    child: Text("Desactivado")),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  filtroEstado = value;
                                });
                                dataSource?.setFiltro(filtroEstado);
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            CustomDateRangePicker(
                              onDateRangeSelected: (dateRange) {
                                dataSource?.filterByDate(dateRange);
                              },
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DropdownButton<String>(
                              value: filtroEstado,
                              items: [
                                DropdownMenuItem(
                                    value: null, child: Text("Todos")),
                                DropdownMenuItem(
                                    value: "Activo", child: Text("Activo")),
                                DropdownMenuItem(
                                    value: "Desactivado",
                                    child: Text("Desactivado")),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  filtroEstado = value;
                                });
                                dataSource?.setFiltro(filtroEstado);
                              },
                            ),
                            CustomDateRangePicker(
                              onDateRangeSelected: (dateRange) {
                                dataSource?.filterByDate(dateRange);
                              },
                            ),
                          ],
                        ),
                  SizedBox(height: 20), // Espaciado adicional
                  PaginatedDataTable(
                    showCheckboxColumn: true,
                    primary: true,
                    showFirstLastButtons: true,
                    sortAscending: true,
                    arrowHeadColor: Colors.black,
                    columnSpacing: 20,
                    dataRowMaxHeight: 60,
                    columns: [
                      DataColumn(label: Text('Id')),
                      DataColumn(label: Text('nombre')),
                      DataColumn(label: Text('correo')),
                      DataColumn(label: Text('Fecha')),
                      DataColumn(label: Text('estado')),
                      DataColumn(label: Text('Acciones')),
                    ],
                    source: dataSource!,
                    onRowsPerPageChanged: (value) {
                      setState(() {
                        _rowsPerpage = value ?? 10;
                      });
                    },
                    rowsPerPage: _rowsPerpage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
