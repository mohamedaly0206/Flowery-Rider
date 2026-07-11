import 'package:equatable/equatable.dart';

class ProductsEntity extends Equatable {
  final String? id;
  final double? price;

  const ProductsEntity({this.id, this.price});

  @override
  List<Object?> get props => [id, price];
}
