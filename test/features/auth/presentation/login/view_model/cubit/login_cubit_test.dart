import 'package:bloc_test/bloc_test.dart';
import 'package:flowery_rider/config/base_response/base_response.dart';
import 'package:flowery_rider/config/base_state/base_state.dart';
import 'package:flowery_rider/features/auth/domain/entities/login_response_entity.dart';
import 'package:flowery_rider/features/auth/domain/use_cases/login_use_case.dart';
import 'package:flowery_rider/features/auth/presentation/login/view_model/cubit/login_cubit.dart';
import 'package:flowery_rider/features/auth/presentation/login/view_model/intent/login_intent.dart';
import 'package:flowery_rider/features/auth/presentation/login/view_model/state/login_states.dart';
// Ensure LoginCubit file is imported properly here
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([LoginUseCase])
import 'login_cubit_test.mocks.dart';

void main() {
  late MockLoginUseCase mockLoginUseCase;
  
  final tLoginResponseEntity = LoginResponseEntity(token: 'secure_rider_token');
  const tEmail = 'rider@flowery.com';
  const tPassword = 'secure_password';
  const tErrorMessage = 'Invalid login credentials';

  setUpAll(() {
    provideDummy<BaseResponse<LoginResponseEntity>>(
      SuccessBaseResponse<LoginResponseEntity>(data: tLoginResponseEntity),
    );
  });

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
  });

  group('LoginCubit - Toggles', () {
    blocTest<LoginCubit, LoginState>(
      'emits state with inverted obscurePassword when TogglePasswordVisibilityIntent is added',
      build: () => LoginCubit(mockLoginUseCase),
      seed: () => const LoginState(obscurePassword: true),
      act: (cubit) => cubit.handleLoginIntent(TogglePasswordVisibilityIntent()),
      expect: () => [
        isA<LoginState>().having((s) => s.obscurePassword, 'obscurePassword', false),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'emits state with updated rememberMe when ToggleRememberMeIntent is added',
      build: () => LoginCubit(mockLoginUseCase),
      seed: () => const LoginState(rememberMe: false),
      act: (cubit) => cubit.handleLoginIntent(ToggleRememberMeIntent( true)),
      expect: () => [
        isA<LoginState>().having((s) => s.rememberMe, 'rememberMe', true),
      ],
    );
  });

  group('LoginCubit - SubmitLoginIntent', () {
    blocTest<LoginCubit, LoginState>(
      'emits [loading, success] states when login is successful',
      setUp: () {
        when(mockLoginUseCase.call(body: anyNamed('body'), isRememberMe: anyNamed('isRememberMe')))
            .thenAnswer((_) async => SuccessBaseResponse<LoginResponseEntity>(data: tLoginResponseEntity));
      },
      build: () => LoginCubit(mockLoginUseCase),
      act: (cubit) => cubit.handleLoginIntent(SubmitLoginIntent(email: tEmail, password: tPassword)),
      expect: () => [
        isA<LoginState>().having(
          (s) => s.loginState.isLoading,
          'isLoading',
          true,
        ),
        isA<LoginState>().having(
          (s) => s.loginState.data,
          'data',
          tLoginResponseEntity,
        ),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'emits [loading, error] states when login fails',
      setUp: () {
        when(mockLoginUseCase.call(body: anyNamed('body'), isRememberMe: anyNamed('isRememberMe')))
            .thenAnswer((_) async => ErrorBaseResponse<LoginResponseEntity>(errorMessage: tErrorMessage));
      },
      build: () => LoginCubit(mockLoginUseCase),
      act: (cubit) => cubit.handleLoginIntent(SubmitLoginIntent(email: tEmail, password: tPassword)),
      expect: () => [
        isA<LoginState>().having(
          (s) => s.loginState.isLoading,
          'isLoading',
          true,
        ),
        isA<LoginState>().having(
          (s) => s.loginState.errorMessage,
          'errorMessage',
          tErrorMessage,
        ),
      ],
    );
  });
}