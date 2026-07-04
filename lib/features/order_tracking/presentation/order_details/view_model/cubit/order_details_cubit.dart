import 'package:flowery_rider/config/base_cubit/base_cubit.dart';
import 'package:flowery_rider/config/base_event/base_event.dart';
import 'package:flowery_rider/core/router/router_paths.dart';
import 'package:flowery_rider/features/order_tracking/data/models/request/update_order_state_request.dart';
import 'package:flowery_rider/features/order_tracking/data/models/response/order_state_dto.dart';
import 'package:flowery_rider/features/order_tracking/domain/use_cases/firestore_order_use_case.dart';
import 'package:flowery_rider/features/order_tracking/domain/use_cases/update_order_state_use_case.dart';
import 'package:flowery_rider/core/services/location_service.dart';
import 'package:flowery_rider/features/order_tracking/presentation/order_details/view_model/intent/order_details_intent.dart';
import 'package:flowery_rider/features/order_tracking/domain/entities/order_status/order_details_status.dart';
import 'package:injectable/injectable.dart';
import 'dart:async';
import '../state/order_details_state.dart';

@injectable
class OrderDetailsCubit extends BaseCubit<OrderDetailsState, BaseEvent> {
  final UpdateOrderStateUseCase _updateOrderStateUseCase;
  final FirestoreOrderUseCase _firestoreOrderUseCase;
  final LocationService _locationService;
  StreamSubscription? _locationSubscription;
  StreamSubscription? _firestoreStatusSubscription;
  String? _currentOrderId;

  OrderDetailsCubit(
    this._updateOrderStateUseCase,
    this._firestoreOrderUseCase,
    this._locationService,
  ) : super(OrderDetailsState());

  void handleOrderDetailsIntent(OrderDetailsIntent intent) {
    switch (intent) {
      case UpdateOrderDetailsStatuesIntent():
        _advanceStatus();
        break;
    }
  }

  void initTracking(String orderId) {
    _currentOrderId = orderId;
    _locationSubscription = _locationService.getLocationStream()?.listen((
      position,
    ) {
      if (orderId.isEmpty) {
        _locationSubscription?.cancel();
        return;
      }
      if (_currentOrderId != null) {
        _firestoreOrderUseCase.updateLocation(
          _currentOrderId!,
          position.latitude,
          position.longitude,
        );
      }
    });

    _firestoreStatusSubscription = _firestoreOrderUseCase
        .getOrderStatusStream(orderId)
        .listen((status) async {
          if (status == 'completed') {
            _stopAndClearActiveOrder();
            await _updateOrderStateUseCase.call(
              orderId,
              const UpdateOrderStateRequest(state: OrderStateDto.completed),
            );
          }
        });
  }

  Future<void> _stopAndClearActiveOrder() async {
    _locationSubscription?.cancel();
    _firestoreStatusSubscription?.cancel();
    if (_currentOrderId != null) {
      await _updateOrderStateUseCase.call(
        _currentOrderId!,
        const UpdateOrderStateRequest(state: OrderStateDto.completed),
      );
    }
    emitEvent(DisplaySuccess('Order delivered successfully'));
    emitEvent(NavigateEvent(routeName: AppRouterPaths.kHomeView));
  }

  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    _firestoreStatusSubscription?.cancel();
    return super.close();
  }

  void _advanceStatus() async {
    final nextStatus = state.status.next;
    emit(state.copyWith(status: nextStatus));

    if (_currentOrderId != null) {
      await _firestoreOrderUseCase.updateStatus(
        _currentOrderId!,
        nextStatus.name,
      );
    }
  }
}
