import 'package:equatable/equatable.dart';

class MetadataEntity extends Equatable {
  final int? currentPage;
  final int? totalPages;
  final int? totalItems;
  final int? limit;

  const MetadataEntity({
    this.currentPage,
    this.totalPages,
    this.totalItems,
    this.limit,
  });

  @override
  List<Object?> get props => [currentPage, totalPages, totalItems, limit];
}
