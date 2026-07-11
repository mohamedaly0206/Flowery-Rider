import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flowery_rider/config/base_response/base_response.dart';
import 'package:flowery_rider/modules/order_tracking/data/models/request/update_order_state_request.dart';
import 'package:flowery_rider/modules/order_tracking/data/models/response/order_state_dto.dart';
import 'package:flowery_rider/modules/order_tracking/data/models/response/pending_orders_dto.dart';
import 'package:flowery_rider/modules/order_tracking/data/models/response/start_order_dto/orders_state_response_dto.dart';
import 'package:flowery_rider/modules/order_tracking/data/remote/api_client/order_tracking_api_client.dart';
import 'package:flowery_rider/modules/order_tracking/data/remote/data_sources/order_tracking_remote_data_source_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([OrderTrackingApiClient])
import 'order_tracking_remote_data_source_impl_test.mocks.dart';

void main() {
  // 1. Initialize the Flutter binding for tests
  TestWidgetsFlutterBinding.ensureInitialized();

  // 2. Setup the mock channels for Firebase Core
  setupFirebaseCoreMocks();

  late OrderTrackingRemoteDataSourceImpl dataSource;
  late MockOrderTrackingApiClient mockApiClient;

  setUpAll(() async {
    // 3. Fake the Firebase initialization
    await Firebase.initializeApp();

    provideDummy<BaseResponse<PendingOrdersDto>>(
      SuccessBaseResponse<PendingOrdersDto>(data: PendingOrdersDto()),
    );
    provideDummy<BaseResponse<OrderStateResponseDto>>(
      SuccessBaseResponse<OrderStateResponseDto>(data: OrderStateResponseDto()),
    );
  });

  setUp(() {
    mockApiClient = MockOrderTrackingApiClient();
    dataSource = OrderTrackingRemoteDataSourceImpl(mockApiClient);
  });

  const tOrderId = 'order_123';
  final tPendingOrdersDto = PendingOrdersDto();
  final tOrderStateResponseDto = OrderStateResponseDto();
  const tUpdateOrderStateRequest = UpdateOrderStateRequest(
    state: OrderStateDto.pending,
  );

  group('getPendingOrders', () {
    test(
      'should return SuccessBaseResponse when the API call is successful',
      () async {
        // Arrange
        when(
          mockApiClient.getPendingOrders(),
        ).thenAnswer((_) async => tPendingOrdersDto);

        // Act
        final result = await dataSource.getPendingOrders();

        // Assert
        expect(result, isA<SuccessBaseResponse<PendingOrdersDto>>());
        expect((result as SuccessBaseResponse).data, equals(tPendingOrdersDto));
        verify(mockApiClient.getPendingOrders()).called(1);
      },
    );

    test(
      'should return ErrorBaseResponse when the API call throws an Exception',
      () async {
        // Arrange
        when(mockApiClient.getPendingOrders()).thenThrow(Exception());

        // Act
        final result = await dataSource.getPendingOrders();

        // Assert
        expect(result, isA<ErrorBaseResponse<PendingOrdersDto>>());
        verify(mockApiClient.getPendingOrders()).called(1);
      },
    );
  });

  group('startOrder', () {
    test(
      'should return SuccessBaseResponse when starting an order is successful',
      () async {
        // Arrange
        when(
          mockApiClient.startOrder(any),
        ).thenAnswer((_) async => tOrderStateResponseDto);

        // Act
        final result = await dataSource.startOrder(tOrderId);

        // Assert
        expect(result, isA<SuccessBaseResponse<OrderStateResponseDto>>());
        expect(
          (result as SuccessBaseResponse).data,
          equals(tOrderStateResponseDto),
        );
        verify(mockApiClient.startOrder(tOrderId)).called(1);
      },
    );
  });

  group('updateOrderState', () {
    test(
      'should return SuccessBaseResponse when updating an order is successful',
      () async {
        // Arrange
        when(
          mockApiClient.updateOrderState(any, any),
        ).thenAnswer((_) async => tOrderStateResponseDto);

        // Act
        final result = await dataSource.updateOrderState(
          tOrderId,
          tUpdateOrderStateRequest,
        );

        // Assert
        expect(result, isA<SuccessBaseResponse<OrderStateResponseDto>>());
        verify(
          mockApiClient.updateOrderState(
            tOrderId,
            argThat(isA<UpdateOrderStateRequest>()),
          ),
        ).called(1);
      },
    );
  });
}
