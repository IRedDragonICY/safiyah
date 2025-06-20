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
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state is! SettingsLoaded) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildAppearanceSection(context, state.preferences, state.paletteName),
              _buildPrayerSection(context, state.preferences),
              _buildNotificationsSection(context, state.preferences),
              _buildAccountSection(context),
              _buildAboutSection(context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, top: 16.0, bottom: 8.0),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildAppearanceSection(BuildContext context, UserPreferences prefs, String paletteName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, 'Appearance'),
        Card(
          elevation: 2,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.brightness_6),
                title: const Text('Theme'),
                subtitle: Text(prefs.themeMode[0].toUpperCase() + prefs.themeMode.substring(1)),
                onTap: () => _showThemeDialog(context, prefs),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.palette),
                title: const Text('Color Palette'),
                subtitle: Text(_paletteLabel(paletteName)),
                onTap: () => _showPaletteDialog(context),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Language'),
                subtitle: const Text('English'),
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
          elevation: 2,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.calculate),
                title: const Text('Calculation Method'),
                subtitle: Text(prefs.calculationMethod),
                onTap: () {},
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.book),
                title: const Text('Madhab'),
                subtitle: Text(prefs.madhab),
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
          elevation: 2,
          child: Column(
            children: [
              SwitchListTile(
                secondary: const Icon(Icons.notifications_active),
                title: const Text('Prayer Notifications'),
                value: prefs.enablePrayerNotifications,
                onChanged: (value) {},
              ),
              const Divider(height: 1),
              SwitchListTile(
                secondary: const Icon(Icons.pin_drop),
                title: const Text('Nearby Place Alerts'),
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
          elevation: 2,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Edit Profile'),
                onTap: () {},
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.workspace_premium),
                title: const Text('Subscription'),
                subtitle: const Text('Upgrade to Pro for premium features'),
                onTap: () {
                  context.go(RouteNames.subscription);
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.lock),
                title: const Text('Change Password'),
                onTap: () {},
              ),
              const Divider(height: 1),
              ListTile(
                leading: Icon(Icons.logout, color: AppColors.error),
                title: Text('Sign Out', style: TextStyle(color: AppColors.error)),
                onTap: () {
                  context.read<AuthBloc>().add(const SignOutRequested());
                  context.go(RouteNames.login);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, 'About'),
        Card(
          elevation: 2,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('App Version'),
                subtitle: const Text('1.0.0'),
                onTap: () {},
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.star),
                title: const Text('Rate This App'),
                onTap: () {},
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.feedback),
                title: const Text('Send Feedback'),
                onTap: () {},
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.policy),
                title: const Text('Privacy Policy'),
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
          title: const Text('Choose Theme'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: const Text('System Default'),
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
      builder: (dialogContext) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Text(
              'Choose Color Palette',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            RadioListTile<String>(
              title: const Text('Follow Device'),
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
              secondary: const Icon(Icons.circle, color: Colors.blue),
              value: 'blue',
              groupValue: current,
              onChanged: (value) {
                context.read<SettingsBloc>().add(const ChangePalette(paletteName: 'blue'));
                Navigator.pop(dialogContext);
              },
            ),
            const SizedBox(height: 12),
          ],
        );
      },
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (dialogContext) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Text(
              'Choose Language',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            RadioListTile<String>(
              title: const Text('English'),
              value: 'en',
              groupValue: 'en',
              onChanged: (_) {
                Navigator.pop(dialogContext);
              },
            ),
            RadioListTile<String>(
              title: const Text('Bahasa Indonesia'),
              value: 'id',
              groupValue: 'en',
              onChanged: (_) {
                Navigator.pop(dialogContext);
              },
            ),
            const SizedBox(height: 12),
          ],
        );
      },
    );
  }
}
