import 'dart:developer';
import 'package:flowery_rider/config/base_cubit/base_cubit.dart';
import 'package:flowery_rider/config/base_event/base_event.dart';
import 'package:flowery_rider/config/base_response/base_response.dart';
import 'package:flowery_rider/config/base_state/base_state.dart';
import 'package:flowery_rider/core/router/router_paths.dart';
import 'package:flowery_rider/core/values/app_strings.dart';
import 'package:flowery_rider/modules/order_tracking/domain/entities/order_status/order_details_status.dart';
import 'package:flowery_rider/modules/order_tracking/domain/entities/response/order_entity.dart';
import 'package:flowery_rider/modules/order_tracking/domain/entities/response/order_state_entities/order_state_response_entity.dart';
import 'package:flowery_rider/modules/order_tracking/domain/entities/response/pending_orders_entity.dart';
import 'package:flowery_rider/modules/order_tracking/domain/use_cases/get_pending_orders_use_case.dart';
import 'package:flowery_rider/modules/order_tracking/domain/use_cases/save_order_use_case.dart';
import 'package:flowery_rider/modules/order_tracking/domain/use_cases/start_order_use_case.dart';
import 'package:flowery_rider/core/services/location_services/location_service.dart';
import 'package:flowery_rider/modules/order_tracking/domain/use_cases/update_statues_use_case.dart';
import 'package:flowery_rider/modules/order_tracking/presentation/home/view_model/intent/home_intent.dart';
import 'package:flowery_rider/modules/order_tracking/presentation/home/view_model/state/home_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class HomeCubit extends BaseCubit<HomeState, BaseEvent> {
  HomeCubit(
    GetPendingOrdersUseCase getPendingOrdersUseCase,
    StartOrderUseCase startOrderUseCase,
    LocationService locationService,
    SaveOrderUseCase saveOrderUseCase,
    UpdateStatuesUseCase updateStatuesUseCas,
  ) : _getPendingOrdersUseCase = getPendingOrdersUseCase,
      _startOrderUseCase = startOrderUseCase,
      _locationService = locationService,
      _saveOrderUseCase = saveOrderUseCase,

      _updateStatuesUseCase = updateStatuesUseCas,

      super(const HomeState());

  final GetPendingOrdersUseCase _getPendingOrdersUseCase;
  final StartOrderUseCase _startOrderUseCase;
  final LocationService _locationService;
  final SaveOrderUseCase _saveOrderUseCase;
  final UpdateStatuesUseCase _updateStatuesUseCase;

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
      case LoadMorePendingOrdersIntent():
        _getPendingOrders();
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
    final position = await _locationService.getCurrentPosition();
    if (position == null) {
      emit(
        state.copyWith(
          startOrderState: const BaseState(
            isLoading: false,
            errorMessage: AppStrings.locationRequired,
          ),
        ),
      );
      emitEvent(DisplayError(AppStrings.locationRequired));
      return;
    }

    final response = await _startOrderUseCase.call(orderId);
    switch (response) {
      case SuccessBaseResponse<OrderStateResponseEntity>():
        await _saveOrderUseCase.saveOrder(
          orderId,
          selectedOrder,
          '6a3c2826992612ae599b40ee',
          'Mohamed Driver',
          '+201000000000',
          position.latitude,
          position.longitude,
        );
        await _updateStatuesUseCase.updateStatus(
          orderId,
          OrderDetailsStatus.accepted.name,
        );

        emit(
          state.copyWith(
            startOrderState: BaseState(isLoading: false, data: response.data),
          ),
        );
        log(
          'startOrder success '
          'orderId: ${response.data.orders?.id}, userName: ${response.data.orders?.user}',
        );

        emitEvent(
          NavigateEvent(
            routeName: AppRouterPaths.kOrderDetailsView,
            extra: selectedOrder,
          ),
        );
        break;
      case ErrorBaseResponse<OrderStateResponseEntity>():
        log('startOrder error: ${response.errorMessage}');

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
    emit(
      state.copyWith(
        isLoading: true,
        selectedOrderId: orderId,
        action: OrderAction.reject,
      ),
    );

    await Future.delayed(const Duration(milliseconds: 500));

    final currentState = state.getPendingOrdersState;
    final currentData = currentState.data; // This is PendingOrdersEntity

    if (currentData == null || currentData.orders == null) return;

    final updatedOrders = List<OrderEntity>.from(currentData.orders!)
      ..removeWhere((order) => order.id == orderId);

    final updatedData = PendingOrdersEntity(orders: updatedOrders);
    emit(
      state.copyWith(
        isLoading: false,
        getPendingOrdersState: BaseState(isLoading: false, data: updatedData),
      ),
    );
  }
}
