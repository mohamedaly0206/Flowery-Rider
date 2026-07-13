import 'dart:async';
import 'package:flowery_rider/config/base_cubit/base_cubit.dart';
import 'package:flowery_rider/config/base_event/base_event.dart';
import 'package:flowery_rider/config/base_response/base_response.dart';
import 'package:flowery_rider/config/base_state/base_state.dart';
import 'package:flowery_rider/modules/order_tracking/domain/use_cases/get_all_driver_orders_use_case.dart';
import 'package:flowery_rider/modules/order_tracking/presentation/order_page/view_model/intent/orders_intent.dart';
import 'package:flowery_rider/modules/order_tracking/presentation/order_page/view_model/state/orders_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class OrdersCubit extends BaseCubit<OrdersState, BaseEvent> {
  final GetAllDriverOrdersUseCase _getAllDriverOrdersUseCase;

  OrdersCubit(this._getAllDriverOrdersUseCase) : super(const OrdersState());

  void handleIntent(OrdersIntent intent) {
    switch (intent) {
      case GetAllDriverOrdersIntent():
        getAllOrders();
    }
  }

  Future<void> getAllOrders() async {
    emit(state.copyWith(ordersState: const BaseState(isLoading: true)));

    final response = await _getAllDriverOrdersUseCase.call();

    switch (response) {
      case SuccessBaseResponse():
        emit(state.copyWith(ordersState: BaseState(data: response.data)));
        break;
      case ErrorBaseResponse():
        emit(
          state.copyWith(
            ordersState: BaseState(errorMessage: response.errorMessage),
          ),
        );
        emitEvent(DisplayError(response.errorMessage));
        break;
    }
  }
}
