import 'package:equatable/equatable.dart';

class ApplyResultEntity extends Equatable {
  final String message;

  const ApplyResultEntity({required this.message});

  @override
  List<Object?> get props => [message];
}
