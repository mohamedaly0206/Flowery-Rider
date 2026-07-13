import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String? id;
  final String? title;
  final String? imgCover;
  final int? quantity;

  const ProductEntity({
    this.id,
    this.title,
    this.imgCover,
    this.quantity,
    double? price,
  });

  @override
  List<Object?> get props => [id, title, imgCover, quantity];
}
