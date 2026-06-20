import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/values/api_endpoints.dart';
import '../../data/models/request/enter_reset_email_request.dart';
import '../../data/models/request/reset_password_request.dart';
import '../../data/models/request/verify_reset_code_request.dart';
import '../../data/models/response/enter_reset_email_dto.dart';
import '../../data/models/response/reset_password_dto.dart';
import '../../data/models/response/verify_reset_code_dto.dart';
part 'auth_api_client.g.dart';

@lazySingleton
@RestApi()
abstract class AuthApiClient {
  @factoryMethod
  factory AuthApiClient(Dio dio) = _AuthApiClient;

  @Extra({"noToken": true})
  @POST(ApiEndpoints.forgetPassword)
  Future<EnterResetEmailDTO> enterResetEmail(
      @Body() EnterResetEmailRequest request,
      );

  @POST(ApiEndpoints.verifyResetCode)
  Future<VerifyResetCodeDTO> verifyResetCode(
      @Body() VerifyResetCodeRequest request,
      );

  @PUT(ApiEndpoints.resetPassword)
  Future<ResetPasswordDTO> resetPassword(
      @Body() ResetPasswordRequest request,
      );

}