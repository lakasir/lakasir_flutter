import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lakasir/Exceptions/validation.dart';
import 'package:lakasir/api/api_service.dart';
import 'package:lakasir/api/responses/auths/forgot_password_error_response.dart';
import 'package:lakasir/api/responses/error_response.dart';
import 'package:lakasir/utils/auth.dart';
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
  bool isLoading = false;
  ForgotPasswordErrorResponse forgotErrorResponse =
      ForgotPasswordErrorResponse(email: "");

  Future<String> forgot() async {
    try {
      setState(() {
        isLoading = true;
      });
      if (!_formKey.currentState!.validate()) {
        setState(() {
          isLoading = false;
        });
        throw Exception("Please fill the form correctly");
      }
      await ApiService(await getDomain()).postData(
        'auth/forgot-password',
        {
          'email': emailController.text,
        },
      );

      return "";
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (e is ValidationException) {
        ErrorResponse<ForgotPasswordErrorResponse> errorResponse =
            ErrorResponse.fromJson(jsonDecode(e.toString()),
                (json) => ForgotPasswordErrorResponse.fromJson(json));

        setState(() {
          forgotErrorResponse = errorResponse.errors!;
        });
        return errorResponse.message;
      }

      return e.toString().replaceAll("Exception: ", "");
    }
  }

  @override
  void dispose() {
    emailController.dispose();
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
            Container(
              margin: const EdgeInsets.only(top: 116, bottom: 58),
              child: const Center(
                child: Text(
                  "Forgot Password",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
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
                        errorText: forgotErrorResponse.email,
                        controller: emailController,
                        label: "Email",
                        mandatory: true,
                      ),
                    ),
                    MyFilledButton(
                      isLoading: isLoading,
                      onPressed: () => {
                        forgot().then((value) {
                          setState(() {
                            isLoading = false;
                          });
                          if (value.isEmpty) {
                            Navigator.pushNamed(context, '/login');
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please check your email"),
                                backgroundColor: success,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: const Duration(seconds: 1),
                                content: Text(value),
                                backgroundColor: error,
                              ),
                            );
                          }
                        })
                      },
                      child: const Text("Submit"),
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
