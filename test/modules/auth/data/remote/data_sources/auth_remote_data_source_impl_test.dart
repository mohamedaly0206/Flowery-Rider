import 'package:flowery_rider/config/base_response/base_response.dart';
import 'package:flowery_rider/modules/auth/data/models/request/login_request.dart';
import 'package:flowery_rider/modules/auth/data/models/response/login_response_dto.dart';
import 'package:flowery_rider/modules/auth/data/models/response/logout_response_dto.dart';
import 'package:flowery_rider/modules/auth/data/remote/api_client/auth_api_client.dart';
import 'package:flowery_rider/modules/auth/data/remote/data_sources/auth_remote_data_source_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([AuthApiClient])
import 'auth_remote_data_source_impl_test.mocks.dart';

void main() {
  late AuthRemoteDataSourceImpl dataSource;
  late MockAuthApiClient mockApiClient;

  setUpAll(() {
    provideDummy<BaseResponse<LoginResponseDto>>(
      SuccessBaseResponse<LoginResponseDto>(data: LoginResponseDto()),
    );
    provideDummy<BaseResponse<LogOutResponseDto>>(
      SuccessBaseResponse<LogOutResponseDto>(data: LogOutResponseDto()),
    );
  });

  setUp(() {
    mockApiClient = MockAuthApiClient();
    dataSource = AuthRemoteDataSourceImpl(mockApiClient);
  });

  final tLoginRequest = LoginRequest(
    email: 'test@test.com',
    password: 'password123',
  );
  final tLoginResponseDto = LoginResponseDto(token: 'mock_token');
  final tLogoutResponseDto = LogOutResponseDto();

  group('login', () {
    test(
      'should return SuccessBaseResponse when API login call is successful',
      () async {
        // Arrange
        when(
          mockApiClient.login(body: anyNamed('body')),
        ).thenAnswer((_) async => tLoginResponseDto);

        // Act
        final result = await dataSource.login(
          body: tLoginRequest,
          isRememberMe: true,
        );

        // Assert
        expect(result, isA<SuccessBaseResponse<LoginResponseDto>>());
        expect((result as SuccessBaseResponse).data, equals(tLoginResponseDto));
        verify(mockApiClient.login(body: tLoginRequest)).called(1);
      },
    );

    test(
      'should return ErrorBaseResponse when API throws an exception',
      () async {
        // Arrange
        when(
          mockApiClient.login(body: anyNamed('body')),
        ).thenThrow(Exception('Server connection failed'));

        // Act
        final result = await dataSource.login(
          body: tLoginRequest,
          isRememberMe: false,
        );

        // Assert
        expect(result, isA<ErrorBaseResponse<LoginResponseDto>>());
        // Note: The specific error message depends on your ServerFailure.failureHandler logic
        verify(mockApiClient.login(body: tLoginRequest)).called(1);
      },
    );
  });

  group('logout', () {
    test(
      'should return SuccessBaseResponse when API logout call is successful',
      () async {
        // Arrange
        when(
          mockApiClient.logout(),
        ).thenAnswer((_) async => tLogoutResponseDto);

        // Act
        final result = await dataSource.logout();

        // Assert
        expect(result, isA<SuccessBaseResponse<LogOutResponseDto>>());
        expect(
          (result as SuccessBaseResponse).data,
          equals(tLogoutResponseDto),
        );
        verify(mockApiClient.logout()).called(1);
      },
    );

    test(
      'should return ErrorBaseResponse when logout API throws an exception',
      () async {
        // Arrange
        when(mockApiClient.logout()).thenThrow(Exception('Unauthorized'));

        // Act
        final result = await dataSource.logout();

        // Assert
        expect(result, isA<ErrorBaseResponse<LogOutResponseDto>>());
        verify(mockApiClient.logout()).called(1);
      },
    );
  });
}
