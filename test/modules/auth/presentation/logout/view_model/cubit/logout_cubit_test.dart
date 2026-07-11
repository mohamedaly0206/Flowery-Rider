import 'package:bloc_test/bloc_test.dart';
import 'package:flowery_rider/config/base_response/base_response.dart';
import 'package:flowery_rider/modules/auth/domain/entities/logout_response_entity.dart';
import 'package:flowery_rider/modules/auth/domain/use_cases/logout_use_case.dart';
import 'package:flowery_rider/modules/auth/presentation/logout/view_model/cubit/logout_cubit.dart';
import 'package:flowery_rider/modules/auth/presentation/logout/view_model/intent/logout_intent.dart';
import 'package:flowery_rider/modules/auth/presentation/logout/view_model/state/logout_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([LogoutUseCase])
import 'logout_cubit_test.mocks.dart';

void main() {
  late MockLogoutUseCase mockLogoutUseCase;

  final tLogoutResponseEntity = LogoutResponseEntity();
  const tErrorMessage = 'An error occurred during logout. Please try again.';

  setUpAll(() {
    provideDummy<BaseResponse<LogoutResponseEntity>>(
      SuccessBaseResponse<LogoutResponseEntity>(data: tLogoutResponseEntity),
    );
  });

  setUp(() {
    mockLogoutUseCase = MockLogoutUseCase();
  });

  group('LogoutCubit - handleLogoutIntent', () {
    blocTest<LogoutCubit, LogoutState>(
      'emits [loading, success] states when GetLogoutIntent is successful',
      setUp: () {
        when(mockLogoutUseCase.call()).thenAnswer(
          (_) async => SuccessBaseResponse<LogoutResponseEntity>(
            data: tLogoutResponseEntity,
          ),
        );
      },
      build: () => LogoutCubit(mockLogoutUseCase),
      act: (cubit) => cubit.handleLogoutIntent(GetLogoutIntent()),
      expect: () => [
        isA<LogoutState>().having(
          (s) => s.logoutState.isLoading,
          'isLoading',
          true,
        ),
        isA<LogoutState>().having(
          (s) => s.logoutState.data,
          'data',
          tLogoutResponseEntity,
        ),
      ],
      verify: (_) {
        verify(mockLogoutUseCase.call()).called(1);
      },
    );

    blocTest<LogoutCubit, LogoutState>(
      'emits [loading, error] states when GetLogoutIntent fails',
      setUp: () {
        when(mockLogoutUseCase.call()).thenAnswer(
          (_) async => ErrorBaseResponse<LogoutResponseEntity>(
            errorMessage: tErrorMessage,
          ),
        );
      },
      build: () => LogoutCubit(mockLogoutUseCase),
      act: (cubit) => cubit.handleLogoutIntent(GetLogoutIntent()),
      expect: () => [
        isA<LogoutState>().having(
          (s) => s.logoutState.isLoading,
          'isLoading',
          true,
        ),
        isA<LogoutState>().having(
          (s) => s.logoutState.errorMessage,
          'errorMessage',
          tErrorMessage,
        ),
      ],
      verify: (_) {
        verify(mockLogoutUseCase.call()).called(1);
      },
    );
  });
}
