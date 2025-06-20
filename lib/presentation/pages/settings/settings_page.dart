import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:safiyah/data/models/user_model.dart';

import '../../../core/constants/colors.dart';
import '../../../routes/route_names.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/settings/settings_bloc.dart';
import '../../bloc/settings/settings_event.dart';
import '../../bloc/settings/settings_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state is! SettingsLoaded) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildAccessibilitySection(context, state.preferences),
              const SizedBox(height: 16),
              _buildAppearanceSection(context, state.preferences, state.paletteName),
              const SizedBox(height: 16),
              _buildPrayerSection(context, state.preferences),
              const SizedBox(height: 16),
              _buildNotificationsSection(context, state.preferences),
              const SizedBox(height: 16),
              _buildAccountSection(context),
              const SizedBox(height: 16),
              _buildAboutSection(context),
              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 12.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildAccessibilitySection(BuildContext context, UserPreferences prefs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, 'Accessibility'),
        Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              // Main accessibility toggle
              Container(
                decoration: BoxDecoration(
                  color: prefs.hasDisability 
                      ? AppColors.primary.withValues(alpha: 0.05)
                      : null,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: SwitchListTile(
                  secondary: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.accessibility_new,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                  title: Text(
                    'Accessibility Features',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: const Text('Enable accessibility support and AI assistance'),
                  value: prefs.hasDisability,
                  onChanged: (value) {
                    context.read<SettingsBloc>().add(
                      ToggleAccessibilityFeatures(enabled: value),
                    );
                  },
                ),
              ),
              
              // Visual impairment section
              if (prefs.hasDisability) ...[
                const Divider(height: 1),
                Container(
                  decoration: BoxDecoration(
                    color: prefs.isVisuallyImpaired 
                        ? Colors.blue.withValues(alpha: 0.05)
                        : null,
                  ),
                  child: SwitchListTile(
                    secondary: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.remove_red_eye,
                        color: Colors.blue,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      'Visual Impairment Support',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: const Text('Enable AI-powered visual assistance'),
                    value: prefs.isVisuallyImpaired,
                    onChanged: (value) {
                      context.read<SettingsBloc>().add(
                        ToggleVisualImpairment(enabled: value),
                      );
                    },
                  ),
                ),
                
                // AI features for visual impairment
                if (prefs.isVisuallyImpaired) ...[
                  _buildFeatureListTile(
                    context,
                    icon: Icons.visibility,
                    title: 'AI Eye Control',
                    subtitle: 'Control app with eye movements',
                    value: prefs.enableEyeControl,
                    iconColor: Colors.green,
                    onChanged: (value) {
                      context.read<SettingsBloc>().add(
                        ToggleEyeControl(enabled: value),
                      );
                    },
                  ),
                  _buildFeatureListTile(
                    context,
                    icon: Icons.record_voice_over,
                    title: 'Screen Reader',
                    subtitle: 'Voice descriptions for UI elements',
                    value: prefs.enableScreenReader,
                    iconColor: Colors.orange,
                    onChanged: (value) {
                      context.read<SettingsBloc>().add(
                        ToggleScreenReader(enabled: value),
                      );
                    },
                  ),
                  _buildFeatureListTile(
                    context,
                    icon: Icons.mic,
                    title: 'Voice Commands',
                    subtitle: 'Control app with voice',
                    value: prefs.enableVoiceCommands,
                    iconColor: Colors.purple,
                    onChanged: (value) {
                      context.read<SettingsBloc>().add(
                        ToggleVoiceCommands(enabled: value),
                      );
                    },
                  ),
                ],
                
                // Color blindness section
                const Divider(height: 1),
                Container(
                  decoration: BoxDecoration(
                    color: prefs.hasColorBlindness 
                        ? Colors.purple.withValues(alpha: 0.05)
                        : null,
                  ),
                  child: SwitchListTile(
                    secondary: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.purple.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.palette,
                        color: Colors.purple,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      'Color Blindness Support',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: const Text('Adjust colors for better visibility'),
                    value: prefs.hasColorBlindness,
                    onChanged: (value) {
                      context.read<SettingsBloc>().add(
                        ToggleColorBlindness(enabled: value),
                      );
                    },
                  ),
                ),
                
                // Color blindness options
                if (prefs.hasColorBlindness) ...[
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.purple.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.color_lens,
                        color: Colors.purple,
                        size: 20,
                      ),
                    ),
                    title: const Text('Color Blindness Type'),
                    subtitle: Text(_getColorBlindnessLabel(prefs.colorBlindnessType)),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => _showColorBlindnessDialog(context, prefs),
                  ),
                  _buildFeatureListTile(
                    context,
                    icon: Icons.contrast,
                    title: 'High Contrast',
                    subtitle: 'Enhance color contrast',
                    value: prefs.enableHighContrast,
                    iconColor: Colors.indigo,
                    onChanged: (value) {
                      context.read<SettingsBloc>().add(
                        ToggleHighContrast(enabled: value),
                      );
                    },
                  ),
                ],
                
                // Text size setting
                const Divider(height: 1),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.teal.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.text_fields,
                      color: Colors.teal,
                      size: 20,
                    ),
                  ),
                  title: const Text('Text Size'),
                  subtitle: Text('${(prefs.textScaleFactor * 100).round()}%'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _showTextScaleDialog(context, prefs),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureListTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Color iconColor,
    required Function(bool) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: value ? iconColor.withValues(alpha: 0.05) : null,
      ),
      child: SwitchListTile(
        secondary: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(subtitle),
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  String _getColorBlindnessLabel(String type) {
    switch (type) {
      case 'deuteranopia':
        return 'Deuteranopia (Green-blind)';
      case 'protanopia':
        return 'Protanopia (Red-blind)';
      case 'tritanopia':
        return 'Tritanopia (Blue-blind)';
      default:
        return 'None';
    }
  }

  void _showColorBlindnessDialog(BuildContext context, UserPreferences prefs) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Color Blindness Type'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildColorBlindnessOption(
                context,
                'none',
                'None',
                'No color vision deficiency',
                prefs.colorBlindnessType,
                Colors.grey,
              ),
              _buildColorBlindnessOption(
                context,
                'deuteranopia',
                'Deuteranopia',
                'Green color blindness',
                prefs.colorBlindnessType,
                Colors.green,
              ),
              _buildColorBlindnessOption(
                context,
                'protanopia',
                'Protanopia',
                'Red color blindness',
                prefs.colorBlindnessType,
                Colors.red,
              ),
              _buildColorBlindnessOption(
                context,
                'tritanopia',
                'Tritanopia',
                'Blue color blindness',
                prefs.colorBlindnessType,
                Colors.blue,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildColorBlindnessOption(
    BuildContext context,
    String value,
    String title,
    String subtitle,
    String currentValue,
    Color color,
  ) {
    return RadioListTile<String>(
      title: Text(title),
      subtitle: Text(subtitle),
      secondary: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
      value: value,
      groupValue: currentValue,
      onChanged: (selectedValue) {
        if (selectedValue != null) {
          context.read<SettingsBloc>().add(
            ChangeColorBlindnessType(type: selectedValue),
          );
          Navigator.of(context).pop();
        }
      },
    );
  }

  void _showTextScaleDialog(BuildContext context, UserPreferences prefs) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        double tempScale = prefs.textScaleFactor;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Text('Text Size'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Sample text at ${(tempScale * 100).round()}%',
                      style: TextStyle(fontSize: 16 * tempScale),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Adjust text size: ${(tempScale * 100).round()}%',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  Slider(
                    value: tempScale,
                    min: 0.8,
                    max: 2.0,
                    divisions: 12,
                    label: '${(tempScale * 100).round()}%',
                    onChanged: (value) {
                      setState(() {
                        tempScale = value;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    context.read<SettingsBloc>().add(
                      ChangeTextScale(scaleFactor: tempScale),
                    );
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Apply'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildAppearanceSection(BuildContext context, UserPreferences prefs, String paletteName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, 'Appearance'),
        Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.brightness_6,
                    color: Colors.amber,
                  ),
                ),
                title: const Text('Theme'),
                subtitle: Text(prefs.themeMode[0].toUpperCase() + prefs.themeMode.substring(1)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _showThemeDialog(context, prefs),
              ),
              const Divider(height: 1),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.palette,
                    color: AppColors.primary,
                  ),
                ),
                title: const Text('Color Palette'),
                subtitle: Text(_paletteLabel(paletteName)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _showPaletteDialog(context),
              ),
              const Divider(height: 1),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.language,
                    color: Colors.green,
                  ),
                ),
                title: const Text('Language'),
                subtitle: const Text('English'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _showLanguageDialog(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPrayerSection(BuildContext context, UserPreferences prefs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, 'Prayer Times'),
        Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.calculate,
                    color: Colors.blue,
                  ),
                ),
                title: const Text('Calculation Method'),
                subtitle: Text(prefs.calculationMethod),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
              const Divider(height: 1),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.teal.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.book,
                    color: Colors.teal,
                  ),
                ),
                title: const Text('Madhab'),
                subtitle: Text(prefs.madhab),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationsSection(BuildContext context, UserPreferences prefs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, 'Notifications'),
        Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              SwitchListTile(
                secondary: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.notifications_active,
                    color: Colors.orange,
                  ),
                ),
                title: const Text('Prayer Notifications'),
                subtitle: const Text('Get notified before prayer times'),
                value: prefs.enablePrayerNotifications,
                onChanged: (value) {},
              ),
              const Divider(height: 1),
              SwitchListTile(
                secondary: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.pin_drop,
                    color: Colors.red,
                  ),
                ),
                title: const Text('Nearby Place Alerts'),
                subtitle: const Text('Notifications for nearby mosques and halal places'),
                value: true,
                onChanged: (value) {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAccountSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, 'Account'),
        Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.indigo.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.indigo,
                  ),
                ),
                title: const Text('Edit Profile'),
                subtitle: const Text('Update your personal information'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
              const Divider(height: 1),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.purple.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.workspace_premium,
                    color: Colors.purple,
                  ),
                ),
                title: const Text('Subscription'),
                subtitle: const Text('Upgrade to Pro for premium features'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  context.go(RouteNames.subscription);
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.cyan.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.lock,
                    color: Colors.cyan,
                  ),
                ),
                title: const Text('Change Password'),
                subtitle: const Text('Update your account password'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
              const Divider(height: 1),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.logout,
                    color: AppColors.error,
                  ),
                ),
                title: Text(
                  'Sign Out',
                  style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w500),
                ),
                subtitle: const Text('Sign out of your account'),
                onTap: () {
                  _showSignOutDialog(context);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out of your account?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.error,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<AuthBloc>().add(const SignOutRequested());
                context.go(RouteNames.login);
              },
              child: const Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, 'About'),
        Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.info,
                    color: Colors.blue,
                  ),
                ),
                title: const Text('App Version'),
                subtitle: const Text('1.0.0'),
                onTap: () {},
              ),
              const Divider(height: 1),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                ),
                title: const Text('Rate This App'),
                subtitle: const Text('Help us improve by rating the app'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
              const Divider(height: 1),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.feedback,
                    color: Colors.green,
                  ),
                ),
                title: const Text('Send Feedback'),
                subtitle: const Text('Share your thoughts and suggestions'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
              const Divider(height: 1),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.policy,
                    color: Colors.grey,
                  ),
                ),
                title: const Text('Privacy Policy'),
                subtitle: const Text('Read our privacy policy'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showThemeDialog(BuildContext context, UserPreferences prefs) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Choose Theme'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: const Text('System Default'),
                subtitle: const Text('Follow device theme'),
                secondary: const Icon(Icons.phone_android),
                value: 'system',
                groupValue: prefs.themeMode,
                onChanged: (value) {
                  if (value != null) {
                    context.read<SettingsBloc>().add(ChangeTheme(themeMode: ThemeMode.system));
                    Navigator.of(dialogContext).pop();
                  }
                },
              ),
              RadioListTile<String>(
                title: const Text('Light'),
                subtitle: const Text('Always use light theme'),
                secondary: const Icon(Icons.light_mode),
                value: 'light',
                groupValue: prefs.themeMode,
                onChanged: (value) {
                  if (value != null) {
                    context.read<SettingsBloc>().add(ChangeTheme(themeMode: ThemeMode.light));
                    Navigator.of(dialogContext).pop();
                  }
                },
              ),
              RadioListTile<String>(
                title: const Text('Dark'),
                subtitle: const Text('Always use dark theme'),
                secondary: const Icon(Icons.dark_mode),
                value: 'dark',
                groupValue: prefs.themeMode,
                onChanged: (value) {
                  if (value != null) {
                    context.read<SettingsBloc>().add(ChangeTheme(themeMode: ThemeMode.dark));
                    Navigator.of(dialogContext).pop();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String _paletteLabel(String name) {
    switch (name) {
      case 'device':
        return 'Follow Device';
      case 'green':
        return 'Safiyah Green';
      case 'orange':
        return 'Vibrant Orange';
      case 'blue':
        return 'Calming Blue';
      default:
        return name;
    }
  }

  void _showPaletteDialog(BuildContext context) {
    final settingsState = context.read<SettingsBloc>().state;
    if (settingsState is! SettingsLoaded) return;

    final current = settingsState.paletteName;

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (dialogContext) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Text(
              'Choose Color Palette',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            RadioListTile<String>(
              title: const Text('Follow Device'),
              subtitle: const Text('Use system accent color'),
              secondary: const Icon(Icons.phone_android),
              value: 'device',
              groupValue: current,
              onChanged: (value) {
                context.read<SettingsBloc>().add(const ChangePalette(paletteName: 'device'));
                Navigator.pop(dialogContext);
              },
            ),
            RadioListTile<String>(
              title: const Text('Safiyah Green'),
              subtitle: const Text('Classic Islamic green'),
              secondary: const Icon(Icons.circle, color: AppColors.primary),
              value: 'green',
              groupValue: current,
              onChanged: (value) {
                context.read<SettingsBloc>().add(const ChangePalette(paletteName: 'green'));
                Navigator.pop(dialogContext);
              },
            ),
            RadioListTile<String>(
              title: const Text('Vibrant Orange'),
              subtitle: const Text('Warm and energetic'),
              secondary: const Icon(Icons.circle, color: AppColors.secondary),
              value: 'orange',
              groupValue: current,
              onChanged: (value) {
                context.read<SettingsBloc>().add(const ChangePalette(paletteName: 'orange'));
                Navigator.pop(dialogContext);
              },
            ),
            RadioListTile<String>(
              title: const Text('Calming Blue'),
              subtitle: const Text('Peaceful and serene'),
              secondary: const Icon(Icons.circle, color: Colors.blue),
              value: 'blue',
              groupValue: current,
              onChanged: (value) {
                context.read<SettingsBloc>().add(const ChangePalette(paletteName: 'blue'));
                Navigator.pop(dialogContext);
              },
            ),
            const SizedBox(height: 32),
          ],
        );
      },
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (dialogContext) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Text(
              'Choose Language',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            RadioListTile<String>(
              title: const Text('English'),
              subtitle: const Text('English (US)'),
              secondary: const Text('🇺🇸', style: TextStyle(fontSize: 24)),
              value: 'en',
              groupValue: 'en',
              onChanged: (_) {
                Navigator.pop(dialogContext);
              },
            ),
            RadioListTile<String>(
              title: const Text('Bahasa Indonesia'),
              subtitle: const Text('Indonesian'),
              secondary: const Text('🇮🇩', style: TextStyle(fontSize: 24)),
              value: 'id',
              groupValue: 'en',
              onChanged: (_) {
                Navigator.pop(dialogContext);
              },
            ),
            RadioListTile<String>(
              title: const Text('العربية'),
              subtitle: const Text('Arabic'),
              secondary: const Text('🇸🇦', style: TextStyle(fontSize: 24)),
              value: 'ar',
              groupValue: 'en',
              onChanged: (_) {
                Navigator.pop(dialogContext);
              },
            ),
            const SizedBox(height: 32),
          ],
        );
      },
    );
  }
}
