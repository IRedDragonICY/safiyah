// presentation/pages/onboarding/onboarding_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/colors.dart';
import '../../bloc/onboarding/onboarding_bloc.dart';
import '../../bloc/onboarding/onboarding_event.dart';
import 'onboarding_model.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingItem> _onboardingItems = const [
    OnboardingItem(
      imagePath: 'assets/images/onboarding_1.png',
      title: "Find Halal Places, Instantly",
      description:
          "Easily locate mosques, halal restaurants, and stores near you, wherever you are in the world.",
    ),
    OnboardingItem(
      imagePath: 'assets/images/onboarding_2.png',
      title: "Never Miss a Prayer",
      description:
          "Get precise prayer times and Qibla direction based on your location. Stay connected to your faith on the go.",
    ),
    OnboardingItem(
      imagePath: 'assets/images/onboarding_3.png',
      title: "Plan Your Perfect Halal Trip",
      description:
          "Create and manage detailed itineraries for your travels, ensuring a seamless and faith-compliant journey.",
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _onGetStarted() {
    context.read<OnboardingBloc>().add(CompleteOnboarding());
    context.go('/auth/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: _onboardingItems.length,
            itemBuilder: (context, index) {
              return _buildPage(
                context,
                item: _onboardingItems[index],
              );
            },
          ),
          _buildControls(context),
        ],
      ),
    );
  }

  Widget _buildPage(BuildContext context, {required OnboardingItem item}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            flex: 4,
            child: Image.asset(
              item.imagePath,
              height: MediaQuery.of(context).size.height * 0.4,
            ),
          ),
          const SizedBox(height: 64),
          Text(
            item.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            item.description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const Flexible(
            flex: 2,
            child: SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildControls(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _onboardingItems.length,
                  (index) => _buildDot(index: index),
                ),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentPage == _onboardingItems.length - 1) {
                      _onGetStarted();
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  child: Text(
                    _currentPage == _onboardingItems.length - 1
                        ? 'Get Started'
                        : 'Next',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (_currentPage != _onboardingItems.length - 1)
                TextButton(
                  onPressed: _onGetStarted,
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                )
              else
                SizedBox(
                  height:
                      Theme.of(context).textTheme.bodyLarge!.fontSize! * 1.5 +
                          16,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDot({required int index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: _currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
