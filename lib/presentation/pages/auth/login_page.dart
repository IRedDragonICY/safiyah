import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/strings.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated || state is AuthGuest) {
            context.go('/');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 60),
                  _buildHeader(context),
                  const SizedBox(height: 60),
                  _buildLoginForm(context),
                  const SizedBox(height: 24),
                  _buildSignInButton(context),
                  const SizedBox(height: 16),
                  _buildForgotPasswordButton(context),
                  const SizedBox(height: 32),
                  _buildDivider(context),
                  const SizedBox(height: 32),
                  _buildGuestButton(context),
                  const SizedBox(height: 24),
                  _buildSignUpButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: Image.asset('assets/icons/icon.png'),
        ),
        const SizedBox(height: 24),
        Text(
          AppStrings.appName,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          AppStrings.appTagline,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          controller: _emailController,
          hintText: AppStrings.email,
          labelText: AppStrings.email,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: const Icon(Icons.email_outlined),
          textCapitalization: TextCapitalization.none,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _passwordController,
          hintText: AppStrings.password,
          labelText: AppStrings.password,
          obscureText: _obscurePassword,
          prefixIcon: const Icon(Icons.lock_outlined),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSignInButton(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return CustomButton(
          text: AppStrings.signIn,
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              context.read<AuthBloc>().add(
                SignInRequested(
                  email: _emailController.text.trim(),
                  password: _passwordController.text,
                ),
              );
            }
          },
          isLoading: state is AuthLoading,
          icon: Icons.login,
        );
      },
    );
  }

  Widget _buildForgotPasswordButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        _showForgotPasswordDialog(context);
      },
      child: Text(
        AppStrings.forgotPassword,
        style: TextStyle(color: AppColors.primary),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'OR',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }

  Widget _buildGuestButton(BuildContext context) {
    return CustomButton(
      text: AppStrings.continueAsGuest,
      onPressed: () {
        context.read<AuthBloc>().add(const ContinueAsGuest());
      },
      isOutlined: true,
      icon: Icons.person_outline,
    );
  }

  Widget _buildSignUpButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppStrings.dontHaveAccount,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey[600],
          ),
        ),
        TextButton(
          onPressed: () => context.push('/auth/register'),
          child: Text(
            AppStrings.signUp,
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  void _showForgotPasswordDialog(BuildContext context) {
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reset Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Enter your email address to receive a password reset link.',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: emailController,
                hintText: 'Email address',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(Icons.email_outlined),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Password reset functionality will be implemented'),
                  ),
                );
              },
              child: const Text('Send Reset Link'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}