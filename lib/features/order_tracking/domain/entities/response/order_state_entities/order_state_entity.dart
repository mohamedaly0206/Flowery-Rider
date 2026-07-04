import 'package:equatable/equatable.dart';
import 'package:flowery_rider/features/order_tracking/domain/entities/response/order_state_entities/order_state_item_entity.dart';

class OrderStateEntity extends Equatable {
  final String? id;
  final String? user;
  final List<OrderStateItemEntity>? orderItems;
  final int? totalPrice;
  final String? paymentType;
  final bool? isPaid;
  final String? state;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? orderNumber;

  const OrderStateEntity({
    this.id,
    this.user,
    this.orderItems,
    this.totalPrice,
    this.paymentType,
    this.isPaid,
    this.state,
    this.createdAt,
    this.updatedAt,
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
    state,
    createdAt,
    updatedAt,
    orderNumber,
  ];
}
