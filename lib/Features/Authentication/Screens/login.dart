import 'package:flutter/material.dart';
import 'package:flutter_note_app_hive/Core/Common/CustomElevatedButton/custom_elevated_button.dart';
import 'package:flutter_note_app_hive/Core/app_export.dart';
import 'package:flutter_note_app_hive/Features/Authentication/Controller/auth_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Core/Theme/new_custom_text_style.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  static const googleLogo = "asset/google_logo.png";

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Login',
        style: GoogleFonts.poppins(),
      )),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator(
                color: appTheme.mainGreen,
              )
            : CustomElevatedButton(
                rightIcon: Image.asset(googleLogo),
                onPressed: () {
                  ref
                      .watch(authControllerProvider.notifier)
                      .signInWithGoogle(context: context);
                },
                buttonTextStyle: CustomPoppinsTextStyles.buttonText,
                text: isLoading ? "Loading " : "Continue with Google ",
                height: 50.v,
                width: SizeUtils.width * 0.7,
                // text: "Register",
                buttonStyle: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                    appTheme.mainGreen,
                  ),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                )),
      ),
    );
  }
}
