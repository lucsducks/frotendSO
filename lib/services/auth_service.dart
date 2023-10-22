import 'package:dashboardadmin/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

class AuthService {
  final String googleClientId =
      '913720773810-p47g2cnq3gi7f70pivjesv2dv09fct4s.apps.googleusercontent.com';
  final String callbackUrlScheme =
      'com.googleusercontent.apps.913720773810-p47g2cnq3gi7f70pivjesv2dv09fct4s';

  Future<void> loginWithGoogle(context) async {
    try {
      final authUrl = Uri.https(
        'accounts.google.com',
        '/o/oauth2/v2/auth',
        {
          'response_type': 'code',
          'client_id': googleClientId,
          'redirect_uri': '$callbackUrlScheme:/',
          'scope': 'email profile openid', // Modificado aquí
        },
      );
      debugPrint(authUrl.toString());

      final result = await FlutterWebAuth2.authenticate(
        url: authUrl.toString(),
        callbackUrlScheme: callbackUrlScheme,
      );
      debugPrint("paso");
      debugPrint(result);
      final code = Uri.parse(result).queryParameters['code'];

      final tokenUrl = Uri.https('www.googleapis.com', 'oauth2/v4/token');

      final response = await http.post(
        tokenUrl,
        body: {
          'client_id': googleClientId,
          'redirect_uri': '$callbackUrlScheme:/',
          'grant_type': 'authorization_code',
          'code': code,
        },
      );

      final accessToken = jsonDecode(response.body)['access_token'] as String;
      final idToken =
          jsonDecode(response.body)['id_token'] as String; // Línea añadida

      debugPrint('Access Token: $accessToken');
      debugPrint('ID Token: $idToken'); // Línea añadida

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.googleSignIn(idToken, context);

      // Continúa con el proceso de autenticación en tu aplicación...
    } catch (e) {
      debugPrint('Error during Google login: $e');
    }
  }
}
