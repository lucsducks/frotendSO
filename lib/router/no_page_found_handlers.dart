import 'package:iziFile/ui/views/no_page_found_view.dart';
import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';

class NoPageFoundHandlers {
  static Handler noPageFound = Handler(
      handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
    return NoPageFoundView(); // Asegúrate de que este widget esté definido y muestre el error adecuado.
  });
}
