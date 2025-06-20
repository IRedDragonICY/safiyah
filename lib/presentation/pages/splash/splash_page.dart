import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:safiyah/presentation/bloc/onboarding/onboarding_bloc.dart';
import 'package:safiyah/presentation/bloc/onboarding/onboarding_state.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/strings.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _backgroundController;
  late AnimationController _pulseController;
  late Animation<double> _logoAnimation;
  late Animation<double> _textAnimation;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _logoAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    ));

    _textAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.3, 0.8, curve: Curves.easeOutCubic),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.5, 1.0, curve: Curves.easeOutBack),
    ));

    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _startAnimations();
  }

  void _startAnimations() async {
    _backgroundController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    _mainController.forward();
    
    // Pulse animation
    _pulseController.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return MultiBlocListener(
      listeners: [
        BlocListener<OnboardingBloc, OnboardingState>(
          listener: (context, state) async {
            await Future.delayed(const Duration(milliseconds: 3500));
            if (mounted) {
              if (state is OnboardingInProgress) {
                context.go('/onboarding');
              } else if (state is OnboardingCompleted) {
                context.read<AuthBloc>().add(const CheckAuthStatus());
              }
            }
          },
        ),
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated || state is AuthGuest) {
              context.go('/');
            } else if (state is AuthUnauthenticated) {
              context.go('/auth/login');
            }
          },
        ),
      ],
      child: Scaffold(
        body: AnimatedBuilder(
          animation: _backgroundAnimation,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.9 * _backgroundAnimation.value),
                    AppColors.primaryLight.withValues(alpha: 0.8 * _backgroundAnimation.value),
                    AppColors.secondary.withValues(alpha: 0.7 * _backgroundAnimation.value),
                  ],
                  stops: const [0.0, 0.6, 1.0],
                ),
              ),
              child: Stack(
                children: [
                  _buildBackgroundElements(),
                  _buildContent(context, colorScheme, theme),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBackgroundElements() {
    return AnimatedBuilder(
      animation: _backgroundAnimation,
      builder: (context, child) {
        return Positioned.fill(
          child: Opacity(
            opacity: _backgroundAnimation.value * 0.1,
            child: CustomPaint(
              painter: IslamicPatternPainter(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, ColorScheme colorScheme, ThemeData theme) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(),
            Column(
              children: [
                _buildLogo(),
                const SizedBox(height: 24),
                _buildAppName(theme),
                const SizedBox(height: 8),
                _buildTagline(theme),
              ],
            ),
            const Spacer(),
            _buildLoadingSection(theme),
            const Spacer(),
            SlideTransition(
              position: _slideAnimation,
              child: _buildCompanyLogos(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return AnimatedBuilder(
      animation: Listenable.merge([_logoAnimation, _pulseAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _logoAnimation.value * _pulseAnimation.value,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Color(0xFFF8F9FA),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 22,
                  offset: const Offset(0, 12),
                  spreadRadius: -4,
                ),
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.7),
                  blurRadius: 12,
                  offset: const Offset(-4, -4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Image.asset(
                'assets/icons/icon.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppName(ThemeData theme) {
    return AnimatedBuilder(
      animation: _textAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - _textAnimation.value)),
          child: Opacity(
            opacity: _textAnimation.value,
            child: Text(
              AppStrings.appName,
              style: theme.textTheme.headlineLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    offset: const Offset(0, 3),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTagline(ThemeData theme) {
    return AnimatedBuilder(
      animation: _textAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - _textAnimation.value)),
          child: Opacity(
            opacity: _textAnimation.value * 0.9,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Text(
                AppStrings.appTagline,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingSection(ThemeData theme) {
    return AnimatedBuilder(
      animation: _textAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _textAnimation.value,
          child: Column(
            children: [
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'v1.0.0',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCompanyLogos(BuildContext context) {
    return Column(
      children: [
        Text(
          'Powered by',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.8),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logos/uad-logo.png',
              height: 32,
              width: 80,
              fit: BoxFit.contain,
            ),
            Container(
              width: 1,
              height: 32,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              color: Colors.white.withValues(alpha: 0.4),
            ),
            Image.asset(
              'assets/logos/mtqmn-logo.png',
              height: 32,
              width: 80,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _mainController.dispose();
    _backgroundController.dispose();
    _pulseController.dispose();
    super.dispose();
  }
}

class IslamicPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path = Path();
    final spacing = size.width / 8;
    
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 12; j++) {
        final x = i * spacing;
        final y = j * spacing;
        
        // Draw geometric pattern
        path.moveTo(x, y);
        path.lineTo(x + spacing / 2, y + spacing / 4);
        path.lineTo(x + spacing, y);
        path.lineTo(x + spacing * 0.75, y + spacing / 2);
        path.lineTo(x + spacing, y + spacing);
        path.lineTo(x + spacing / 2, y + spacing * 0.75);
        path.lineTo(x, y + spacing);
        path.lineTo(x + spacing / 4, y + spacing / 2);
        path.close();
      }
    }
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
