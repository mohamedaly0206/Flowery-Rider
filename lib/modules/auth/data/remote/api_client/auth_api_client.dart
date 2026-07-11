import 'package:dio/dio.dart';
import 'package:flowery_rider/core/values/api_endpoints.dart';
import 'package:flowery_rider/core/values/app_strings.dart';
import 'package:flowery_rider/modules/auth/data/models/request/login_request.dart';
import 'package:flowery_rider/modules/auth/data/models/response/apply_response_model.dart';
import 'package:flowery_rider/modules/auth/data/models/response/login_response_dto.dart';
import 'package:flowery_rider/modules/auth/data/models/response/logout_response_dto.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_api_client.g.dart';

@lazySingleton
@RestApi()
abstract class AuthApiClient {
  @factoryMethod
  factory AuthApiClient(Dio dio) = _AuthApiClient;
  @POST(ApiEndpoints.login)
  Future<LoginResponseDto> login({@Body() required LoginRequest body});
  @GET(ApiEndpoints.logout)
  Future<LogOutResponseDto> logout();
  @POST(ApiEndpoints.apply)
  @MultiPart()
  @Extra({AppStrings.noToken: true})
  Future<ApplyResponseModel> applyAsDriver(@Body() FormData formData);
}
