import 'package:flowery_rider/core/router/router_paths.dart';
import 'package:flowery_rider/core/values/app_strings.dart';
import 'package:flowery_rider/core/values/assets.gen.dart';
import 'package:flowery_rider/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(right: 60),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: 2.6,
                    child: Lottie.asset(
                      Assets.animations.onboardingAnimation,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                appLocalization.welcomeOnboardingMessage,
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                GoRouter.of(context).push(AppRouterPaths.kLoginView);
              },
              child: Text(appLocalization.login),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom().copyWith(
                backgroundColor: WidgetStateProperty.all(
                  theme.colorScheme.onSecondary,
                ),
                foregroundColor: WidgetStateProperty.all(
                  theme.colorScheme.onInverseSurface,
                ),
                side: WidgetStateProperty.all(
                  BorderSide(color: theme.colorScheme.onInverseSurface),
                ),
              ),
              onPressed: () {
                // GoRouter.of(context).push(AppRouterPaths.kSignUpView);
              },
              child: Text(appLocalization.applyNow),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Center(
                child: Text(
                  AppStrings.appVersion,
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
