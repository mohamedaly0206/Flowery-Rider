abstract class AppStrings {
  static const String appName = 'Flowery Rider';
  //auth
  static const String appVersion = 'v 6.3.0 - (446)';
  static const String login = 'Login';
  static const String welcomeOnboardingMessage =
      'Welcome to\n Flowery rider app';
  static const String noToken = 'noToken';
  static const String authorization = 'Authorization';
  static const String bearer = 'Bearer';
  static const String loginSuccessfully = 'Login Successfully';
  static const String email = 'Email';
  static const String emailKey = 'email';
  static const String token = 'token';
  static const String enterYourEmail = 'Enter your email';
  static const String enterThePhoneNumber = 'Enter phone Number';
  static const String password = 'Password';
  static const String passwordKey = 'password';
  static const String enterYourPassword = 'Enter your password';
  static const String rememberMe = 'Remember me';
  static const String forgetPassword = 'Forget Password';
  static const String doNotHaveAnAccount = 'Don\'t have an account? ';
  static const String applyNow = 'Apply now';
  static const String firstLegalName = 'First legal name';
  static const String enterFirstLegalName = 'Enter first legal name';
  static const String secondLegalName = 'Second legal name';
  static const String enterSecondLegalName = 'Enter Second legal name';
  static const String vehicleType = 'Vehicle type';
  static const String enterVehicleType = 'Enter vehicle type';
  static const String vehicleLicense = 'Vehicle license';
  static const String uploadLicense = 'Upload license photo';
  static const String idNumber = 'ID number';
  static const String enterIdNumber = 'Enter national ID number';
  static const String idImage = 'ID image';
  static const String uploadIdImage = 'Upload ID image';
  static const String enterPassword = 'Enter password';
  static const String confirmPassword = 'Confirm password';
  static const String phone = 'Phone Number';
  static const String enterPhoneNumber = 'Enter phone number';
  static const String gender = 'Gender';
  static const String female = 'Female';
  static const String continueButton = 'Continue';
  static const String male = 'Male';
  static const String applicationSubmitted =
      'Your application has been\n submitted!';
  static const String applicationSubmittedMessage =
      'Thank you for providing your application,\n we will review your application and will\n get back to you soon.';
  static const String signUpSuccessMessage = 'Sign up successfully';
  static const String changePasswordSuccess = 'Password changed successfully';
  static const String changePasswordError = 'Failed to change password';
  static const String enterEmail =
      'Please enter your email associated to\nyour account';
  static const String alreadyHaveAnAccount = 'Already have an account?';
  static const String confirm = 'Confirm';
  static const String resend = 'Resend';
  static const String didNotReceiveCode = 'Didn\'t receive code?';
  static const String emailVerification = 'Email verification';
  static const String invalidCode = 'Invalid code';
  static const String enterCode =
      'Please enter your code that send to your \n email address';
  static const String verifyButton = 'Didn\'t receive code? ';
  static const String resendButton = 'Resend';
  static const String resetPassword = 'Reset password';
  static const String editProfile = 'Edit profile';
  static const String updateProfile = 'Update';
  static const String resetPasswordHint =
      'Password must not be empty and must contain \n 6 characters with upper case letter and one \n number at least ';
  static const String newPassword = 'New Password';

  //home
  static const String floweryRider = 'Flowery rider';
  static const String flowerOrder = 'Flower order';
  static const String home = 'Home';
  static const String orders = 'Orders';
  static const String profile = 'Profile';
  //track order
  static const String trackOrder = 'Track order';
  static const String orderPlacedSuccessfully =
      'Your order placed successfully!';
  static const String estimatedArrival = 'Estimated arrival';
  static const String showMap = 'Show map';
  static const String orderDelivered = 'Order Delivered';
  static const String orderDetails = 'Order details';
  static const String myOrders = 'My orders';
  static const String active = 'Active';
  static const String completed = 'Completed';
  static const String notification = 'Notification';
  static const String orderId = 'orderId';
  static const String pending = 'pending';
  static const String accepted = 'accepted';
  //profile
  static const String language = 'Language';
  static const String aboutUs = 'About us';
  static const String changeLanguage = 'Change Language';
  static const String arabic = 'Arabic';
  static const String english = 'English';
  static const String confirmLogout = 'Confirm logout!!';
  static const String logout = 'Logout';
  static const String cancel = 'Cancel';
  static const String loading = 'Loading';

  //storage errors
  static const String storeCacheExceptionMessage =
      'failed to store data locally, please try again later';
  static const String getCacheExceptionMessage =
      'failed to get data locally, please try again later';
  static const String cacheStorageError = "Storage Error";

  //server failure messages
  static const String errorMessage =
      'Something went wrong, please try again later';
  static const String serverConnTimeout = 'Connection timeout with API server';
  static const String serverSendTimeout = 'Send timeout with API server';
  static const String serverRecTimeout = 'Receive timeout with API server';
  static const String serverCertError = 'Bad certificate with API server';
  static const String serverCancel = 'Request to API server was cancelled';
  static const String serverConnError = 'There is Connection Error';
  static const String serverNoInternet = 'No Internet Connection';
  static const String serverInvalidCreds = 'Invalid email or password';
  static const String serverNotFound =
      'Opps there was an error, please try again';
  static const String serverInternalError =
      'Internal server error, please try again later';
  static const String serverDefaultError =
      'Opps there was an error, please try again';

  // Validator Messages
  static const String emailRequired = 'Email is required';
  static const String emailNotValid = 'This Email is not valid';
  static const String passwordRequired = 'Password is required';
  static const String passwordLength = 'Password must be at least 8 characters';
  static const String passwordInvalid =
      'password must contain upper and lowercase, number and symbol';
  static const String passwordNotMatched = 'Password not matched';
  static const String fieldRequired = 'This field is required';
  static const String nameLength = 'length must be at least 3 characters long';
  static const String nameOnlyLetters = 'must contain letters only';
  static const String nameNoSpaces = 'cannot contain spaces';
  static const String phoneRequired = 'Phone number is required';
  static const String phoneInvalid = 'Invalid Egyptian phone number';
  static const String nationalIDInvalid = 'length must be 14 characters long';
  static const String nationalIDRequired = 'National ID is required';
  static const String vehicleNumberInvalid = 'length must be 6 characters long';
  static const String vehicleNumberRequired = 'Vehicle Number is required';
}
