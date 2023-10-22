import 'package:flutter/material.dart';

class RegisterFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  String email = '';
  String password = '';
  String nombre = '';
  String apellido = '';
  String dni = '';
  validateForm() {
    if (formKey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }

  //TODO: HACER LOGIN GOOGLE
  validateGoogle() {}
}
