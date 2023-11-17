import 'package:iziFile/datatables/usuario_datasource.dart';
import 'package:iziFile/providers/usuario_provider.dart';
import 'package:iziFile/ui/cards/white_card.dart';
import 'package:iziFile/ui/dropdate/custom_drop_date.dart';
import 'package:iziFile/ui/shared/widgets/search_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:iziFile/ui/labels/custom_labels.dart';

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
    final size = MediaQuery.of(context).size;
    double paddUsers = size.width > 1300 ? 50 : 0;
    double paddText = size.width > 1300 ? 0 : 20;
    double sizedHeight = size.width > 1300 ? 20 : 0;
    return Padding(
      padding: EdgeInsets.all(paddUsers),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(paddText),
            child: Text('Usuarios View', style: CustomLabels.h1),
          ),
          SizedBox(height: sizedHeight),
          Expanded(
            child: WhiteCard(
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
                            style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromARGB(255, 7, 31, 78)),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    DropdownButtonFormField<String>(
                                      value: filtroEstado,
                                      items: [
                                        DropdownMenuItem(
                                            value: null, child: Text('Todos')),
                                        DropdownMenuItem(
                                            value: "Activo",
                                            child: Text("Activo")),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    DropdownButton<String>(
                                      value: filtroEstado,
                                      items: [
                                        DropdownMenuItem(
                                            value: null, child: Text("Todos")),
                                        DropdownMenuItem(
                                            value: "Activo",
                                            child: Text("Activo")),
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
                          const SizedBox(height: 20),
                          PaginatedDataTable(
                            showCheckboxColumn: true,
                            primary: true,
                            showFirstLastButtons: true,
                            sortAscending: true,
                            arrowHeadColor: Colors.black,
                            columnSpacing: 20,
                            dataRowMaxHeight: 60,
                            columns: [
                              DataColumn(
                                  label: Text(
                                'ID',
                                style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color:
                                        const Color.fromARGB(255, 10, 125, 243),
                                    fontWeight: FontWeight.bold),
                              )),
                              DataColumn(
                                  label: Text(
                                'NOMBRE',
                                style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color:
                                        const Color.fromARGB(255, 10, 125, 243),
                                    fontWeight: FontWeight.bold),
                              )),
                              DataColumn(
                                  label: Text(
                                'CORREO',
                                style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color:
                                        const Color.fromARGB(255, 10, 125, 243),
                                    fontWeight: FontWeight.bold),
                              )),
                              DataColumn(
                                  label: Text(
                                'FECHA',
                                style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color:
                                        const Color.fromARGB(255, 10, 125, 243),
                                    fontWeight: FontWeight.bold),
                              )),
                              DataColumn(
                                  label: Text(
                                'ESTADO',
                                style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color:
                                        const Color.fromARGB(255, 10, 125, 243),
                                    fontWeight: FontWeight.bold),
                              )),
                              DataColumn(
                                  label: Text(
                                'ACCIONES',
                                style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color:
                                        const Color.fromARGB(255, 10, 125, 243),
                                    fontWeight: FontWeight.bold),
                              )),
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
            ),
          ),
        ],
      ),
    );
  }
}
