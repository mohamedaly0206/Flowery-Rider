import 'package:flowery_rider/features/profile/domain/entities/driver_profile_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'profile_response_model.g.dart';

@JsonSerializable()
class ProfileResponseModel {
  @JsonKey(name: 'message')
  final String? message;

  @JsonKey(name: 'driver')
  final DriverProfileModel? driver;

  const ProfileResponseModel({this.message, this.driver});

  factory ProfileResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileResponseModelToJson(this);
}

@JsonSerializable()
class DriverProfileModel {
  @JsonKey(name: '_id')
  final String? id;

  final String? country;
  final String? firstName;
  final String? lastName;
  final String? vehicleType;
  final String? vehicleNumber;
  final String? vehicleLicense;

  @JsonKey(name: 'NID')
  final String? nid;

  @JsonKey(name: 'NIDImg')
  final String? nidImg;

  final String? email;
  final String? gender;
  final String? phone;
  final String? photo;
  final String? role;
  final DateTime? createdAt;

  const DriverProfileModel({
    this.id,
    this.country,
    this.firstName,
    this.lastName,
    this.vehicleType,
    this.vehicleNumber,
    this.vehicleLicense,
    this.nid,
    this.nidImg,
    this.email,
    this.gender,
    this.phone,
    this.photo,
    this.role,
    this.createdAt,
  });

  factory DriverProfileModel.fromJson(Map<String, dynamic> json) =>
      _$DriverProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$DriverProfileModelToJson(this);

  DriverProfileEntity toEntity() => DriverProfileEntity(
    id: id ?? '',
    country: country ?? '',
    firstName: firstName ?? '',
    lastName: lastName ?? '',
    vehicleType: vehicleType ?? '',
    vehicleNumber: vehicleNumber ?? '',
    vehicleLicense: vehicleLicense ?? '',
    nid: nid ?? '',
    nidImg: nidImg ?? '',
    email: email ?? '',
    gender: gender ?? '',
    phone: phone ?? '',
    photo: photo ?? '',
    role: role ?? '',
    createdAt: createdAt,
  );
}
