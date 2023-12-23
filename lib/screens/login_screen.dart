import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lakasir/Exceptions/validation.dart';
import 'package:lakasir/api/api_service.dart';
import 'package:lakasir/api/responses/api_response.dart';
import 'package:lakasir/api/responses/auths/login_error_response.dart';
import 'package:lakasir/api/responses/auths/login_response.dart';
import 'package:lakasir/api/responses/error_response.dart';
import 'package:lakasir/utils/auth.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/widgets/checkbox.dart';
import 'package:lakasir/widgets/filled_button.dart';
import 'package:lakasir/widgets/text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool remember = false;
  bool isLoading = false;
  LoginErrorResponse loginErrorResponse = LoginErrorResponse(
    password: "",
    email: "",
  );

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<bool> login() async {
    setState(() {
      isLoading = true;
    });
    if (!_formKey.currentState!.validate()) {
      setState(() {
        isLoading = false;
      });
      return false;
    }

    try {
      final response = await ApiService(await getDomain()).postData(
        'auth/login',
        {
          'email': emailController.text,
          'password': passwordController.text,
          'remember': remember
        },
      );

      ApiResponse<LoginResponse> apiResponse = ApiResponse.fromJson(
        response,
        (json) => LoginResponse.fromJson(json),
      );

      storeToken(apiResponse.data!.value.token);
      return true;
    } catch (e) {
      if (e is ValidationException) {
        ErrorResponse<LoginErrorResponse> errorResponse =
            ErrorResponse.fromJson(jsonDecode(e.toString()),
                (json) => LoginErrorResponse.fromJson(json));

        setState(() {
          loginErrorResponse = errorResponse.errors!;
        });
      }
      setState(() {
        isLoading = false;
      });
      return false;
    }
  }

  @override
  void didChangeDependencies() {
    // getDomain().then((value) {
    //   if (value != null) {
    //     Navigator.pushNamed(context, '/menu');
    //   }
    // });
    print("didChangeDependencies");
    super.didChangeDependencies();
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
              child: Center(
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                    ),
                    children: [
                      TextSpan(
                        text: "Sign In",
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
                    // Email Input
                    Container(
                      margin: const EdgeInsets.only(bottom: 21.0),
                      child: MyTextField(
                        controller: emailController,
                        errorText: loginErrorResponse.email,
                        label: "Email",
                        mandatory: true,
                      ),
                    ),
                    // Password Input
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

                    // Remember Box
                    Container(
                      margin: const EdgeInsets.only(bottom: 21.0),
                      child: MyCheckbox(
                        label: "Remember me",
                        onChange: (bool value) {
                          setState(() {
                            remember = value;
                          });
                        },
                      ),
                    ),

                    // Sign In Button
                    MyFilledButton(
                      isLoading: isLoading,
                      onPressed: () {
                        login().then((value) {
                          if (value) {
                            Get.offAllNamed('/auth');
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Something went wrong"),
                                backgroundColor: error,
                              ),
                            );
                          }
                        });
                      },
                      child: const Text("Sign In"),
                    ),
                  ],
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.only(bottom: 40),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/forgot');
                  },
                  child: const Text(
                    "Forgot the password?",
                    style: TextStyle(
                      color: primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
