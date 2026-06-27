import 'package:flowery_rider/l10n/app_localizations.dart';

enum OrderDetailsStatus { accepted, picked, outForDelivery, arrived, delivered }

extension OrderDetailsStatusX on OrderDetailsStatus {
  String label(AppLocalizations l10n) {
    switch (this) {
      case OrderDetailsStatus.accepted:
        return l10n.accepted;
      case OrderDetailsStatus.picked:
        return l10n.picked;
      case OrderDetailsStatus.outForDelivery:
        return l10n.outForDelivery;
      case OrderDetailsStatus.arrived:
        return l10n.arrived;
      case OrderDetailsStatus.delivered:
        return l10n.delivered;
    }
  }
  int get completedSteps {
    switch (this) {
      case OrderDetailsStatus.accepted:
        return 1;
      case OrderDetailsStatus.picked:
        return 2;
      case OrderDetailsStatus.outForDelivery:
        return 3;
      case OrderDetailsStatus.arrived:
        return 4;
      case OrderDetailsStatus.delivered:
        return 5;
    }
  }

   String actionLabel(AppLocalizations l10n) {
    switch (this) {
      case OrderDetailsStatus.accepted:
        return l10n.arrivedAtPickupPoint;
      case OrderDetailsStatus.picked:
        return l10n.startDeliver;
      case OrderDetailsStatus.outForDelivery:
        return l10n.arrivedToUser;
      case OrderDetailsStatus.arrived:
      case OrderDetailsStatus.delivered:
        return l10n.deliveredToUser;
    }
  }


  bool get isDelivered => this == OrderDetailsStatus.delivered;

  OrderDetailsStatus get next {
    switch (this) {
      case OrderDetailsStatus.accepted:
        return OrderDetailsStatus.picked;
      case OrderDetailsStatus.picked:
        return OrderDetailsStatus.outForDelivery;
      case OrderDetailsStatus.outForDelivery:
        return OrderDetailsStatus.arrived;
      case OrderDetailsStatus.arrived:
      case OrderDetailsStatus.delivered:
        return OrderDetailsStatus.delivered;
    }
  }
}
