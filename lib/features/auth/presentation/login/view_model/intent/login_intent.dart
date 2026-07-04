sealed class LoginIntent {}

class TogglePasswordVisibilityIntent extends LoginIntent {}

class ToggleRememberMeIntent extends LoginIntent {
  final bool? value;

  ToggleRememberMeIntent(this.value);
}

class SubmitLoginIntent extends LoginIntent {
  final String email;
  final String password;

  SubmitLoginIntent({required this.email, required this.password});
}
