import 'package:dashboardadmin/providers/auth_provider.dart';
import 'package:dashboardadmin/providers/register_form_provider.dart';
import 'package:dashboardadmin/router/router.dart';
import 'package:dashboardadmin/ui/buttons/custom_filled_button.dart';
import 'package:dashboardadmin/ui/inputs/custom_inputs.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600;
    final authProvider = Provider.of<AuthProvider>(context);
    return ChangeNotifierProvider(
        create: (_) => RegisterFormProvider(),
        child: Builder(builder: (context) {
          final registerFormProvider =
              Provider.of<RegisterFormProvider>(context, listen: false);
          return Form(
            key: registerFormProvider.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Crear cuenta",
                  style: GoogleFonts.poppins(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 10, 125, 243)),
                ),
                const SizedBox(
                  height: 40,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese su usuario';
                    }
                    return null;
                  },
                  onChanged: (value) => registerFormProvider.nombre = value,
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromARGB(255, 7, 31, 78)),
                  decoration: CustomInputs.loginInputDecoration(
                      hint: 'Ingrese su usuario',
                      label: 'Usuario',
                      icon: Icons.supervised_user_circle_sharp),
                ),
                const SizedBox(
                  height: 40,
                ),
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
                  onChanged: (value) => registerFormProvider.email = value,
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese su contraseña';
                    }
                    if (value.length < 8) {
                      return 'La contraseña debe tener al menos 8 caracteres';
                    }
                    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
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
                  onChanged: (value) => registerFormProvider.password = value,
                  obscureText: true,
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromARGB(255, 7, 31, 78)),
                  decoration: CustomInputs.loginInputDecoration(
                      hint: '*******',
                      label: 'Contraseña',
                      icon: Icons.lock_outline),
                ),
                const SizedBox(
                  height: 40,
                ),
                // Column(
                //   children: [
                //     CustomFilledButton(
                //       onPressed: () {
                //         final isValid = registerFormProvider.validateForm();
                //         if (isValid) {
                //           authProvider.register(
                //               registerFormProvider.email,
                //               registerFormProvider.password,
                //               registerFormProvider.nombre);
                //         }
                //       },
                //       text: 'Registrar',
                //       icon: Icons.login,
                //     ),
                //   ],
                // ),
                CustomFilledButton(
                  onPressed: () {
                    final isValid = registerFormProvider.validateForm();
                    if (isValid) {
                      authProvider.register(
                          registerFormProvider.email,
                          registerFormProvider.password,
                          registerFormProvider.nombre);
                    }
                  },
                  text: 'Registrar',
                  icon: Icons.login,
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '¿Ya tienes una cuenta?',
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
                          Navigator.pushNamed(context, Flurorouter.loginRoute);
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
                                'Iniciar sesión',
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
        }));
  }
}
