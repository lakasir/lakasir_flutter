import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/screens/domain/setup_screen.dart';
import 'package:lakasir/widgets/filled_button.dart';

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final bool isLastPage;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.description,
    required this.image,
    this.isLastPage = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isTablet = constraints.maxWidth > 600;

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    image,
                    width: isTablet ? 400 : 200,
                    height: isTablet ? 400 : 200,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: isTablet ? 32 : 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isTablet ? 20 : 18,
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (isLastPage)
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: MyFilledButton(
                        onPressed: () {
                          Get.to(const SetupScreen());
                        },
                        child: Text(
                          'get_started'.tr,
                          style: TextStyle(fontSize: isTablet ? 20 : 16),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
