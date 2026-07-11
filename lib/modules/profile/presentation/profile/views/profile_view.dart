import 'dart:async';
import 'package:flowery_rider/config/base_event/base_event.dart';
import 'package:flowery_rider/config/di/di.dart';
import 'package:flowery_rider/core/router/router_paths.dart';
import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/theme/app_text_styles.dart';
import 'package:flowery_rider/core/utilities/app_messages.dart';
import 'package:flowery_rider/core/values/assets.gen.dart';
import 'package:flowery_rider/core/widgets/custom_app_bar.dart';
import 'package:flowery_rider/modules/auth/presentation/logout/view_model/cubit/logout_cubit.dart';
import 'package:flowery_rider/modules/auth/presentation/logout/view_model/state/logout_state.dart';
import 'package:flowery_rider/modules/auth/presentation/logout/view_model/intent/logout_intent.dart';
import 'package:flowery_rider/modules/profile/presentation/profile/view_model/cubit/profile_cubit.dart';
import 'package:flowery_rider/modules/profile/presentation/profile/view_model/intent/profile_intent.dart';
import 'package:flowery_rider/modules/profile/presentation/profile/view_model/state/profile_state.dart';
import 'package:flowery_rider/modules/profile/presentation/profile/widgets/custom_profile_empty_state.dart';
import 'package:flowery_rider/modules/profile/presentation/profile/widgets/profile_info_card.dart';
import 'package:flowery_rider/modules/profile/presentation/profile/widgets/profile_menu_tile.dart';
import 'package:flowery_rider/modules/profile/presentation/profile/widgets/profile_photo.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              getIt<ProfileCubit>()..handleIntent(LoadProfileIntent()),
        ),
        BlocProvider(create: (context) => getIt<LogoutCubit>()),
      ],
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
  late final StreamSubscription<BaseEvent> _profileEventSubscription;
  late final StreamSubscription<BaseEvent> _logoutEventSubscription;

  @override
  void initState() {
    super.initState();

    _profileEventSubscription = context.read<ProfileCubit>().eventStream.listen(
      (event) {
        if (!mounted) return;
        _handleBaseEvents(event);
      },
    );

    _logoutEventSubscription = context.read<LogoutCubit>().eventStream.listen((
      event,
    ) {
      if (!mounted) return;
      _handleBaseEvents(event);
    });
  }

  void _handleBaseEvents(BaseEvent event) {
    if (event is DisplaySuccess) {
      AppMessages.showSuccess(context, message: event.message);
    } else if (event is DisplayError) {
      AppMessages.showError(context, message: event.message);
    } else if (event is NavigateEvent) {
      context.go(event.routeName);
    }
  }

  @override
  void dispose() {
    _profileEventSubscription.cancel();
    _logoutEventSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileCubit = context.read<ProfileCubit>();
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(
        title: localizations.profile,
        hasBackButton: false,
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
        builder: (context, profileState) {
          final driver = profileState.data;
          if (driver == null) {
            return CustomProfileEmptyState(
              onRetry: () => profileCubit.handleIntent(LoadProfileIntent()),
            );
          }
          return Stack(
            children: [
              RefreshIndicator(
                color: AppColors.primaryColor,
                backgroundColor: AppColors.whiteColor,
                onRefresh: () async {
                  profileCubit.handleIntent(LoadProfileIntent());
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
                      trailingText: _languageName(profileState.languageCode),
                      onTap: () {},
                    ),

                    BlocBuilder<LogoutCubit, LogoutState>(
                      builder: (context, logoutState) {
                        final isLoading = logoutState.logoutState.isLoading;

                        return ProfileMenuTile(
                          icon: SvgPicture.asset(Assets.icons.logoutIcon),
                          title: localizations.logout,
                          trailing: isLoading
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.primaryColor,
                                  ),
                                )
                              : SvgPicture.asset(Assets.icons.logoutIcon),
                          onTap: isLoading
                              ? null
                              : () {
                                  context
                                      .read<LogoutCubit>()
                                      .handleLogoutIntent(GetLogoutIntent());
                                },
                        );
                      },
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
              if (profileState.isLoading && profileState.data != null)
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
