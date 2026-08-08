import 'dart:io';

abstract class EditProfileIntent {}

class UpdateProfileFieldsIntent extends EditProfileIntent {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String gender;
  final File? imageFile;

  UpdateProfileFieldsIntent({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.gender,
    required this.imageFile,
  });
}
