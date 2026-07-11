import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flowery_rider/config/base_response/base_response.dart';
import 'package:flowery_rider/features/profile/domain/entities/driver_profile_entity.dart';
import 'package:flowery_rider/features/profile/domain/use_cases/get_logged_driver_data_use_case.dart';
import 'package:flowery_rider/features/profile/presentation/profile/view_model/cubit/profile_cubit.dart';
import 'package:flowery_rider/features/profile/presentation/profile/view_model/state/profile_state.dart';

class MockGetLoggedDriverDataUseCase extends Mock
    implements GetLoggedDriverDataUseCase {}

void main() {
  late MockGetLoggedDriverDataUseCase mockUseCase;

  final tDriverProfile = DriverProfileEntity(
    id: "1",
    country: "Egypt",
    firstName: "Ahmed",
    lastName: "Khodary",
    vehicleType: "676b31a45d05310ca82657ac",
    vehicleNumber: "1234",
    vehicleLicense: "license.png",
    nid: "12345678901234",
    nidImg: "nid.png",
    email: "ahmed@test.com",
    gender: "male",
    phone: "01289757455",
    photo: "photo.png",
    role: "driver",
    createdAt: DateTime.parse("2026-06-29 19:23:42.739436"),
  );

  setUp(() {
    mockUseCase = MockGetLoggedDriverDataUseCase();
  });

  group('ProfileCubit Unit Tests', () {
    blocTest<ProfileCubit, ProfileState>(
      'should emit ProfileState with data when GetLoggedDriverDataUseCase succeeds',
      build: () {
        when(
          () => mockUseCase.call(),
        ).thenAnswer((_) async => SuccessBaseResponse(data: tDriverProfile));
        return ProfileCubit(mockUseCase);
      },
      // 🌟 Seed ProfileState with isLoading: true to match the synchronous constructor execution flow
      seed: () =>
          const ProfileState(isLoading: true, data: null, errorMessage: null),
      expect: () => [
        ProfileState(
          isLoading: false,
          data: tDriverProfile,
          errorMessage: null,
        ),
      ],
      verify: (_) {
        verify(() => mockUseCase.call()).called(1);
      },
    );

    blocTest<ProfileCubit, ProfileState>(
      'should emit ProfileState with errorMessage when GetLoggedDriverDataUseCase fails',
      build: () {
        when(() => mockUseCase.call()).thenAnswer(
          (_) async => ErrorBaseResponse(errorMessage: "Unauthorized Token"),
        );
        return ProfileCubit(mockUseCase);
      },
      seed: () =>
          const ProfileState(isLoading: true, data: null, errorMessage: null),
      expect: () => [
        const ProfileState(
          isLoading: false,
          data: null,
          errorMessage: "Unauthorized Token",
        ),
      ],
      verify: (_) {
        verify(() => mockUseCase.call()).called(1);
      },
    );
  });
}
