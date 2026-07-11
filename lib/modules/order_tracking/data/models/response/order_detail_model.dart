import 'package:flowery_rider/modules/order_tracking/data/models/response/order_item_model.dart';
import 'package:flowery_rider/modules/order_tracking/data/models/response/user_model.dart';
import 'package:flowery_rider/modules/order_tracking/domain/entities/response/order_detail_entity.dart';
import 'package:json_annotation/json_annotation.dart';
part 'order_detail_model.g.dart';

@JsonSerializable()
class OrderDetailModel {
  @JsonKey(name: '_id')
  final String? id;
  final UserModel? user;
  final List<OrderItemModel>? orderItems;
  final double? totalPrice;
  final String? paymentType;
  final bool? isPaid;
  final bool? isDelivered;
  final String? state;
  final String? createdAt;
  final String? orderNumber;

  const OrderDetailModel({
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
  OrderDetailEntity toEntity() {
    return OrderDetailEntity(
      id: id,
      user: user?.toEntity(),
      orderItems: orderItems?.map((e) => e.toEntity()).toList(),
      totalPrice: totalPrice,
      paymentType: paymentType,
      isPaid: isPaid,
      isDelivered: isDelivered,
      state: state,
      createdAt: createdAt,
      orderNumber: orderNumber,
    );
  }

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailModelFromJson(json);
}
