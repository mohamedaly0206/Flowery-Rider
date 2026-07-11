import 'package:flowery_rider/config/di/di.dart';
import 'package:flowery_rider/core/shared_features/app_section/presentation/view_model/cubit/app_section_cubit.dart';
import 'package:flowery_rider/core/shared_features/app_section/presentation/view_model/intent/app_section_intent.dart';
import 'package:flowery_rider/core/shared_features/app_section/presentation/view_model/state/app_section_state.dart';
import 'package:flowery_rider/core/values/assets.gen.dart';
import 'package:flowery_rider/features/order_tracking/presentation/home/view_model/cubit/home_cubit.dart';
import 'package:flowery_rider/features/order_tracking/presentation/home/view_model/intent/home_intent.dart';
import 'package:flowery_rider/features/order_tracking/presentation/home/views/home_view.dart';
import 'package:flowery_rider/features/order_tracking/presentation/order_page/views/orders_view.dart';
import 'package:flowery_rider/features/profile/presentation/profile/views/profile_view.dart';
import 'package:flowery_rider/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class AppSectionView extends StatelessWidget {
  const AppSectionView({super.key});

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final selectedColor = theme.colorScheme.primary;
    final unselectedColor = theme.colorScheme.onSecondaryFixedVariant;

    return BlocBuilder<AppSectionCubit, AppSectionState>(
      builder: (context, state) {
        return Scaffold(
          body: IndexedStack(index: state.currentIndex, children: _sections),

          bottomNavigationBar: BottomNavigationBar(
            elevation: 0,
            backgroundColor: theme.colorScheme.onPrimary,
            selectedItemColor: selectedColor,
            unselectedItemColor: unselectedColor,
            currentIndex: state.currentIndex,
            onTap: (index) {
              context.read<AppSectionCubit>().appSectionHandleIntent(
                AppSectionIndexChangedIntent(index),
              );
            },
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  Assets.icons.home2Icon,
                  colorFilter: ColorFilter.mode(
                    unselectedColor,
                    BlendMode.srcIn,
                  ),
                ),
                activeIcon: SvgPicture.asset(
                  Assets.icons.home2Icon,
                  colorFilter: ColorFilter.mode(selectedColor, BlendMode.srcIn),
                ),
                label: appLocalization.home,
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  Assets.icons.factCheckIcon,
                  colorFilter: ColorFilter.mode(
                    unselectedColor,
                    BlendMode.srcIn,
                  ),
                ),
                activeIcon: SvgPicture.asset(
                  Assets.icons.factCheckIcon,
                  colorFilter: ColorFilter.mode(selectedColor, BlendMode.srcIn),
                ),
                label: appLocalization.orders,
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  Assets.icons.personIcon,
                  colorFilter: ColorFilter.mode(
                    unselectedColor,
                    BlendMode.srcIn,
                  ),
                ),
                activeIcon: SvgPicture.asset(
                  Assets.icons.personIcon,
                  colorFilter: ColorFilter.mode(selectedColor, BlendMode.srcIn),
                ),
                label: appLocalization.profile,
              ),
            ],
          ),
        );
      },
    );
  }
}

final List<Widget> _sections = [
  BlocProvider(
    create: (context) =>
        getIt<HomeCubit>()..handleHomeIntent(GetPendingOrdersIntent()),
    child: const HomeView(),
  ),
  const OrdersPageView(),
    const ProfileView(),
];



