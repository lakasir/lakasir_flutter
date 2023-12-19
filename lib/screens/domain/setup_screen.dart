import 'package:flutter/material.dart';
import 'package:lakasir/utils/auth.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/widgets/filled_button.dart';
import 'package:lakasir/widgets/text_field.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({Key? key}) : super(key: key);

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _SetupScreenState extends State<SetupScreen> {
  final registerDomainController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    registerDomainController.dispose();
    super.dispose();
  }

  void setup() async {
    final context = this.context;
    setState(() {
      isLoading = true;
    });
    if (!_formKey.currentState!.validate()) {
      setState(() {
        isLoading = false;
      });
      return;
    }
    try {
      await storeSetup(registerDomainController.text);
      Navigator.pushNamed(context, '/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something went wrong"),
          backgroundColor: error,
        ),
      );
    }
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
                        text: "Access to your",
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
                        controller: registerDomainController,
                        label: "Your Registered Domain",
                        mandatory: true,
                      ),
                    ),
                    MyFilledButton(
                        isLoading: isLoading,
                        onPressed: setup,
                        child: const Text("Setup!")),
                  ],
                ),
              ),
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/domain/register');
                },
                child: SizedBox(
                  width: 300,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      children: [
                        TextSpan(
                          text:
                              "Are you the owner, and you don’t have the Domain yet?",
                          style: TextStyle(color: Colors.grey),
                        ),
                        WidgetSpan(child: SizedBox(width: 4.0)),
                        TextSpan(
                          text: "Please create!",
                          style: TextStyle(
                            color: primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
