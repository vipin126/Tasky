import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasky/Const/AppColor.dart';
import 'package:tasky/Const/TextStyle.dart';
import 'package:tasky/View/screens/SignUpScreen.dart';
import 'package:tasky/ViewModel/OnBoardingViewModel.dart';


class OnboardingScreen extends ConsumerWidget {
  OnboardingScreen({super.key});

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the current page index from the view model
    final currentPage = ref.watch(onboardingViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              // Update the view model when page changes
              ref.read(onboardingViewModelProvider.notifier).setPage(index);
            },
            children: const [
              OnboardingPageContent(
                title: 'Get things done.',
                subtitle: 'Just a click away from planning your tasks',
                imagePath: '✅', // Placeholder for image
              ),
              OnboardingPageContent(
                title: 'Stay organized.',
                subtitle: 'Manage your daily tasks with ease and efficiency',
                imagePath: '🗓️', // Placeholder for image
              ),
              OnboardingPageContent(
                title: 'Achieve your goals.',
                subtitle: 'Break down big tasks into smaller, manageable steps',
                imagePath: '🎯', // Placeholder for image
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DotsIndicator(
                    dotsCount: 3,
                    position: currentPage.toDouble(),
                    decorator: DotsDecorator(
                      size: const Size.square(9.0),
                      activeSize: const Size(18.0, 9.0),
                      activeShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      color: AppColors.lightGrey,
                      activeColor: AppColors.primaryPurple,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        onTap: () {
                          if (currentPage < 2) {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                            );
                          } else {
                            // Navigate to Sign Up screen on last page
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => SignUpScreen(),
                              ),
                            );
                          }
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: AppColors.primaryPurple,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryPurple.withOpacity(0.4),
                                spreadRadius: 2,
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.arrow_forward,
                            color: AppColors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}




class OnboardingPageContent extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath; // Placeholder for image/illustration

  const OnboardingPageContent({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Placeholder for the icon/image at the top
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primaryPurple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: Text(
                imagePath,
                style: const TextStyle(fontSize: 60), // Emoji as placeholder
              ),
            ),
          ),
          const SizedBox(height: 60),
          Text(
            title,
            style: AppTextStyles.onboardingTitle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            subtitle,
            style: AppTextStyles.onboardingSubtitle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 100), // Space for dots and button
        ],
      ),
    );
  }
}