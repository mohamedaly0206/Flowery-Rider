import 'package:flowery_rider/config/di/di.dart';
import 'package:flowery_rider/config/security_storage/security_storage.dart';
import 'package:flowery_rider/core/localization/app_locale_controller.dart';
import 'package:flowery_rider/core/router/app_router.dart';
import 'package:flowery_rider/core/router/router_paths.dart';
import 'package:flowery_rider/core/theme/theme.dart';
import 'package:flowery_rider/core/values/app_strings.dart';
import 'package:flowery_rider/l10n/app_localizations.dart';
import 'package:flowery_rider/features/order_tracking/domain/entities/response/order_entity.dart';
import 'package:flowery_rider/features/order_tracking/domain/use_cases/firestore_order_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();

  final firestoreOrderUseCase = getIt<FirestoreOrderUseCase>();
  final activeOrder = await firestoreOrderUseCase.getActiveOrder(
    '6a3c2826992612ae599b40ee',
  );

  runApp(MyApp(activeOrder: activeOrder));
}

class MyApp extends StatelessWidget {
  final OrderEntity? activeOrder;
  const MyApp({super.key, this.activeOrder});

  @override
  Widget build(BuildContext context) {
    return AppLocaleScope(
      initialLocale: const Locale('en'),
      builder: (locale) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Flowery Rider',
          locale: locale,
          theme: AppTheme.appTheme,
          routerConfig: AppRouter.getRouter(
            initialLocation: activeOrder != null
                ? AppRouterPaths.kOrderDetailsView
                : AppRouterPaths.kHomeView,
            initialOrder: activeOrder,
          ),

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
  final initialLocation = await _getInitialLocation();
  runApp(
    AppLocaleScope(
      initialLocale: const Locale('en'),
      builder: (locale) {
        return MyApp(locale: locale, initialLocation: initialLocation);
      },
    ),
  );
}

Future<String> _getInitialLocation() async {
  final securityStorage = getIt<SecurityStorage>();
  final token = await securityStorage.getSecuredString(AppStrings.token);
  if (token.isNotEmpty) {
    return AppRouterPaths.kAppSections;
  }
  return AppRouterPaths.kOnboardingView;
}

class MyApp extends StatelessWidget {
  final String initialLocation;
  final Locale locale;
  const MyApp({
    this.locale = const Locale('en'),
    this.initialLocation = AppRouterPaths.kOnboardingView,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter.getRouter(initialLocation: initialLocation),
      debugShowCheckedModeBanner: false,

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
  }
}
