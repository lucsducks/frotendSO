import 'package:dashboardadmin/providers/auth_provider.dart';
import 'package:dashboardadmin/providers/login_form_provider.dart';
import 'package:dashboardadmin/router/router.dart';
import 'package:dashboardadmin/ui/buttons/custom_outlined_button.dart';
import 'package:dashboardadmin/ui/buttons/link_text.dart';
import 'package:dashboardadmin/ui/inputs/custom_inputs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:core';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600;
    final authProvider = Provider.of<AuthProvider>(context);
    return ChangeNotifierProvider(
      create: (_) => LoginFormProvider(),
      child: Builder(
        builder: (context) {
          final loginFormProvider =
              Provider.of<LoginFormProvider>(context, listen: false);
          return SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(top: 50),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              color: Colors.white,
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 450),
                  child: Form(
                    key: loginFormProvider.formKey,
                    child: Column(
                      children: [
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
                          style: TextStyle(color: Colors.black87),
                          decoration: CustomInputs.loginInputDecoration(
                              hint: 'Ingrese su correo',
                              label: 'Email',
                              icon: Icons.email_outlined),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          onFieldSubmitted: (_) =>
                              onFormSubmit(loginFormProvider, authProvider),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingrese su contraseña';
                            }
                            return null; //valido
                          },
                          onChanged: (value) =>
                              loginFormProvider.password = value,
                          obscureText: true,
                          style: TextStyle(color: Colors.black87),
                          decoration: CustomInputs.loginInputDecoration(
                              hint: '*******',
                              label: 'Contraseña',
                              icon: Icons.lock_outline),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // Check if it's mobile and display either a Column or Row
                        isMobile
                            ? Column(
                                children: [
                                  CustomOutlinedButton(
                                    onPressed: () {
                                      final isValid =
                                          loginFormProvider.validateForm();
                                      if (isValid) {
                                        authProvider.login(
                                            loginFormProvider.email,
                                            loginFormProvider.password);
                                      }
                                    },
                                    text: 'Ingresar',
                                    icon: Icons.login,
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  CustomOutlinedButton(
                                    onPressed: () {
                                      final isValid =
                                          loginFormProvider.validateForm();
                                      if (isValid) {
                                        authProvider.login(
                                            loginFormProvider.email,
                                            loginFormProvider.password);
                                      }
                                    },
                                    text: 'Ingresar',
                                    icon: Icons.login,
                                  ),
                                ],
                              ),
                        SizedBox(
                          height: 20,
                        ),
                        LinkText(
                          text: 'Nueva Cuenta',
                          onPressed: () {
                            Navigator.pushNamed(
                                context, Flurorouter.registerRoute);
                          },
                        ),
                        SizedBox(
                          height: 100,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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
