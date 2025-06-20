// presentation/pages/onboarding/onboarding_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/colors.dart';
import '../../../routes/route_names.dart';
import '../../bloc/onboarding/onboarding_bloc.dart';
import '../../bloc/onboarding/onboarding_event.dart';
import '../../bloc/onboarding/onboarding_state.dart';
import '../../bloc/settings/settings_bloc.dart';
import '../../bloc/settings/settings_event.dart';
import 'accessibility_onboarding_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  Map<String, dynamic> _accessibilityData = {};

  @override
  void initState() {
    super.initState();
    // Start onboarding flow
    context.read<OnboardingBloc>().add(const StartOnboarding());
  }

  void _handleAccessibilityData(Map<String, dynamic> data) {
    setState(() {
      _accessibilityData = data;
    });
  }

  void _nextPage() {
    final state = context.read<OnboardingBloc>().state;
    if (state is OnboardingInProgress) {
      if (state.currentPage < _getTotalPages() - 1) {
        context.read<OnboardingBloc>().add(const NextPageRequested());
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        _completeOnboarding();
      }
    }
  }

  void _previousPage() {
    final state = context.read<OnboardingBloc>().state;
    if (state is OnboardingInProgress && state.currentPage > 0) {
      context.read<OnboardingBloc>().add(const PreviousPageRequested());
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _completeOnboarding() {
    // Save accessibility preferences before completing onboarding
    if (_accessibilityData.isNotEmpty) {
      _saveAccessibilityPreferences();
    }
    
    context.read<OnboardingBloc>().add(const CompleteOnboardingFlow());
  }

  void _saveAccessibilityPreferences() {
    final settingsBloc = context.read<SettingsBloc>();
    
    // Apply accessibility settings
    if (_accessibilityData['hasDisability'] == true) {
      settingsBloc.add(const ToggleAccessibilityFeatures(enabled: true));
      
      if (_accessibilityData['isVisuallyImpaired'] == true) {
        settingsBloc.add(const ToggleVisualImpairment(enabled: true));
        
        if (_accessibilityData['enableEyeControl'] == true) {
          settingsBloc.add(const ToggleEyeControl(enabled: true));
        }
        
        if (_accessibilityData['enableScreenReader'] == true) {
          settingsBloc.add(const ToggleScreenReader(enabled: true));
        }
        
        if (_accessibilityData['enableVoiceCommands'] == true) {
          settingsBloc.add(const ToggleVoiceCommands(enabled: true));
        }
      }
      
      if (_accessibilityData['hasColorBlindness'] == true) {
        settingsBloc.add(const ToggleColorBlindness(enabled: true));
        
        final colorBlindnessType = _accessibilityData['colorBlindnessType'] as String? ?? 'none';
        if (colorBlindnessType != 'none') {
          settingsBloc.add(ChangeColorBlindnessType(type: colorBlindnessType));
        }
        
        if (_accessibilityData['enableHighContrast'] == true) {
          settingsBloc.add(const ToggleHighContrast(enabled: true));
        }
      }
    }
  }

  int _getTotalPages() => 4; // Welcome, Accessibility, Location, Complete

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OnboardingBloc, OnboardingState>(
      listener: (context, state) {
        if (state is OnboardingCompleted) {
          context.go(RouteNames.home);
        }
      },
      builder: (context, state) {
        if (state is OnboardingInitial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is! OnboardingInProgress) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: Column(
              children: [
                // Progress indicator
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      if (state.currentPage > 0)
                        IconButton(
                          onPressed: _previousPage,
                          icon: const Icon(Icons.arrow_back_ios),
                        ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: LinearProgressIndicator(
                          value: (state.currentPage + 1) / _getTotalPages(),
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        '${state.currentPage + 1} / ${_getTotalPages()}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Page content
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildWelcomePage(context),
                      AccessibilityOnboardingPage(
                        onNext: _nextPage,
                        onAccessibilitySet: _handleAccessibilityData,
                      ),
                      _buildLocationPage(context),
                      _buildCompletePage(context),
                    ],
                  ),
                ),
                
                // Navigation buttons
                Container(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      if (state.currentPage > 0)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _previousPage,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Back'),
                          ),
                        ),
                      if (state.currentPage > 0) const SizedBox(width: 16),
                      Expanded(
                        flex: state.currentPage == 0 ? 1 : 1,
                        child: FilledButton(
                          onPressed: state.currentPage == 1 && _accessibilityData.isEmpty 
                              ? null 
                              : _nextPage,
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            state.currentPage == _getTotalPages() - 1 
                                ? 'Get Started' 
                                : 'Continue',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWelcomePage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          const Spacer(flex: 1),
          
          // Hero illustration
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.mosque,
              size: 80,
              color: AppColors.primary,
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Welcome text
          Text(
            'Welcome to Safiyah',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 16),
          
          Text(
            'Your comprehensive Islamic companion for daily life and travel. Discover halal places, prayer times, and connect with the Muslim community.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              height: 1.5,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          
          const Spacer(flex: 2),
        ],
      ),
    );
  }

  Widget _buildLocationPage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          const Spacer(flex: 1),
          
          // Location illustration
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.location_on,
              size: 80,
              color: Colors.blue,
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Location text
          Text(
            'Enable Location Services',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 16),
          
          Text(
            'Allow Safiyah to access your location to provide accurate prayer times, find nearby mosques, and discover halal restaurants around you.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              height: 1.5,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 32),
          
          // Permission button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                // Request location permission
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Location permission granted!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              icon: const Icon(Icons.location_on),
              label: const Text('Allow Location Access'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          
          const Spacer(flex: 2),
        ],
      ),
    );
  }

  Widget _buildCompletePage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          const Spacer(flex: 1),
          
          // Success illustration
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle,
              size: 80,
              color: Colors.green,
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Success text
          Text(
            'You\'re All Set!',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 16),
          
          Text(
            'Safiyah is now configured for your needs. Start exploring halal places, managing your prayer times, and planning your spiritual journey.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              height: 1.5,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          
          if (_accessibilityData.isNotEmpty && _accessibilityData['hasDisability'] == true) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.3),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.accessibility_new,
                    color: AppColors.primary,
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Accessibility Features Enabled',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Your accessibility preferences have been saved and will be applied throughout the app.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
          
          const Spacer(flex: 2),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
