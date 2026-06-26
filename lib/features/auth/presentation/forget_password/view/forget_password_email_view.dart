
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utilities/app_loading.dart';
import '../../../../../core/utilities/app_validators.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../data/models/request/enter_reset_email_request.dart';
import '../cubit/forget_password_cubit.dart';
import '../intent/forget_password_intent.dart';

class ForgetPasswordEmailView extends StatelessWidget {
  ForgetPasswordEmailView({super.key, required this.controller});
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final PageController controller;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.forgetPassword,
              style: theme.textTheme.titleMedium,
            ),
            SizedBox(height: 10),
            Text(
              AppLocalizations.of(context)!.enterEmail,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            SizedBox(height: 32),
            TextFormField(
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.email,
                hintText: AppLocalizations.of(context)!.enterYourEmail,
              ),
              validator: (value) => AppValidators.validateEmail(context, value),
              controller: emailController,
            ),
            SizedBox(height: 48),
            BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
              listener: (context, state) {
                AppLoading.toggle(context: context, isLoading: state.enterEmailState.isLoading);

                if (state.enterEmailState.data != null && !state.enterEmailState.isLoading) {
                  controller.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      final request = EnterResetEmailRequest(email: emailController.text);
                      context.read<ForgetPasswordCubit>().doIntent(EnterResetEmailIntent(request));
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.confirm),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
