import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../security_storage/security_storage.dart';
import '../../core/errors/exceptions.dart';
import '../../core/values/app_strings.dart';

@injectable
class ApiInterceptor extends Interceptor {
  final SecurityStorage _securityStorage;

  ApiInterceptor(this._securityStorage);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra[AppStrings.noToken] == true) {
      return handler.next(options);
    }

    try {
      final String token =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkcml2ZXIiOiI2YTNjMjgyNjk5MjYxMmFlNTk5YjQwZWUiLCJpYXQiOjE3ODIzMjc0NjJ9.GNFqGhDftLo-S983EzPXTkXXcBMHhHmWymHKc2-K7Ds';

      if (token.isNotEmpty) {
        options.headers[AppStrings.authorization] =
            '${AppStrings.bearer} $token';
      }

      return handler.next(options);
    } catch (e) {
      return handler.reject(
        DioException(
          requestOptions: options,
          error: CacheException(errorMessage: 'cache_read_error'),
          type: DioExceptionType.unknown,
        ),
      );
    }
  }
}
