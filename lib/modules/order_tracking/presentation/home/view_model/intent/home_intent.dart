import 'package:flowery_rider/modules/order_tracking/domain/entities/response/order_entity.dart';

sealed class HomeIntent {}

class GetPendingOrdersIntent extends HomeIntent {}

class StartOrderIntent extends HomeIntent {
  final String orderId;
  final OrderEntity order;

  StartOrderIntent({required this.orderId, required this.order});
}

class RejectOrderIntent extends HomeIntent {
  final String orderId;
  RejectOrderIntent({required this.orderId});
}
