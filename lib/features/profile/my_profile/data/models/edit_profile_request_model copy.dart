class EditProfileRequestModel {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;

  EditProfileRequestModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
    };
  }
}
