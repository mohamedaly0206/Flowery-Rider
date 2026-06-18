abstract class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'https://flower.elevateegy.com/api/v1';

  static const String driverBaseUrl =
      'https://flower.elevateegy.com/api/v1/drivers';

  //auth
  static const String login = '$driverBaseUrl/signin';
  static const String apply = '$driverBaseUrl/apply';
  static const String changePassword = '$driverBaseUrl/change-password';
  static const String uploadDriverProfilePhoto =
      'localhost:3001/api/v1/drivers/upload-photo';
  static const String getLoggedDriverData =
      'localhost:3001/api/v1/drivers/profile-data';
  static const String logout = '$driverBaseUrl/logout';
  static const String forgetPassword = '$driverBaseUrl/forgotPassword';
  static const String verifyResetCode = '$driverBaseUrl/verifyResetCode';
  static const String resetPassword = '$driverBaseUrl/resetPassword';
  static const String deleteAccount = '$driverBaseUrl/deleteMe';
  static const String editProfile = '$driverBaseUrl/editProfile';

  //vehicle
  static const String vehicle = '$baseUrl/vehicles';

  //order
  static const String getPendingOrders = '$baseUrl/orders/pending-orders';
  static const String getDriverOrders = '$baseUrl/orders/driver-orders';
  static const String updateOrderState = '$baseUrl/orders/state/';
  static const String startOrder = '$baseUrl/orders/start/';
}
