import 'package:flowery_rider/config/base_response/base_response.dart';
import 'package:flowery_rider/config/security_storage/security_storage.dart';
import 'package:flowery_rider/core/values/app_strings.dart';
import 'package:flowery_rider/modules/auth/data/models/request/login_request.dart';
import 'package:flowery_rider/modules/auth/data/models/response/login_response_dto.dart';
import 'package:flowery_rider/modules/auth/data/models/response/logout_response_dto.dart';
import 'package:flowery_rider/modules/auth/data/remote/data_sources/auth_remote_data_source_contract.dart';
import 'package:flowery_rider/modules/auth/data/repositories/auth_repo_impl.dart';
import 'package:flowery_rider/modules/auth/domain/entities/login_response_entity.dart';
import 'package:flowery_rider/modules/auth/domain/entities/logout_response_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
// Make sure to import your AuthRepoImpl file here

@GenerateMocks([AuthRemoteDataSourceContract, SecurityStorage])
import 'auth_repo_impl_test.mocks.dart';

void main() {
  late AuthRepoImpl repository;
  late MockAuthRemoteDataSourceContract mockRemoteDataSource;
  late MockSecurityStorage mockSecurityStorage;

  setUpAll(() {
    provideDummy<BaseResponse<LoginResponseDto>>(
      SuccessBaseResponse<LoginResponseDto>(data: LoginResponseDto()),
    );
    // Add this dummy provider for the logout response
    provideDummy<BaseResponse<LogOutResponseDto>>(
      SuccessBaseResponse<LogOutResponseDto>(data: LogOutResponseDto()),
    );
  });

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSourceContract();
    mockSecurityStorage = MockSecurityStorage();
    repository = AuthRepoImpl(mockRemoteDataSource, mockSecurityStorage);
  });

  final tLoginRequest = LoginRequest(email: 'rider@test.com', password: '123');
  const tToken = 'secure_rider_token';
  const tErrorMessage = 'Invalid credentials';

  final tLoginResponseDto = LoginResponseDto(token: tToken);
  final tLogoutResponseDto = LogOutResponseDto();

  group('login', () {
    test(
      'should return SuccessBaseResponse, map to Entity, and save token when isRememberMe is true',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.login(
            body: anyNamed('body'),
            isRememberMe: anyNamed('isRememberMe'),
          ),
        ).thenAnswer((_) async => SuccessBaseResponse(data: tLoginResponseDto));
        when(
          mockSecurityStorage.setSecuredString(any, any),
        ).thenAnswer((_) async {});

        // Act
        final result = await repository.login(
          body: tLoginRequest,
          isRememberMe: true,
        );

        // Assert
        expect(result, isA<SuccessBaseResponse<LoginResponseEntity>>());
        verify(
          mockRemoteDataSource.login(body: tLoginRequest, isRememberMe: true),
        ).called(1);
        verify(
          mockSecurityStorage.setSecuredString(AppStrings.token, tToken),
        ).called(1);
      },
    );

    test(
      'should return SuccessBaseResponse but NOT save token when isRememberMe is false',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.login(
            body: anyNamed('body'),
            isRememberMe: anyNamed('isRememberMe'),
          ),
        ).thenAnswer((_) async => SuccessBaseResponse(data: tLoginResponseDto));

        // Act
        final result = await repository.login(
          body: tLoginRequest,
          isRememberMe: false,
        );

        // Assert
        expect(result, isA<SuccessBaseResponse<LoginResponseEntity>>());
        verify(
          mockRemoteDataSource.login(body: tLoginRequest, isRememberMe: false),
        ).called(1);
        verifyNever(mockSecurityStorage.setSecuredString(any, any));
      },
    );

    test(
      'should pass through ErrorBaseResponse when remote data source fails',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.login(
            body: anyNamed('body'),
            isRememberMe: anyNamed('isRememberMe'),
          ),
        ).thenAnswer(
          (_) async => ErrorBaseResponse(errorMessage: tErrorMessage),
        );

        // Act
        final result = await repository.login(
          body: tLoginRequest,
          isRememberMe: true,
        );

        // Assert
        expect(result, isA<ErrorBaseResponse<LoginResponseEntity>>());
        expect(
          (result as ErrorBaseResponse).errorMessage,
          equals(tErrorMessage),
        );
        verifyNever(mockSecurityStorage.setSecuredString(any, any));
      },
    );
  });

  group('logout', () {
    test(
      'should return SuccessBaseResponse and delete token from storage if one exists',
      () async {
        // Arrange
        when(mockRemoteDataSource.logout()).thenAnswer(
          (_) async => SuccessBaseResponse(data: tLogoutResponseDto),
        );
        when(
          mockSecurityStorage.getSecuredString(AppStrings.token),
        ).thenAnswer((_) async => tToken);
        when(
          mockSecurityStorage.deleteSecuredString(any),
        ).thenAnswer((_) async {});

        // Act
        final result = await repository.logout();

        // Assert
        expect(result, isA<SuccessBaseResponse<LogoutResponseEntity>>());
        verify(
          mockSecurityStorage.getSecuredString(AppStrings.token),
        ).called(1);
        verify(
          mockSecurityStorage.deleteSecuredString(AppStrings.token),
        ).called(1);
      },
    );

    test(
      'should return ErrorBaseResponse when remote data source fails on logout',
      () async {
        // Arrange
        when(mockRemoteDataSource.logout()).thenAnswer(
          (_) async => ErrorBaseResponse(errorMessage: tErrorMessage),
        );

        // Act
        final result = await repository.logout();

        // Assert
        expect(result, isA<ErrorBaseResponse<LogoutResponseEntity>>());
        expect(
          (result as ErrorBaseResponse).errorMessage,
          equals(tErrorMessage),
        );
        verifyNever(mockSecurityStorage.deleteSecuredString(any));
      },
    );
  });
}
