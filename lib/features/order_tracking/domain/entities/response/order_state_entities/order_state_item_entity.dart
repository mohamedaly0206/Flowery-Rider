import 'package:equatable/equatable.dart';

class OrderStateItemEntity extends Equatable {
  final String? product;
  final int? price;
  final int? quantity;
  final String? id;

  const OrderStateItemEntity({
    this.product,
    this.price,
    this.quantity,
    this.id,
  });

  @override
  List<Object?> get props => [product, price, quantity, id];
}
