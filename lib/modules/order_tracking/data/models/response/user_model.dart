import 'package:flowery_rider/modules/order_tracking/domain/entities/response/users_entity.dart';
import 'package:json_annotation/json_annotation.dart';
part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  @JsonKey(name: '_id')
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? photo;

  const UserModel({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.photo,
  });
  UsersEntity toEntity() => UsersEntity(
    id: id,
    firstName: firstName,
    lastName: lastName,
    email: email,
    phone: phone,
    photo: photo,
  );
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
