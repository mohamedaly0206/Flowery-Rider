import 'package:firebase_core/firebase_core.dart';
import 'package:flowery_rider/config/di/di.dart';
import 'package:flowery_rider/config/security_storage/security_storage.dart';
import 'package:flowery_rider/core/localization/app_locale_controller.dart';
import 'package:flowery_rider/core/router/app_router.dart';
import 'package:flowery_rider/core/router/router_paths.dart';
import 'package:flowery_rider/core/theme/theme.dart';
import 'package:flowery_rider/core/values/app_strings.dart';
import 'package:flowery_rider/firebase_options.dart';
import 'package:flowery_rider/l10n/app_localizations.dart';
import 'package:flowery_rider/features/order_tracking/domain/entities/response/order_entity.dart';
import 'package:flowery_rider/features/order_tracking/domain/use_cases/firestore_order_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  configureDependencies();

  final routingData = await _determineInitialRoute();

  runApp(
    AppLocaleScope(
      initialLocale: const Locale('en'),
      builder: (locale) {
        return MyApp(
          locale: locale,
          initialLocation: routingData.location,
          activeOrder: routingData.order,
        );
      },
    ),
  );
}

Future<({String location, OrderEntity? order})> _determineInitialRoute() async {
  // final securityStorage = getIt<SecurityStorage>();
  // final token = await securityStorage.getSecuredString(AppStrings.token);

  // if (token.isNotEmpty) {
  //   try {
  //     final firestoreOrderUseCase = getIt<FirestoreOrderUseCase>();
  //     final activeOrder = await firestoreOrderUseCase.getActiveOrder(
  //       '6a3c2826992612ae599b40ee',
  //     );

  //     if (activeOrder != null) {
  //       return (location: AppRouterPaths.kOrderDetailsView, order: activeOrder);
  //     }
  //   } catch (_) {}
  //   return (location: AppRouterPaths.kAppSections, order: null);
  // }

  return (location: AppRouterPaths.kOnboardingView, order: null);
}

class MyApp extends StatelessWidget {
  final String initialLocation;
  final OrderEntity? activeOrder;
  final Locale locale;

  const MyApp({
    super.key,
    required this.initialLocation,
    required this.locale,
    this.activeOrder,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flowery Rider',
      locale: locale,
      theme: AppTheme.appTheme,

      routerConfig: AppRouter.getRouter(
        initialLocation: initialLocation,
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
  }
}
