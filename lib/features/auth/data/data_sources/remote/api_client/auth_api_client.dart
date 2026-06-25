import 'package:dio/dio.dart';
import 'package:flowery_rider/core/values/api_endpoints.dart';
import 'package:flowery_rider/core/values/app_strings.dart';
import 'package:flowery_rider/features/auth/data/models/response/apply_response_model.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_api_client.g.dart';

@injectable
@RestApi()
abstract class AuthApiClient {
  @factoryMethod
  factory AuthApiClient(Dio dio) = _AuthApiClient;
  @POST(ApiEndpoints.apply)
  @MultiPart()
  @Extra({AppStrings.noToken: true})
  Future<ApplyResponseModel> applyAsDriver(@Body() FormData formData);
}
