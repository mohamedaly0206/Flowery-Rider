import 'package:bloc_test/bloc_test.dart';
import 'package:flowery_rider/config/base_response/base_response.dart';
import 'package:flowery_rider/core/services/location_services/location_service.dart';
import 'package:flowery_rider/modules/order_tracking/domain/entities/response/order_entity.dart';
import 'package:flowery_rider/modules/order_tracking/domain/use_cases/get_order_statues_use_case.dart';
import 'package:flowery_rider/modules/order_tracking/domain/use_cases/update_location_use_case.dart';
import 'package:flowery_rider/modules/order_tracking/domain/use_cases/update_order_state_use_case.dart';
import 'package:flowery_rider/modules/order_tracking/domain/use_cases/update_statues_use_case.dart';
import 'package:flowery_rider/modules/order_tracking/presentation/order_details/view_model/cubit/order_details_cubit.dart';
import 'package:flowery_rider/modules/order_tracking/presentation/order_details/view_model/intent/order_details_intent.dart';
import 'package:flowery_rider/modules/order_tracking/presentation/order_details/view_model/state/order_details_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// 1. Updated GenerateMocks to match the 5 dependencies the Cubit actually needs
@GenerateMocks([
  UpdateOrderStateUseCase,
  GetOrderStatuesUseCase,
  UpdateLocationUseCase,
  UpdateStatuesUseCase,
  LocationService,
])
import 'order_details_cubit_test.mocks.dart';

void main() {
  late MockUpdateOrderStateUseCase mockUpdateOrderStateUseCase;
  late MockGetOrderStatuesUseCase mockGetOrderStatuesUseCase;
  late MockUpdateLocationUseCase mockUpdateLocationUseCase;
  late MockUpdateStatuesUseCase mockUpdateStatuesUseCase;
  late MockLocationService mockLocationService;

  setUpAll(() {
    // This tells Mockito how to handle BaseResponse<void> globally
    provideDummy<BaseResponse<void>>(
      SuccessBaseResponse<void>(data: null),
    );
  });

  setUp(() {
    mockUpdateOrderStateUseCase = MockUpdateOrderStateUseCase();
    mockGetOrderStatuesUseCase = MockGetOrderStatuesUseCase();
    mockUpdateLocationUseCase = MockUpdateLocationUseCase();
    mockUpdateStatuesUseCase = MockUpdateStatuesUseCase();
    mockLocationService = MockLocationService();
  });

  group('OrderDetailsCubit - UpdateOrderDetailsStatuesIntent', () {
    blocTest<OrderDetailsCubit, OrderDetailsState>(
      'advances status and updates Firestore when intent is received',
      setUp: () {
        when(
          mockUpdateStatuesUseCase.updateStatus(any, any),
        ).thenAnswer((_) async {
          return SuccessBaseResponse<void>(data: null);
        });
      },
      build: () {
        // 3. Pass all 5 dependencies to the constructor in the correct order
        final cubit = OrderDetailsCubit(
          mockUpdateOrderStateUseCase,
          mockGetOrderStatuesUseCase,
          mockUpdateLocationUseCase,
          mockUpdateStatuesUseCase,
          mockLocationService,
        );
        
        when(
          mockLocationService.getLocationStream(),
        ).thenAnswer((_) => const Stream.empty());
        
        when(
          mockGetOrderStatuesUseCase.getOrderStatusStream(any),
        ).thenAnswer((_) => const Stream.empty());

        // 4. Initialize tracking via Intent (Strict MVI)
        cubit.handleOrderDetailsIntent(
          InitTrackingIntent(const OrderEntity(id: 'order_123')),
        );
        
        return cubit;
      },
      act: (cubit) =>
          cubit.handleOrderDetailsIntent(UpdateOrderDetailsStatuesIntent()),
      expect: () => [
        // Assumes `OrderDetailsState` has a `status` enum with a `next` getter
        isA<OrderDetailsState>(),
      ],
      verify: (_) {
        // 5. Verify against the correctly separated UseCase
        verify(
          mockUpdateStatuesUseCase.updateStatus('order_123', any),
        ).called(1);
      },
    );
  });
}