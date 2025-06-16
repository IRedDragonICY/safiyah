import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'presentation/bloc/auth/auth_bloc.dart';
import 'presentation/bloc/auth/auth_state.dart';
import 'presentation/bloc/settings/settings_bloc.dart';
import 'presentation/bloc/settings/settings_state.dart';
import 'presentation/theme/app_theme.dart';
import 'routes/app_router.dart';

class SafiyahMaterialApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, settingsState) {
            return BlocBuilder<AuthBloc, AuthState>(
              builder: (context, authState) {
                return MaterialApp.router(
                  title: 'Safiyah - Muslim Traveler',
                  debugShowCheckedModeBanner: false,
                  theme: AppTheme.lightTheme(lightDynamic),
                  darkTheme: AppTheme.darkTheme(darkDynamic),
                  themeMode: settingsState is SettingsLoaded ? settingsState.themeMode : ThemeMode.system,
                  routerConfig: AppRouter.router,
                );
              },
            );
          },
        );
      },
    );
  }
}