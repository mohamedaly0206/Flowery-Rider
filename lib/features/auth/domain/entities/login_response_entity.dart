import 'package:equatable/equatable.dart';

class LoginResponseEntity extends Equatable {
  final String? message;
  final String token;

  const LoginResponseEntity({required this.token, this.message});

  @override
  List<Object?> get props => [token, message];
}
