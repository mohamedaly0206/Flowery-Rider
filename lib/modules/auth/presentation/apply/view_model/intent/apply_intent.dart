abstract class ApplyIntent {}

class SubmitApplyIntent extends ApplyIntent {}

class ChangeCountryIntent extends ApplyIntent {
  final String country;
  ChangeCountryIntent(this.country);
}

class ChangeVehicleTypeIntent extends ApplyIntent {
  final String type;
  ChangeVehicleTypeIntent(this.type);
}

class ChangeGenderIntent extends ApplyIntent {
  final String gender;
  ChangeGenderIntent(this.gender);
}

class PickImageIntent extends ApplyIntent {
  final bool isLicense;
  PickImageIntent({required this.isLicense});
}
