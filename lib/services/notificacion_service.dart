import 'package:flutter/material.dart';

class NotificationsService {
  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void showSnackbarError(String message) {
    final snackBar = SnackBar(
      duration: Duration(seconds: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: Colors.white, width: 2),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.red.withOpacity(0.9),
      content: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.white, size: 24),
          SizedBox(width: 10.0),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      action: SnackBarAction(
        label: 'OK',
        textColor: Colors.white,
        onPressed: () {
          messengerKey.currentState!.hideCurrentSnackBar();
        },
      ),
    );

    messengerKey.currentState!.showSnackBar(snackBar);
  }

  static void showSnackbar(String message) {
    final snackBar = SnackBar(
      duration: Duration(seconds: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: Colors.white, width: 2),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor:
          Colors.green[700]!.withOpacity(0.9), // Color verde oscuro
      content: Row(
        children: [
          Icon(Icons.check_circle_outline,
              color: Colors.white, size: 24), // Icono de verificación
          SizedBox(width: 10.0),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      action: SnackBarAction(
        label: 'OK',
        textColor: Colors.white,
        onPressed: () {
          messengerKey.currentState!.hideCurrentSnackBar();
        },
      ),
    );

    messengerKey.currentState!.showSnackBar(snackBar);
  }
}
