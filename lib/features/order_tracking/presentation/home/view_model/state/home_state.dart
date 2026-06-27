import 'package:equatable/equatable.dart';
import 'package:flowery_rider/config/base_state/base_state.dart';

class HomeState extends Equatable {
  final BaseState getPendingOrdersState;
  final BaseState startOrderState;
  final BaseState updateOrderState;
  final String selectedOrderId;
  final OrderAction action;
  final bool isLoading ;

  const HomeState({
    this.getPendingOrdersState = const BaseState(),
    this.startOrderState = const BaseState(),
    this.updateOrderState = const BaseState(),
    this.selectedOrderId = '',
    this.action = OrderAction.none,
    this.isLoading = false,
  });

  HomeState copyWith({
    BaseState? getPendingOrdersState,
    BaseState? startOrderState,
    BaseState? updateOrderState,
    String? selectedOrderId,
    OrderAction? action,
    bool? isLoading
  }) {
    return HomeState(
      getPendingOrdersState:
          getPendingOrdersState ?? this.getPendingOrdersState,
      startOrderState: startOrderState ?? this.startOrderState,
      updateOrderState: updateOrderState ?? this.updateOrderState,
      selectedOrderId: selectedOrderId ?? this.selectedOrderId,
      action: action ?? this.action,
      isLoading: isLoading ?? this.isLoading
    );
  }

  @override
  List<Object?> get props => [
    getPendingOrdersState,
    startOrderState,
    updateOrderState,
    selectedOrderId,
    action,
  ];
}

enum OrderAction { none, accept, reject }
