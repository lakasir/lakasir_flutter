import 'package:flutter/material.dart';
import 'package:lakasir/api/responses/auths/login_error_response.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/widgets/checkbox.dart';
import 'package:lakasir/widgets/filled_button.dart';
import 'package:lakasir/widgets/text_field.dart';

class RegisterDomainScreen extends StatefulWidget {
  const RegisterDomainScreen({super.key});
  @override
  State<RegisterDomainScreen> createState() => _RegisterDomainScreenState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _RegisterDomainScreenState extends State<RegisterDomainScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool agree = false;
  bool isLoading = false;
  LoginErrorResponse loginErrorResponse = LoginErrorResponse(password: "", email: "");

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
              margin: const EdgeInsets.only(top: 80, bottom: 35),
              child: Center(
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                    ),
                    children: [
                      TextSpan(
                        text: "Sign Up",
                        style: TextStyle(color: Colors.black),
                      ),
                      WidgetSpan(
                        child: SizedBox(width: 8.0), // Add space between spans
                      ),
                      TextSpan(
                        text: "LAKASIR",
                        style: TextStyle(color: primary),
                      ),
                    ],
                  ),
                ),
              ),
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
                        controller: emailController,
                        errorText: loginErrorResponse.email,
                        label: "Full Name",
                        mandatory: true,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 21.0),
                      child: MyTextField(
                        controller: emailController,
                        errorText: loginErrorResponse.email,
                        label: "Domain Name",
                        mandatory: true,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 21.0),
                      child: MyTextField(
                        controller: emailController,
                        errorText: loginErrorResponse.email,
                        label: "Email or Phone Number",
                        mandatory: true,
                      ),
                    ),
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
                        label: "Password Confirmation",
                        mandatory: true,
                        obscureText: true,
                      ),
                    ),

                    // Remember Box
                    Container(
                      margin: const EdgeInsets.only(bottom: 21.0),
                      child: MyCheckbox(
                        label: "By creating the shop, you agree to our Terms and Conditions",
                        onChange: (bool value) {
                          setState(() {
                            agree = value;
                          });
                        },
                      ),
                    ),

                    MyFilledButton(
                      isLoading: isLoading,
                      onPressed: () {},
                      child: const Text("Create Your Shop"),
                    ),
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

