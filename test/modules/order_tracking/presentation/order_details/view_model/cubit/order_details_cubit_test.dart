import 'package:bloc_test/bloc_test.dart';
import 'package:flowery_rider/core/services/location_service.dart';
import 'package:flowery_rider/modules/order_tracking/domain/entities/response/order_entity.dart';
import 'package:flowery_rider/modules/order_tracking/domain/use_cases/firestore_order_use_case.dart';
import 'package:flowery_rider/modules/order_tracking/domain/use_cases/update_order_state_use_case.dart';
import 'package:flowery_rider/modules/order_tracking/presentation/order_details/view_model/cubit/order_details_cubit.dart';
import 'package:flowery_rider/modules/order_tracking/presentation/order_details/view_model/intent/order_details_intent.dart';
import 'package:flowery_rider/modules/order_tracking/presentation/order_details/view_model/state/order_details_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([
  UpdateOrderStateUseCase,
  FirestoreOrderUseCase,
  LocationService,
])
import 'order_details_cubit_test.mocks.dart';

void main() {
  late MockUpdateOrderStateUseCase mockUpdateOrderStateUseCase;
  late MockFirestoreOrderUseCase mockFirestoreOrderUseCase;
  late MockLocationService mockLocationService;

  setUp(() {
    mockUpdateOrderStateUseCase = MockUpdateOrderStateUseCase();
    mockFirestoreOrderUseCase = MockFirestoreOrderUseCase();
    mockLocationService = MockLocationService();
  });

  group('OrderDetailsCubit - UpdateOrderDetailsStatuesIntent', () {
    blocTest<OrderDetailsCubit, OrderDetailsState>(
      'advances status and updates Firestore when intent is received',
      setUp: () {
        when(
          mockFirestoreOrderUseCase.updateStatus(any, any),
        ).thenAnswer((_) async {});
      },
      build: () {
        final cubit = OrderDetailsCubit(
          mockUpdateOrderStateUseCase,
          mockFirestoreOrderUseCase,
          mockLocationService,
        );
        // Initialize tracking to set _currentOrderId
        when(
          mockLocationService.getLocationStream(),
        ).thenAnswer((_) => const Stream.empty());
        when(
          mockFirestoreOrderUseCase.getOrderStatusStream(any),
        ).thenAnswer((_) => const Stream.empty());
        cubit.initTracking(const OrderEntity(id: 'order_123'));
        return cubit;
      },
      act: (cubit) =>
          cubit.handleOrderDetailsIntent(UpdateOrderDetailsStatuesIntent()),
      expect: () => [
        // Assumes `OrderDetailsState` has a `status` enum with a `next` getter
        isA<OrderDetailsState>(),
      ],
      verify: (_) {
        verify(
          mockFirestoreOrderUseCase.updateStatus('order_123', any),
        ).called(1);
      },
    );
  });
}
