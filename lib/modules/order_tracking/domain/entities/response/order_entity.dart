import 'package:equatable/equatable.dart';
import 'package:flowery_rider/modules/order_tracking/data/models/response/order_state_dto.dart';
import 'package:flowery_rider/modules/order_tracking/domain/entities/response/order_item_entity.dart';
import 'package:flowery_rider/modules/order_tracking/domain/entities/response/shipping_address_entity.dart';
import 'package:flowery_rider/modules/order_tracking/domain/entities/response/store_entity.dart';
import 'package:flowery_rider/modules/order_tracking/domain/entities/response/user_entity.dart';

class OrderEntity extends Equatable {
  final String? id;
  final UserEntity? user;
  final List<OrderItemEntity>? orderItems;
  final int? totalPrice;
  final String? paymentType;
  final OrderStateEnum? state;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? orderNumber;
  final StoreEntity? store;
  final ShippingAddressEntity? shippingAddress;

  const OrderEntity({
    this.id,
    this.user,
    this.orderItems,
    this.totalPrice,
    this.paymentType,
    this.state,
    this.createdAt,
    this.updatedAt,
    this.orderNumber,
    this.store,
    this.shippingAddress,
  });

  @override
  List<Object?> get props => [
    id,
    user,
    orderItems,
    totalPrice,
    paymentType,
    state,
    createdAt,
    updatedAt,
    orderNumber,
    store,
    shippingAddress,
  ];
}
