import 'dart:developer';
import 'package:flowery_rider/config/base_cubit/base_cubit.dart';
import 'package:flowery_rider/config/base_event/base_event.dart';
import 'package:flowery_rider/config/base_response/base_response.dart';
import 'package:flowery_rider/config/base_state/base_state.dart';
import 'package:flowery_rider/core/router/router_paths.dart';
import 'package:flowery_rider/features/order_tracking/data/models/request/update_order_state_request.dart';
import 'package:flowery_rider/features/order_tracking/data/models/response/order_state_dto.dart';
import 'package:flowery_rider/features/order_tracking/domain/entities/response/order_entity.dart';
import 'package:flowery_rider/features/order_tracking/domain/use_cases/update_order_state_use_case.dart';
import 'package:flowery_rider/features/order_tracking/presentation/order_details/view_model/intent/order_details_intent.dart';
import 'package:flowery_rider/features/order_tracking/domain/entities/order_status/order_details_status.dart';
import 'package:injectable/injectable.dart';
import '../state/order_details_state.dart';

@injectable
class OrderDetailsCubit extends BaseCubit<OrderDetailsState, BaseEvent> {
  final UpdateOrderStateUseCase _updateOrderStateUseCase;
  OrderDetailsCubit(UpdateOrderStateUseCase updateOrderStateUseCase)
    : _updateOrderStateUseCase = updateOrderStateUseCase,
      super(OrderDetailsState());

  void handleOrderDetailsIntent(OrderDetailsIntent intent) {
    switch (intent) {
      case UpdateOrderDetailsStatuesIntent():
        _advanceStatus();
        break;
      case UpdateOrderStateIntent():
        _updateOrderState(intent.orderId, intent.request);
        break;
    }
  }

  void _advanceStatus() {
    emit(state.copyWith(status: state.status.next));
  }

  Future<void> _updateOrderState(
    String orderId,
    UpdateOrderStateRequest request,
  ) async {
    emit(state.copyWith(updateOrderState: const BaseState(isLoading: true)));
    log('updateOrderState....');
    final response = await _updateOrderStateUseCase.call(orderId, request);
    switch (response) {
      case SuccessBaseResponse<OrderEntity>():
        emit(
          state.copyWith(
            updateOrderState: BaseState(isLoading: false, data: response.data),
          ),
        );
        if (request.state == OrderStateDto.canceled) {
          emitEvent(DisplaySuccess('Order canceled successfully'));
          emitEvent(NavigateEvent(routeName: AppRouterPaths.kHomeView));
        }

        log('updateOrderState success $request');
        break;
      case ErrorBaseResponse<OrderEntity>():
        emit(
          state.copyWith(
            updateOrderState: BaseState(
              isLoading: false,
              errorMessage: response.errorMessage,
            ),
          ),
        );
        emitEvent(DisplayError(response.errorMessage));
        log('updateOrderState error: ${response.errorMessage}');
        break;
    }
  }
}
