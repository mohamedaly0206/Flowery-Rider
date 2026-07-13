import 'package:flowery_rider/modules/order_tracking/domain/entities/response/order_entity.dart';

sealed class OrderDetailsIntent {}

class InitTrackingIntent extends OrderDetailsIntent {
  final OrderEntity order;
  InitTrackingIntent(this.order);
}

class UpdateOrderDetailsStatuesIntent extends OrderDetailsIntent {}

class OpenStoreMapIntent extends OrderDetailsIntent {}

class OpenUserMapIntent extends OrderDetailsIntent {}
