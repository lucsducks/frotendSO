import 'package:iziFile/providers/auth_provider.dart';
import 'package:iziFile/providers/login_form_provider.dart';
import 'package:iziFile/router/router.dart';
import 'package:iziFile/ui/buttons/custom_filled_button.dart';
import 'package:iziFile/ui/inputs/custom_inputs.dart';
import 'package:flutter/material.dart';
import "package:google_fonts/google_fonts.dart";
import 'package:provider/provider.dart';
import 'dart:core';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  LoginScreen createState() => LoginScreen();
}

class LoginScreen extends State<LoginView> {
  bool passwordVisible = false;
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return ChangeNotifierProvider(
      create: (_) => LoginFormProvider(),
      child: Builder(
        builder: (context) {
          final loginFormProvider =
              Provider.of<LoginFormProvider>(context, listen: false);
          return Form(
            key: loginFormProvider.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Iniciar sesión",
                  style: GoogleFonts.poppins(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 10, 125, 243)),
                ),
                const SizedBox(
                  height: 40,
                ),
                TextFormField(
                  onFieldSubmitted: (_) =>
                      onFormSubmit(loginFormProvider, authProvider),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese su correo';
                    }
                    if (!RegExp(
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                        .hasMatch(value)) {
                      return 'Ingrese un correo válido';
                    }
                    return null;
                  },
                  onChanged: (value) => loginFormProvider.email = value,
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromARGB(255, 7, 31, 78)),
                  decoration: CustomInputs.loginInputDecoration(
                      hint: 'Ingrese su correo',
                      label: 'Email',
                      icon: Icons.email_outlined),
                ),
                const SizedBox(
                  height: 40,
                ),
                TextFormField(
                    controller: passwordController,
                    obscureText: !passwordVisible,
                    onFieldSubmitted: (_) =>
                        onFormSubmit(loginFormProvider, authProvider),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingrese su contraseña';
                      }
                      return null; //valido
                    },
                    onChanged: (value) => loginFormProvider.password = value,
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: const Color.fromARGB(255, 7, 31, 78)),
                    decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        border: const OutlineInputBorder(),
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 10, 125, 243))),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 10, 125, 243)),
                        ),
                        errorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 247, 36, 36))),
                        focusedErrorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 10, 125, 243))),
                        hintText: 'Ingrese su contraseña',
                        hintStyle: const TextStyle(
                            color: Color.fromARGB(255, 209, 209, 209),
                            fontSize: 16),
                        labelText: 'Contraseña',
                        labelStyle: GoogleFonts.poppins(
                          color: Colors.blue,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: Color.fromARGB(255, 209, 209, 209),
                        ),
                        suffixIcon: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  passwordVisible = !passwordVisible;
                                });
                              },
                              icon: Icon(
                                  passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color:
                                      const Color.fromARGB(255, 209, 209, 209)),
                            ),
                            const SizedBox(width: 10)
                          ],
                        ))),
                const SizedBox(
                  height: 40,
                ),
                CustomFilledButton(
                  onPressed: () {
                    final isValid = loginFormProvider.validateForm();
                    if (isValid) {
                      authProvider.login(
                          loginFormProvider.email, loginFormProvider.password);
                    }
                  },
                  text: 'Ingresar',
                  icon: Icons.login,
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '¿No tienes una cuenta?',
                      style: GoogleFonts.poppins(
                        color: const Color.fromARGB(255, 7, 31, 78),
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                              context, Flurorouter.registerRoute);
                        },
                        child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Container(
                              padding: const EdgeInsets.only(
                                bottom: 1, // Space between underline and text
                              ),
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                color: Color.fromARGB(255, 10, 125, 243),
                                width: 1.0, // Underline thickness
                              ))),
                              child: Text(
                                'Registrarse',
                                style: GoogleFonts.poppins(
                                  color:
                                      const Color.fromARGB(255, 10, 125, 243),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ))),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

  void onFormSubmit(
      LoginFormProvider loginFormProvider, AuthProvider authProvider) {
    final isValid = loginFormProvider.validateForm();
    if (isValid) {
      authProvider.login(loginFormProvider.email, loginFormProvider.password);
    }
  }
}
