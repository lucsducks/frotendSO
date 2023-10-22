import 'package:dashboardadmin/providers/auth_provider.dart';
import 'package:dashboardadmin/providers/register_form_provider.dart';
import 'package:dashboardadmin/router/router.dart';
import 'package:dashboardadmin/ui/buttons/custom_outlined_button.dart';
import 'package:dashboardadmin/ui/buttons/link_text.dart';
import 'package:dashboardadmin/ui/inputs/custom_inputs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine if the screen width is less than a certain breakpoint (e.g., 600)
    final authProvider = Provider.of<AuthProvider>(context);
    return ChangeNotifierProvider(
        create: (_) => RegisterFormProvider(),
        child: Builder(builder: (context) {
          final registerFormProvider =
              Provider.of<RegisterFormProvider>(context, listen: false);
          return Container(
            margin: const EdgeInsets.only(top: 50),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            color: Colors.white,
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 450),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: Form(
                    key: registerFormProvider.formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          // validator: ,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingrese su nombre';
                            }
                            return null;
                          },
                          onChanged: (value) =>
                              registerFormProvider.nombre = value,
                          style: TextStyle(color: Colors.black87),
                          decoration: CustomInputs.loginInputDecoration(
                              hint: 'Ingrese su nombre',
                              label: 'Nombre',
                              icon: Icons.supervised_user_circle_sharp),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          // validator: ,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingrese su apellido';
                            }
                            return null;
                          },
                          onChanged: (value) =>
                              registerFormProvider.apellido = value,
                          style: TextStyle(color: Colors.black87),
                          decoration: CustomInputs.loginInputDecoration(
                              hint: 'Ingrese su apellido',
                              label: 'Apellido',
                              icon: Icons.person_2_outlined),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          // validator: ,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingrese su dni';
                            }
                            return null;
                          },
                          onChanged: (value) =>
                              registerFormProvider.dni = value,
                          style: TextStyle(color: Colors.black87),
                          decoration: CustomInputs.loginInputDecoration(
                              hint: 'Ingrese su dni',
                              label: 'DNI',
                              icon: Icons.document_scanner),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // TextFormField(
                        //   // validator: ,
                        //   style: TextStyle(color: Colors.black87),
                        //   decoration: CustomInputs.loginInputDecoration(
                        //       hint: 'Ingrese su nivel de educacion',
                        //       label: 'Nivel de educacion',
                        //       icon: Icons.supervised_user_circle_sharp),
                        // ),
                        // SizedBox(
                        //   height: 20,
                        // ),
                        TextFormField(
                          // validator: ,
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
                          onChanged: (value) =>
                              registerFormProvider.email = value,
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingrese su contraseña';
                            }
                            if (value.length < 8) {
                              return 'La contraseña debe tener al menos 8 caracteres';
                            }
                            if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]')
                                .hasMatch(value)) {
                              return 'La contraseña debe contener al menos un carácter especial';
                            }
                            if (!RegExp(r'[0-9]').hasMatch(value)) {
                              return 'La contraseña debe contener al menos un número';
                            }
                            if (!RegExp(r'[A-Z]').hasMatch(value)) {
                              return 'La contraseña debe contener al menos una letra mayúscula';
                            }
                            if (!RegExp(r'[a-z]').hasMatch(value)) {
                              return 'La contraseña debe contener al menos una letra minúscula';
                            }
                            if (value.contains(' ')) {
                              return 'La contraseña no debe contener espacios';
                            }
                            return null; // valido
                          },
                          onChanged: (value) =>
                              registerFormProvider.password = value,
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
                        CustomOutlinedButton(
                          onPressed: () {
                            final isValid = registerFormProvider.validateForm();
                            if (isValid) {
                              authProvider.register(
                                  registerFormProvider.email,
                                  registerFormProvider.password,
                                  registerFormProvider.nombre,
                                  registerFormProvider.dni,
                                  registerFormProvider.apellido);
                            }
                          },
                          text: 'Registrar',
                          icon: Icons.login,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        LinkText(
                          text: 'Ir al login',
                          onPressed: () {
                            Navigator.pushNamed(
                                context, Flurorouter.loginRoute);
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }));
  }
}
