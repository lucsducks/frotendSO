import 'dart:async';
import 'package:iziFile/providers/auth_provider.dart';
import 'package:iziFile/providers/verification_form_provider.dart';
import 'package:iziFile/ui/buttons/custom_filled_button.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pinput/pinput.dart';

class VerificationView extends StatefulWidget {
  const VerificationView({super.key});

  @override
  VerificationScreen createState() => VerificationScreen();
}

class VerificationScreen extends State<VerificationView> {
  int Counter = 90;

  void initState() {
    super.initState();
    StartTimer();
  }

  void StartTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (Counter > 0) {
        setState(() {
          Counter--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    String correoPersonal = args['correoPersonal'];
    String msgVerification =
        'Ingrese el código de verificación enviado a su correo: $correoPersonal';
    String tiempo = '$Counter segundos';
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
                  "Verificación",
                  style: GoogleFonts.poppins(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 10, 125, 243)),
                ),
                const SizedBox(
                  height: 40,
                ),
                Text(
                  msgVerification,
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromARGB(255, 7, 31, 78)),
                ),
                const SizedBox(
                  height: 30,
                ),
                Pinput(
                  length: 6,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese el código de verificación';
                    } else if (value.length != 6) {
                      return 'Ingrese los 6 dígitos';
                    }
                    return null;
                  },
                  onChanged: (value) =>
                      verificationFormProvider.codigoVerificacion = value,
                  defaultPinTheme: PinTheme(
                      width: 60,
                      height: 60,
                      textStyle: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromARGB(255, 7, 31, 78)),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                            width: 2,
                            color: const Color.fromARGB(255, 10, 125, 243)),
                      )),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                  icon: Icons.lock_person,
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '¿No recibiste el código?',
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
                          if (Counter == 0) {
                            authProvider.resend(correoPersonal);
                            Counter = 90;
                            StartTimer();
                          }
                        },
                        child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Container(
                              padding: const EdgeInsets.only(
                                bottom: 1, // Space between underline and text
                              ),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                color: Counter == 0
                                    ? const Color.fromARGB(255, 10, 125, 243)
                                    : Colors.white,
                                width: 1, // Underline thickness
                              ))),
                              child: Text(
                                Counter == 0 ? 'Reenviar' : tiempo,
                                style: GoogleFonts.poppins(
                                  color: Counter == 0
                                      ? const Color.fromARGB(255, 10, 125, 243)
                                      : const Color.fromARGB(
                                          255, 209, 209, 209),
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
