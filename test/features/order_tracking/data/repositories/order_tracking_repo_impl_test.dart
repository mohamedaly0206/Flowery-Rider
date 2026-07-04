import 'package:flowery_rider/config/base_response/base_response.dart';
import 'package:flowery_rider/features/order_tracking/data/models/request/update_order_state_request.dart';
import 'package:flowery_rider/features/order_tracking/data/models/response/order_state_dto.dart';
import 'package:flowery_rider/features/order_tracking/data/models/response/pending_orders_dto.dart';
import 'package:flowery_rider/features/order_tracking/data/models/response/start_order_dto/orders_state_response_dto.dart';
import 'package:flowery_rider/features/order_tracking/data/remote/data_sources/order_tracking_remote_data_source_contract.dart';
import 'package:flowery_rider/features/order_tracking/data/repositories/order_tracking_repo_impl.dart';
import 'package:flowery_rider/features/order_tracking/domain/entities/response/order_state_entities/order_state_response_entity.dart';
import 'package:flowery_rider/features/order_tracking/domain/entities/response/pending_orders_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([OrderTrackingRemoteDataSourceContract])
import 'order_tracking_repo_impl_test.mocks.dart';

void main() {
  late OrderTrackingRepoImpl repository;
  late MockOrderTrackingRemoteDataSourceContract mockRemoteDataSource;

  final tPendingOrdersDto = PendingOrdersDto(orders: []);
  final tOrderStateResponseDto = OrderStateResponseDto();

  setUpAll(() {
    provideDummy<BaseResponse<PendingOrdersDto>>(
      SuccessBaseResponse<PendingOrdersDto>(data: tPendingOrdersDto),
    );

    provideDummy<BaseResponse<OrderStateResponseDto>>(
      SuccessBaseResponse<OrderStateResponseDto>(data: tOrderStateResponseDto),
    );
  });
  setUp(() {
    mockRemoteDataSource = MockOrderTrackingRemoteDataSourceContract();
    repository = OrderTrackingRepoImpl(mockRemoteDataSource);
  });

  const tOrderId = 'order_456';
  const tErrorMessage = 'Connection failed';
  const tUpdateOrderStateRequest = UpdateOrderStateRequest(
    state: OrderStateDto.pending,
  );

  group('getPendingOrders', () {
    test(
      'should return SuccessBaseResponse mapped to Entity when data source succeeds',
      () async {
        // Arrange
        when(mockRemoteDataSource.getPendingOrders()).thenAnswer(
          (_) async =>
              SuccessBaseResponse<PendingOrdersDto>(data: tPendingOrdersDto),
        );

        // Act
        final result = await repository.getPendingOrders();

        // Assert
        expect(result, isA<SuccessBaseResponse<PendingOrdersEntity>>());
        verify(mockRemoteDataSource.getPendingOrders()).called(1);
      },
    );

    test('should return ErrorBaseResponse when data source fails', () async {
      // Arrange
      when(mockRemoteDataSource.getPendingOrders()).thenAnswer(
        (_) async =>
            ErrorBaseResponse<PendingOrdersDto>(errorMessage: tErrorMessage),
      );

      // Act
      final result = await repository.getPendingOrders();

      // Assert
      expect(result, isA<ErrorBaseResponse<PendingOrdersEntity>>());
      expect((result as ErrorBaseResponse).errorMessage, equals(tErrorMessage));
      verify(mockRemoteDataSource.getPendingOrders()).called(1);
    });
  });

  group('startOrder', () {
    test(
      'should return SuccessBaseResponse mapped to Entity when data source succeeds',
      () async {
        // Arrange
        when(mockRemoteDataSource.startOrder(any)).thenAnswer(
          (_) async => SuccessBaseResponse<OrderStateResponseDto>(
            data: tOrderStateResponseDto,
          ),
        );

        // Act
        final result = await repository.startOrder(tOrderId);

        // Assert
        expect(result, isA<SuccessBaseResponse<OrderStateResponseEntity>>());
        verify(mockRemoteDataSource.startOrder(tOrderId)).called(1);
      },
    );
  });

  group('updateOrderState', () {
    test(
      'should return SuccessBaseResponse mapped to Entity when data source succeeds',
      () async {
        // Arrange
        when(mockRemoteDataSource.updateOrderState(any, any)).thenAnswer(
          (_) async => SuccessBaseResponse<OrderStateResponseDto>(
            data: tOrderStateResponseDto,
          ),
        );

        // Act
        final result = await repository.updateOrderState(
          tOrderId,
          tUpdateOrderStateRequest,
        );

        // Assert
        expect(result, isA<SuccessBaseResponse<OrderStateResponseEntity>>());
        verify(
          mockRemoteDataSource.updateOrderState(
            tOrderId,
            argThat(isA<UpdateOrderStateRequest>()),
          ),
        ).called(1);
      },
    );
  });
}
