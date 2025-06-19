import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'presentation/bloc/auth/auth_bloc.dart';
import 'presentation/bloc/auth/auth_state.dart';
import 'presentation/bloc/settings/settings_bloc.dart';
import 'presentation/bloc/settings/settings_state.dart';
import 'presentation/theme/app_theme.dart';
import 'routes/app_router.dart';
import 'core/constants/colors.dart';

class SafiyahMaterialApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, settingsState) {
            return BlocBuilder<AuthBloc, AuthState>(
              builder: (context, authState) {
                Color seed = AppColors.primary;
                ColorScheme? lightDyn = lightDynamic;
                ColorScheme? darkDyn = darkDynamic;

                if (settingsState is SettingsLoaded) {
                  switch (settingsState.paletteName) {
                    case 'green':
                      seed = AppColors.primary;
                      lightDyn = null;
                      darkDyn = null;
                      break;
                    case 'orange':
                      seed = AppColors.secondary;
                      lightDyn = null;
                      darkDyn = null;
                      break;
                    case 'blue':
                      seed = Colors.blue;
                      lightDyn = null;
                      darkDyn = null;
                      break;
                    case 'device':
                    default:
                      // keep dynamic schemes if available else fallback to primary
                      seed = AppColors.primary;
                      break;
                  }
                }

                return MaterialApp.router(
                  title: 'Safiyah - Muslim Traveler',
                  debugShowCheckedModeBanner: false,
                  theme: AppTheme.lightTheme(dynamicScheme: lightDyn, seedColor: seed),
                  darkTheme: AppTheme.darkTheme(dynamicScheme: darkDyn, seedColor: seed),
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