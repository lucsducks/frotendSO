import 'package:dashboardadmin/providers/auth_provider.dart';
import 'package:dashboardadmin/providers/verification_form_provider.dart';
import 'package:dashboardadmin/router/router.dart';
import 'package:dashboardadmin/ui/buttons/custom_filled_button.dart';
import 'package:dashboardadmin/ui/inputs/custom_inputs.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VerificationView extends StatelessWidget {
  const VerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return ChangeNotifierProvider(
        create: (_) => VerificationFormProvider(),
        child: Builder(builder: (context) {
          final verificationFormProvider =
              Provider.of<VerificationFormProvider>(context, listen: false);
          return Form(
            key: verificationFormProvider.formKey,
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
                  onChanged: (value) =>
                      verificationFormProvider.codigoVerificacion = value,
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
                CustomFilledButton(
                  onPressed: () {
                    final isValid = verificationFormProvider.validateForm();
                    if (isValid) {
                      authProvider.verification(
                          verificationFormProvider.codigoVerificacion);
                    }
                  },
                  text: 'Verificar',
                  icon: Icons.lock_clock,
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
