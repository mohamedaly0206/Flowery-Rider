import 'package:flowery_rider/core/router/router_paths.dart';
import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/theme/app_text_styles.dart';
import 'package:flowery_rider/core/values/assets.gen.dart';
import 'package:flowery_rider/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class ApplySuccessView extends StatelessWidget {
  const ApplySuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SvgPicture.asset(
              Assets.icons.vector,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 3),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        Assets.icons.checkCircle,
                        width: 140,
                        height: 140,
                      ),
                      const SizedBox(height: 32),
                      Text(
                        localizations.applicationSubmitted,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.textStyleSemiBold20.copyWith(
                          color: AppColors.blackColor,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 16),

                      Text(
                        localizations.applicationSubmittedMessage,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.textStyleRegular14.copyWith(
                          color: AppColors.greyColor.withValues(alpha: 0.8),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 40),

                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            GoRouter.of(
                              context,
                            ).push(AppRouterPaths.kLoginView);
                          },

                          child: Text(
                            localizations.login,
                            style: AppTextStyles.textStyleMedium16.copyWith(
                              color: AppColors.whiteColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(flex: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
