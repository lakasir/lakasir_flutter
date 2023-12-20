import 'package:flutter/material.dart';
import 'package:lakasir/api/responses/auths/login_error_response.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/widgets/filled_button.dart';
import 'package:lakasir/widgets/text_field.dart';

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({super.key});
  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _ForgotScreenState extends State<ForgotScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool remember = false;
  bool isLoading = false;
  LoginErrorResponse loginErrorResponse =
      LoginErrorResponse(password: "", email: "");

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroudWhite,
      body: SafeArea(
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            // wellcome text
            Container(
              margin: const EdgeInsets.only(top: 116, bottom: 58),
              child: const Center(
                  child: Text(
                "Forgot Password",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                ),
              )),
            ),

            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 21.0),
                      child: MyTextField(
                        errorText: loginErrorResponse.password,
                        controller: passwordController,
                        label: "Password",
                        mandatory: true,
                        obscureText: true,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 21.0),
                      child: MyTextField(
                        errorText: loginErrorResponse.password,
                        controller: passwordController,
                        label: "Confirm Password",
                        mandatory: true,
                        obscureText: true,
                      ),
                    ),
                    MyFilledButton(
                        isLoading: isLoading,
                        onPressed: () => {},
                        child: const Text("Confirm")),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
