import 'package:dio/dio.dart';
import 'package:flowery_rider/core/values/api_endpoints.dart';
import 'package:flowery_rider/core/values/app_strings.dart';
import 'package:flowery_rider/features/order_tracking/data/models/request/update_order_state_request.dart';
import 'package:flowery_rider/features/order_tracking/data/models/response/driver_orders_response_model.dart';
import 'package:flowery_rider/features/order_tracking/data/models/response/pending_orders_dto.dart';
import 'package:flowery_rider/features/order_tracking/data/models/response/start_order_dto/orders_state_response_dto.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'order_tracking_api_client.g.dart';

@injectable
@RestApi()
abstract class OrderTrackingApiClient {
  @factoryMethod
  factory OrderTrackingApiClient(Dio dio) = _OrderTrackingApiClient;

  @GET(ApiEndpoints.getPendingOrders)
  Future<PendingOrdersDto> getPendingOrders();

  @PUT('${ApiEndpoints.updateOrderState}{orderId}')
  Future<OrderStateResponseDto> updateOrderState(
    @Path(AppStrings.orderId) String orderId,
    @Body() UpdateOrderStateRequest updateOrderStateRequest,
  );

  @PUT('${ApiEndpoints.startOrder}{orderId}')
  Future<OrderStateResponseDto> startOrder(
    @Path(AppStrings.orderId) String orderId,
  );
  @GET(ApiEndpoints.getDriverOrders)
  Future<DriverOrdersResponseModel> getAllDriverOrders();
}
