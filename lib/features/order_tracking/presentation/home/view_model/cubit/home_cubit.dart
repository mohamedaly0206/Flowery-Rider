import 'dart:developer';
import 'package:flowery_rider/config/base_cubit/base_cubit.dart';
import 'package:flowery_rider/config/base_event/base_event.dart';
import 'package:flowery_rider/config/base_response/base_response.dart';
import 'package:flowery_rider/config/base_state/base_state.dart';
import 'package:flowery_rider/core/router/router_paths.dart';
import 'package:flowery_rider/features/order_tracking/domain/entities/response/order_entity.dart';
import 'package:flowery_rider/features/order_tracking/domain/entities/response/pending_orders_entity.dart';
import 'package:flowery_rider/features/order_tracking/domain/use_cases/get_pending_orders_use_case.dart';
import 'package:flowery_rider/features/order_tracking/domain/use_cases/start_order_use_case.dart';
import 'package:flowery_rider/features/order_tracking/presentation/home/view_model/intent/home_intent.dart';
import 'package:injectable/injectable.dart';
import '../state/home_state.dart';

@singleton
class HomeCubit extends BaseCubit<HomeState, BaseEvent> {
  HomeCubit(
    GetPendingOrdersUseCase getPendingOrdersUseCase,
    StartOrderUseCase startOrderUseCase,
  ) : _getPendingOrdersUseCase = getPendingOrdersUseCase,
      _startOrderUseCase = startOrderUseCase,
      super(const HomeState());

  final GetPendingOrdersUseCase _getPendingOrdersUseCase;
  final StartOrderUseCase _startOrderUseCase;

  void handleHomeIntent(HomeIntent intent) {
    switch (intent) {
      case GetPendingOrdersIntent():
        _getPendingOrders();
        break;
      case StartOrderIntent():
        _startOrder(intent.orderId, intent.order);
        break;
      case RejectOrderIntent():
        _rejectOrder(intent.orderId);
        break;
    }
  }

  Future<void> _getPendingOrders() async {
    emit(
      state.copyWith(getPendingOrdersState: const BaseState(isLoading: true)),
    );
    log('getPendingOrders....');
    final response = await _getPendingOrdersUseCase.call();
    switch (response) {
      case SuccessBaseResponse<PendingOrdersEntity>():
        emit(
          state.copyWith(
            getPendingOrdersState: BaseState(
              isLoading: false,
              data: response.data,
            ),
          ),
        );
        log('getPendingOrders success ');
        break;
      case ErrorBaseResponse<PendingOrdersEntity>():
        emit(
          state.copyWith(
            getPendingOrdersState: BaseState(
              isLoading: false,
              errorMessage: response.errorMessage,
            ),
          ),
        );
        log('getPendingOrders error: ${response.errorMessage}');

        break;
    }
  }

  Future<void> _startOrder(String orderId, OrderEntity selectedOrder) async {
    emit(
      state.copyWith(
        startOrderState: const BaseState(isLoading: true),
        selectedOrderId: orderId,
        action: OrderAction.accept,
      ),
    );
    final response = await _startOrderUseCase.call(orderId);
    switch (response) {
      case SuccessBaseResponse<OrderEntity>():
        emit(
          state.copyWith(
            startOrderState: BaseState(isLoading: false, data: response.data),
          ),
        );
        emitEvent(
          NavigateEvent(
            routeName: AppRouterPaths.kOrderDetailsView,
            extra: selectedOrder,
          ),
        );
        break;
      case ErrorBaseResponse<OrderEntity>():
        emit(
          state.copyWith(
            startOrderState: BaseState(
              isLoading: false,
              errorMessage: response.errorMessage,
            ),
            selectedOrderId: '',
          ),
        );
        emitEvent(DisplayError(response.errorMessage));

        break;
    }
  }
void _rejectOrder(String orderId) async {
  emit(state.copyWith(
    isLoading: true,
    selectedOrderId: orderId,
    action: OrderAction.reject,
  ));

  
  await Future.delayed(const Duration(milliseconds: 500)); 

 final currentState = state.getPendingOrdersState;
  final currentData = currentState.data; // This is PendingOrdersEntity
  
  if (currentData == null || currentData.orders == null) return;

 final updatedOrders = List<OrderEntity>.from(currentData.orders!)
    ..removeWhere((order) => order.id == orderId);
    
final updatedData = PendingOrdersEntity(
    orders: updatedOrders,
    // Add any other fields that PendingOrdersEntity requires here
  );
  emit(state.copyWith(
    isLoading: false,
    getPendingOrdersState: BaseState(
      isLoading: false,
      data: updatedData,
    ),
  ));
}
}
