import 'package:iziFile/ui/buttons/custom_icon_button.dart';
import 'package:flutter/material.dart';

class CustomDateRangePicker extends StatelessWidget {
  final Function(DateTimeRange) onDateRangeSelected;

  CustomDateRangePicker({required this.onDateRangeSelected});

  @override
  Widget build(BuildContext context) {
    return CustomIconButton(
        onPressed: () async {
          DateTimeRange? selectedDateRange = await showDateRangePicker(
            saveText: 'Filtrar',
            cancelText: 'Cancelar',
            helpText: 'Selecciona un rango de fechas',
            confirmText: 'Filtrar',
            context: context,
            firstDate: DateTime.now().subtract(Duration(days: 365)),
            lastDate: DateTime.now().add(Duration(days: 365)),
            builder: (BuildContext context, Widget? child) {
              return Theme(
                data: ThemeData.light().copyWith(
                  primaryColor: Colors.teal,
                  hintColor: Colors.teal,
                  colorScheme: ColorScheme.light(primary: Colors.teal),
                  buttonTheme:
                      ButtonThemeData(textTheme: ButtonTextTheme.primary),
                ),
                child: child!,
              );
            },
          );

          if (selectedDateRange != null) {
            onDateRangeSelected(selectedDateRange);
          }
        },
        icon: Icons.calendar_month,
        text: "Filtrar por fecha");
  }
}
