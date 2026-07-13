abstract class ProfileIntent {}

class LoadProfileIntent extends ProfileIntent {}

class LogoutProfileIntent extends ProfileIntent {}

class ChangeLanguageIntent extends ProfileIntent {
  final String languageCode;

  ChangeLanguageIntent(this.languageCode);
}
