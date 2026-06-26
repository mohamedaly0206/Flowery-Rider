import 'dart:async';
import 'package:flowery_rider/features/auth/presentation/forget_password/view/reset_password_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../config/base_event/base_event.dart';
import '../../../../../core/utilities/app_messages.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../l10n/app_localizations.dart';
import '../cubit/forget_password_cubit.dart';
import 'email_verification_view.dart';
import 'forget_password_email_view.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final PageController pageController = PageController();
  StreamSubscription? _eventSubscription;

  @override
  void initState() {
    super.initState();
    _eventSubscription = context.read<ForgetPasswordCubit>().eventStream.listen((event) {
      if (event is DisplaySuccess) {
        AppMessages.showSuccess(context, message: event.message);
      } else if (event is DisplayError) {
        AppMessages.showError(context, message: event.message);
      } else if (event is NavigateEvent) {
        GoRouter.of(context).go(event.routeName);
      }
    });
  }

  @override
  void dispose() {
    _eventSubscription?.cancel();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppLocalizations.of(context)!.password),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: PageView(
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            ForgetPasswordEmailView(controller: pageController),
            EmailVerificationView(controller: pageController),
            ResetPasswordView(),
          ],
        ),
      ),
    );
  }
}