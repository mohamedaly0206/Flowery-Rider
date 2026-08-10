import 'dart:io';

abstract class EditProfileIntent {}

class UpdateProfileFieldsIntent extends EditProfileIntent {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String gender;

  UpdateProfileFieldsIntent({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.gender,
  });
}

class UploadProfileImageIntent extends EditProfileIntent {
  final File imageFile;

  UploadProfileImageIntent({required this.imageFile});
}
