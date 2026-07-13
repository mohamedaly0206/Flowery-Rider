import 'package:bloc_test/bloc_test.dart';
import 'package:flowery_rider/config/base_response/base_response.dart';
import 'package:flowery_rider/core/services/location_services/location_service.dart';
import 'package:flowery_rider/modules/order_tracking/domain/entities/response/order_entity.dart';
import 'package:flowery_rider/modules/order_tracking/domain/entities/response/order_state_entities/order_state_response_entity.dart';
import 'package:flowery_rider/modules/order_tracking/domain/entities/response/pending_orders_entity.dart';
import 'package:flowery_rider/modules/order_tracking/domain/use_cases/save_order_use_case.dart';
import 'package:flowery_rider/modules/order_tracking/domain/use_cases/get_pending_orders_use_case.dart';
import 'package:flowery_rider/modules/order_tracking/domain/use_cases/start_order_use_case.dart';
import 'package:flowery_rider/modules/order_tracking/presentation/home/view_model/cubit/home_cubit.dart';
import 'package:flowery_rider/modules/order_tracking/presentation/home/view_model/intent/home_intent.dart';
import 'package:flowery_rider/modules/order_tracking/presentation/home/view_model/state/home_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([
  GetPendingOrdersUseCase,
  StartOrderUseCase,
  SaveOrderUseCase,
  LocationService,
])
import 'home_cubit_test.mocks.dart';

void main() {
  late MockGetPendingOrdersUseCase mockGetPendingOrdersUseCase;
  late MockStartOrderUseCase mockStartOrderUseCase;
  late MockFirestoreOrderUseCase mockFirestoreOrderUseCase;
  late MockLocationService mockLocationService;

  final tPendingOrdersEntity = PendingOrdersEntity(orders: []);
  final tOrderStateResponseEntity = OrderStateResponseEntity();
  final tOrderEntity = OrderEntity(id: 'order_123');
  final tPosition = Position(
    longitude: 0,
    latitude: 0,
    timestamp: DateTime.now(),
    accuracy: 0,
    altitude: 0,
    heading: 0,
    speed: 0,
    speedAccuracy: 0,
    altitudeAccuracy: 0,
    headingAccuracy: 0,
  );

  setUpAll(() {
    provideDummy<BaseResponse<PendingOrdersEntity>>(
      SuccessBaseResponse<PendingOrdersEntity>(data: tPendingOrdersEntity),
    );
    provideDummy<BaseResponse<OrderStateResponseEntity>>(
      SuccessBaseResponse<OrderStateResponseEntity>(
        data: tOrderStateResponseEntity,
      ),
    );
  });

  setUp(() {
    mockGetPendingOrdersUseCase = MockGetPendingOrdersUseCase();
    mockStartOrderUseCase = MockStartOrderUseCase();
    mockFirestoreOrderUseCase = MockFirestoreOrderUseCase();
    mockLocationService = MockLocationService();
  });

  group('HomeCubit - GetPendingOrdersIntent', () {
    blocTest<HomeCubit, HomeState>(
      'emits [loading, success] when fetching pending orders is successful',
      setUp: () {
        when(mockGetPendingOrdersUseCase.call()).thenAnswer(
          (_) async => SuccessBaseResponse<PendingOrdersEntity>(
            data: tPendingOrdersEntity,
          ),
        );
      },
      build: () => HomeCubit(
        mockGetPendingOrdersUseCase,
        mockStartOrderUseCase,
        mockFirestoreOrderUseCase,
        mockLocationService,
      ),
      act: (cubit) => cubit.handleHomeIntent(GetPendingOrdersIntent()),
      expect: () => [
        isA<HomeState>().having(
          (s) => s.getPendingOrdersState.isLoading,
          'isLoading',
          true,
        ),
        isA<HomeState>()
            .having(
              (s) => s.getPendingOrdersState.isLoading,
              'isLoading',
              false,
            )
            .having(
              (s) => s.getPendingOrdersState.data,
              'data',
              tPendingOrdersEntity,
            ),
      ],
    );
  });

  group('HomeCubit - StartOrderIntent', () {
    blocTest<HomeCubit, HomeState>(
      'emits error state when location permission is denied (position is null)',
      setUp: () {
        when(
          mockLocationService.getCurrentPosition(),
        ).thenAnswer((_) async => null);
      },
      build: () => HomeCubit(
        mockGetPendingOrdersUseCase,
        mockStartOrderUseCase,
        mockFirestoreOrderUseCase,
        mockLocationService,
      ),
      act: (cubit) => cubit.handleHomeIntent(
        StartOrderIntent(orderId: '123', order: tOrderEntity),
      ),
      expect: () => [
        isA<HomeState>().having(
          (s) => s.startOrderState.isLoading,
          'isLoading',
          true,
        ),
        isA<HomeState>()
            .having((s) => s.startOrderState.isLoading, 'isLoading', false)
            .having(
              (s) => s.startOrderState.errorMessage,
              'errorMessage',
              'Location permission required.',
            ),
      ],
    );

    blocTest<HomeCubit, HomeState>(
      'emits [loading, success] and interacts with Firestore when start order succeeds',
      setUp: () {
        when(
          mockLocationService.getCurrentPosition(),
        ).thenAnswer((_) async => tPosition);
        when(mockStartOrderUseCase.call(any)).thenAnswer(
          (_) async => SuccessBaseResponse<OrderStateResponseEntity>(
            data: tOrderStateResponseEntity,
          ),
        );
        when(
          mockFirestoreOrderUseCase.saveOrder(
            any,
            any,
            any,
            any,
            any,
            any,
            any,
          ),
        ).thenAnswer((_) async {});
        when(
          mockFirestoreOrderUseCase.updateStatus(any, any),
        ).thenAnswer((_) async {});
      },
      build: () => HomeCubit(
        mockGetPendingOrdersUseCase,
        mockStartOrderUseCase,
        mockFirestoreOrderUseCase,
        mockLocationService,
      ),
      act: (cubit) => cubit.handleHomeIntent(
        StartOrderIntent(orderId: '123', order: tOrderEntity),
      ),
      expect: () => [
        isA<HomeState>().having(
          (s) => s.startOrderState.isLoading,
          'isLoading',
          true,
        ),
        isA<HomeState>().having(
          (s) => s.startOrderState.isLoading,
          'isLoading',
          false,
        ),
      ],
      verify: (_) {
        verify(
          mockFirestoreOrderUseCase.saveOrder(
            '123',
            tOrderEntity,
            any,
            any,
            any,
            any,
            any,
          ),
        ).called(1);
      },
    );
  });
}
