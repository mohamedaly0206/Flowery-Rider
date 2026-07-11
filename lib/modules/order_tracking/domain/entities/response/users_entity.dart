import 'package:equatable/equatable.dart';

class UsersEntity extends Equatable {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? photo;

  const UsersEntity({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.photo,
  });

  String get displayName => '$firstName $lastName';

  @override
  List<Object?> get props => [id, firstName, lastName, email, phone, photo];
}
