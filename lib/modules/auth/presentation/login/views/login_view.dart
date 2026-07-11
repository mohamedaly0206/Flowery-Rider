import 'dart:async';

import 'package:flowery_rider/config/base_event/base_event.dart';
import 'package:flowery_rider/core/utilities/app_messages.dart';
import 'package:flowery_rider/core/utilities/app_validators.dart';
import 'package:flowery_rider/core/widgets/custom_app_bar.dart';
import 'package:flowery_rider/modules/auth/presentation/login/view_model/cubit/login_cubit.dart';
import 'package:flowery_rider/modules/auth/presentation/login/view_model/intent/login_intent.dart';
import 'package:flowery_rider/modules/auth/presentation/login/view_model/state/login_states.dart';
import 'package:flowery_rider/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  StreamSubscription<BaseEvent>? _subscription;

  @override
  void initState() {
    super.initState();

    final cubit = context.read<LoginCubit>();

    _subscription = cubit.eventStream.listen((event) {
      if (!mounted) return;

      if (event is NavigateEvent) {
        GoRouter.of(context).go(event.routeName);
      }

      if (event is DisplayError) {
        AppMessages.showError(context, message: event.message);
      }
      if (event is DisplaySuccess) {
        AppMessages.showSuccess(context, message: event.message);
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _emailController.dispose();
    _passwordController.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.login,
        hasBackButton: false,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Column(
              children: [
                TextFormField(
                  controller: _emailController,
                  validator: (value) =>
                      AppValidators.validateEmail(context, value),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.enterYourEmail,
                    labelText: AppLocalizations.of(context)!.email,
                  ),
                ),
                const SizedBox(height: 24),
                BlocBuilder<LoginCubit, LoginState>(
                  builder: (context, state) {
                    return TextFormField(
                      controller: _passwordController,
                      validator: (value) =>
                          AppValidators.validateEmptyTextFormField(
                            context,
                            value,
                          ),
                      obscureText: state.obscurePassword,
                      decoration: InputDecoration(
                        suffixIcon: InkWell(
                          onTap: () {
                            context.read<LoginCubit>().handleLoginIntent(
                              TogglePasswordVisibilityIntent(),
                            );
                          },
                          child: Icon(
                            color: theme.colorScheme.primary,
                            state.obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                        hintText: AppLocalizations.of(context)!.enterPassword,
                        labelText: AppLocalizations.of(context)!.password,
                      ),
                    );
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        BlocBuilder<LoginCubit, LoginState>(
                          builder: (context, state) {
                            return Checkbox(
                              value: state.rememberMe,
                              onChanged: (value) {
                                if (value != null) {
                                  context.read<LoginCubit>().handleLoginIntent(
                                    ToggleRememberMeIntent(value),
                                  );
                                }
                              },
                              checkColor: Theme.of(
                                context,
                              ).colorScheme.onPrimary,
                              side: BorderSide(
                                color: theme.colorScheme.onTertiaryFixed,
                                width: 2.0,
                              ),
                            );
                          },
                        ),
                        Text(
                          AppLocalizations.of(context)!.rememberMe,
                          style: theme.textTheme.headlineSmall,
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {},
                      child: Text(
                        AppLocalizations.of(context)!.forgetPassword,
                        style: theme.textTheme.bodySmall!.copyWith(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: BlocBuilder<LoginCubit, LoginState>(
                        builder: (context, state) {
                          return ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<LoginCubit>().handleLoginIntent(
                                  SubmitLoginIntent(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  ),
                                );
                              }
                            },
                            child: state.loginState.isLoading
                                ? SpinKitFadingCircle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.secondary,
                                    size: 20,
                                  )
                                : Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.continueButton,
                                  ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
