import 'package:firebase_core/firebase_core.dart';
import 'package:flowery_rider/config/di/di.dart';
import 'package:flowery_rider/core/localization/app_locale_controller.dart';
import 'package:flowery_rider/core/theme/theme.dart';
import 'package:flowery_rider/firebase_options.dart';
import 'package:flowery_rider/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLocaleScope(
      initialLocale: const Locale('en'),
      builder: (locale) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flowery Rider',
          locale: locale,
          theme: AppTheme.appTheme,

          // Localization Delegates
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          supportedLocales: AppLocalizations.supportedLocales,
        );
      },
    );
  }
}
