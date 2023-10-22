import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatefulWidget {
  final List<T> items;
  final String Function(T) getLabel;
  final String Function(T) getValue;
  final String? selectedValue;
  final ValueChanged<String?> onChanged;
  final String hintText;

  CustomDropdown({
    required this.items,
    required this.getLabel,
    required this.getValue,
    this.selectedValue,
    required this.onChanged,
    this.hintText = 'Seleccione un ítem',
  });

  @override
  _CustomDropdownState<T> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  late Map<String, String> nameToUid;
  TextEditingController textEditingController = TextEditingController();
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    nameToUid = {
      for (var item in widget.items)
        widget.getLabel(item): widget.getValue(item)
    };
    selectedValue = widget.selectedValue;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButtonFormField2<String>(
        isExpanded: true,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        hint: Text(
          widget.hintText,
          style: TextStyle(fontSize: 14),
        ),
        onSaved: (value) {
          selectedValue = value.toString();
        },
        buttonStyleData: const ButtonStyleData(
          padding: EdgeInsets.only(right: 8),
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(
            Icons.arrow_drop_down,
            color: Colors.black45,
          ),
          iconSize: 24,
        ),
        dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          padding: EdgeInsets.symmetric(horizontal: 16),
        ),
        items: widget.items
            .map((e) => DropdownMenuItem(
                  child: Text(widget.getLabel(e)),
                  value: widget.getValue(e),
                ))
            .toList(),
        dropdownSearchData: DropdownSearchData(
          searchController: textEditingController,
          searchInnerWidgetHeight: 50,
          searchInnerWidget: Container(
            height: 50,
            padding: const EdgeInsets.only(
              top: 8,
              bottom: 4,
              right: 8,
              left: 8,
            ),
            child: TextFormField(
              expands: true,
              maxLines: null,
              controller: textEditingController,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                hintText: 'Search for an item...',
                hintStyle: const TextStyle(fontSize: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          searchMatchFn: (DropdownMenuItem<String> item, String searchValue) {
            String? uid = item.value;
            return nameToUid.entries
                .where((entry) =>
                    entry.key.toLowerCase().contains(searchValue.toLowerCase()))
                .any((entry) => entry.value == uid);
          },
        ),
        value: selectedValue,
        onChanged: (value) {
          setState(() {
            selectedValue = value;
          });
          widget.onChanged(value);
        },
      ),
    );
  }
}
