import 'package:equatable/equatable.dart';
import 'package:flowery_rider/config/base_state/base_state.dart';

class HomeState extends Equatable {
  final BaseState getPendingOrdersState;
  final BaseState startOrderState;
  final BaseState updateOrderState;
  final String selectedOrderId;
  final OrderAction action;
  final bool isLoading;
  final int page;
  final bool hasReachedMax;
  final bool isFetchingMore;

  const HomeState({
    this.getPendingOrdersState = const BaseState(),
    this.startOrderState = const BaseState(),
    this.updateOrderState = const BaseState(),
    this.selectedOrderId = '',
    this.action = OrderAction.none,
    this.isLoading = false,
    this.page = 1,
    this.hasReachedMax = false,
    this.isFetchingMore = false,
  });

  HomeState copyWith({
    BaseState? getPendingOrdersState,
    BaseState? startOrderState,
    BaseState? updateOrderState,
    String? selectedOrderId,
    OrderAction? action,
    bool? isLoading,
    int? page,
    bool? hasReachedMax,
    bool? isFetchingMore,
  }) {
    return HomeState(
      getPendingOrdersState:
          getPendingOrdersState ?? this.getPendingOrdersState,
      startOrderState: startOrderState ?? this.startOrderState,
      updateOrderState: updateOrderState ?? this.updateOrderState,
      selectedOrderId: selectedOrderId ?? this.selectedOrderId,
      action: action ?? this.action,
      isLoading: isLoading ?? this.isLoading,
      page: page ?? this.page,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
    );
  }

  @override
  List<Object?> get props => [
    getPendingOrdersState,
    startOrderState,
    updateOrderState,
    selectedOrderId,
    action,
    isLoading,
    page,
    hasReachedMax,
    isFetchingMore,
  ];
}

enum OrderAction { none, accept, reject }
