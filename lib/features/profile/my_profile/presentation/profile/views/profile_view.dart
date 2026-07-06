import 'dart:async';
import 'package:flowery_rider/config/base_event/base_event.dart';
import 'package:flowery_rider/config/di/di.dart';
import 'package:flowery_rider/core/router/router_paths.dart';
import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/theme/app_text_styles.dart';
import 'package:flowery_rider/core/utilities/app_messages.dart';
import 'package:flowery_rider/core/values/assets.gen.dart';
import 'package:flowery_rider/core/widgets/custom_app_bar.dart';
import 'package:flowery_rider/features/profile/my_profile/presentation/profile/view_model/cubit/profile_cubit.dart';
import 'package:flowery_rider/features/profile/my_profile/presentation/profile/view_model/intent/profile_intent.dart';
import 'package:flowery_rider/features/profile/my_profile/presentation/profile/view_model/state/profile_state.dart';
import 'package:flowery_rider/features/profile/my_profile/presentation/profile/widgets/custom_profile_empty_state.dart';
import 'package:flowery_rider/features/profile/my_profile/presentation/profile/widgets/profile_info_card.dart';
import 'package:flowery_rider/features/profile/my_profile/presentation/profile/widgets/profile_menu_tile.dart';
import 'package:flowery_rider/features/profile/my_profile/presentation/profile/widgets/profile_photo.dart';
import 'package:flowery_rider/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<ProfileCubit>()..handleIntent(LoadProfileIntent()),
      child: const ProfileBodyView(),
    );
  }
}

class ProfileBodyView extends StatefulWidget {
  const ProfileBodyView({super.key});

  @override
  State<ProfileBodyView> createState() => _ProfileBodyViewState();
}

class _ProfileBodyViewState extends State<ProfileBodyView> {
  late final StreamSubscription<BaseEvent> _eventSubscription;

  @override
  void initState() {
    super.initState();
    _eventSubscription = context.read<ProfileCubit>().eventStream.listen((
      event,
    ) {
      if (!mounted) return;

      if (event is DisplaySuccess) {
        AppMessages.showSuccess(context, message: event.message);
      } else if (event is DisplayError) {
        AppMessages.showError(context, message: event.message);
      } else if (event is NavigateEvent) {
        context.go(event.routeName);
      }
    });
  }

  @override
  void dispose() {
    _eventSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileCubit>();
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(
        title: localizations.profile,
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              SvgPicture.asset(Assets.icons.notification),
              Positioned(
                top: -10,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.errorColor,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '3',
                    style: AppTextStyles.textStyleRegular12.copyWith(
                      color: AppColors.whiteColor,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state.isLoading && state.data == null) {
            return Center(
              child: SpinKitFadingCircle(
                color: Theme.of(context).colorScheme.primary,
                size: 50,
              ),
            );
          }
          final driver = state.data;
          if (driver == null) {
            return CustomProfileEmptyState(
              onRetry: () => cubit.handleIntent(LoadProfileIntent()),
            );
          }
          return Stack(
            children: [
              RefreshIndicator(
                color: AppColors.primaryColor,
                onRefresh: () async {
                  cubit.handleIntent(LoadProfileIntent());
                },
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
                  children: [
                    ProfileInfoCard(
                      leading: ProfilePhoto(photoUrl: driver.photo),
                      title: driver.displayName,
                      subtitles: [driver.email, driver.phone],
                      onTap: () async {
                        final isUpdated = await context.push(
                          AppRouterPaths.kEditProfileView,
                          extra: driver,
                        );
                        if (isUpdated == true && context.mounted) {
                          context.read<ProfileCubit>().handleIntent(
                            LoadProfileIntent(),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    ProfileInfoCard(
                      title: localizations.vehicleinfo,
                      subtitles: [
                        driver.displayVehicleType,
                        driver.vehicleNumber,
                      ],
                      onTap: () {},
                    ),
                    const SizedBox(height: 24),
                    ProfileMenuTile(
                      icon: SvgPicture.asset(Assets.icons.translateIcon),
                      title: localizations.language,
                      trailingText: _languageName(state.languageCode),
                      onTap: () {},
                    ),
                    ProfileMenuTile(
                      icon: SvgPicture.asset(Assets.icons.logoutIcon),
                      title: localizations.logout,
                      trailing: SvgPicture.asset(Assets.icons.logoutIcon),
                    ),
                    const SizedBox(height: 180),
                    Center(
                      child: Text(
                        'v 6.3.0 - (446)',
                        style: AppTextStyles.textStyleRegular12.copyWith(
                          color: AppColors.greyColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (state.isLoading && state.data != null)
                Positioned.fill(
                  child: ColoredBox(
                    color: AppColors.loadingBackgroundColor,
                    child: Center(
                      child: SpinKitFadingCircle(
                        color: Theme.of(context).colorScheme.primary,
                        size: 50,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  String _languageName(String languageCode) {
    return languageCode == 'ar'
        ? AppLocalizations.of(context)!.arabic
        : AppLocalizations.of(context)!.english;
  }
}
