import 'package:equatable/equatable.dart';
import 'package:flowery_rider/features/order_tracking/domain/entities/response/order_item_entity.dart';
import 'package:flowery_rider/features/order_tracking/domain/entities/response/users_entity.dart';

class OrderDetailEntity extends Equatable {
  final String? id;
  final UsersEntity? user;
  final List<OrderItemEntity>? orderItems;
  final double? totalPrice;
  final String? paymentType;
  final bool? isPaid;
  final bool? isDelivered;
  final String? state;
  final String? createdAt;
  final String? orderNumber;

  const OrderDetailEntity({
    this.id,
    this.user,
    this.orderItems,
    this.totalPrice,
    this.paymentType,
    this.isPaid,
    this.isDelivered,
    this.state,
    this.createdAt,
    this.orderNumber,
  });

  @override
  List<Object?> get props => [
    id,
    user,
    orderItems,
    totalPrice,
    paymentType,
    isPaid,
    isDelivered,
    state,
    createdAt,
    orderNumber,
  ];
}
