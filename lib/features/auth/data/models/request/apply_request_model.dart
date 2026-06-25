import 'dart:io';
import 'package:dio/dio.dart';

class ApplyRequestModel {
  final String country;
  final String firstName;
  final String lastName;
  final String vehicleType;
  final String vehicleNumber;
  final File vehicleLicense;
  final String nid;
  final File nidImg;
  final String email;
  final String password;
  final String rePassword;
  final String gender;
  final String phone;

  const ApplyRequestModel({
    required this.country,
    required this.firstName,
    required this.lastName,
    required this.vehicleType,
    required this.vehicleNumber,
    required this.vehicleLicense,
    required this.nid,
    required this.nidImg,
    required this.email,
    required this.password,
    required this.rePassword,
    required this.gender,
    required this.phone,
  });

  Future<FormData> toFormData() async {
    String mappedVehicleType = vehicleType;
    if (vehicleType.length == 24) {
      mappedVehicleType = vehicleType;
    } else if (vehicleType.toLowerCase() == 'motorcycle' ||
        vehicleType.toLowerCase() == 'bike') {
      mappedVehicleType = '676b31a45d05310ca82657ac';
    } else if (vehicleType.toLowerCase() == 'car') {
      mappedVehicleType = '676b31a45d05310ca82657ac';
    }

    return FormData.fromMap({
      'country': country,
      'firstName': firstName,
      'lastName': lastName,
      'vehicleType': mappedVehicleType,
      'vehicleNumber': vehicleNumber,
      'NID': nid,
      'email': email,
      'password': password,
      'rePassword': rePassword,
      'gender': gender,
      'phone': phone,
      'vehicleLicense': await MultipartFile.fromFile(
        vehicleLicense.path,
        filename: _fileName(vehicleLicense),
      ),
      'NIDImg': await MultipartFile.fromFile(
        nidImg.path,
        filename: _fileName(nidImg),
      ),
    });
  }

  String _fileName(File file) => file.uri.pathSegments.last;
}
