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
                          onboardingPages.length - 1,
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
                        Get.toNamed('/auth/mode-chooser');
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

class ModeChooserScreen extends StatelessWidget {
  const ModeChooserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.store, size: 80, color: primary),
              const SizedBox(height: 20),
              Text(
                'get_started'.tr,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'setup_choose_mode'.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Get.toNamed('/auth/offline-register'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(primary),
                    shape: MaterialStateProperty.all(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Column(
                      children: [
                        Text('use_offline'.tr,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Text('use_offline_description'.tr,
                            style: const TextStyle(fontSize: 13)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Get.to(const SetupScreen()),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Column(
                      children: [
                        Text('connect_to_server'.tr,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Text('connect_to_server_description'.tr,
                            style: const TextStyle(fontSize: 13)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}