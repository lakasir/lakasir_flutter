import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/screens/domain/setup_screen.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/widgets/layout.dart';
import 'package:lakasir/widgets/onboarding_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentPageIndex = 0;

  final List<Widget> onboardingPages = [
    OnboardingPage(
      title: 'welcome'.tr,
      description: 'welcome_description'.tr,
      image: 'assets/onboards/onboarding-image-1.png',
    ),
    OnboardingPage(
      title: 'Manage Your Products Efficiently'.tr,
      description: 'Manage Your Products Efficiently_description'.tr,
      image: 'assets/onboards/onboarding-image-2.png',
    ),
    OnboardingPage(
      title: 'Streamlined Transactions'.tr,
      description: 'Streamlined Transactions_description'.tr,
      image: 'assets/onboards/onboarding-image-3.png',
    ),
    OnboardingPage(
      title: 'Insightful Reporting'.tr,
      description: 'Insightful Reporting_description'.tr,
      image: 'assets/onboards/onboarding-image-4.png',
    ),
    OnboardingPage(
      title: 'Customizable Settings'.tr,
      description: 'Customizable Settings_description'.tr,
      image: 'assets/onboards/onboarding-image-5.png',
    ),
    OnboardingPage(
      title: 'Continuous Support'.tr,
      description: 'Continuous Support_description'.tr,
      image: 'assets/onboards/onboarding-image-2.png',
      isLastPage: true,
    ),
  ];

  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Layout(
      noAppBar: true,
      noPadding: true,
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: pageController,
              itemCount: onboardingPages.length,
              itemBuilder: (context, index) {
                return onboardingPages[index];
              },
              onPageChanged: (index) {
                setState(() {
                  currentPageIndex = index;
                });
              },
            ),
          ),
          Center(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Visibility(
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: currentPageIndex != (onboardingPages.length - 1),
                    child: TextButton(
                      onPressed: () {
                        pageController.animateToPage(
                          onboardingPages.length,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Text("skip".tr),
                    ),
                  ),
                  Row(
                    children: [
                      for (int i = 0; i < onboardingPages.length; i++)
                        GestureDetector(
                          onTap: () {
                            pageController.animateToPage(
                              i,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: i == currentPageIndex
                                  ? primary
                                  : Colors.grey.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      if (currentPageIndex == (onboardingPages.length - 1)) {
                        Get.to(const SetupScreen());
                        return;
                      }
                      double nextPage = pageController.page! + 1;
                      pageController.animateToPage(
                        nextPage.toInt(),
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    icon: Icon(
                      currentPageIndex == (onboardingPages.length - 1)
                          ? Icons.check
                          : Icons.skip_next,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
