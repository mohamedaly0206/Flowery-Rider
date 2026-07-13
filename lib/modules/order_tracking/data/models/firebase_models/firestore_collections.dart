abstract final class FirestoreCollections {
  static const orders = 'orders';
}

abstract final class FirestoreFields {
  static const status = 'status';
  static const driverId = 'driverId';
  static const driverName = 'driverName';
  static const driverPhone = 'driverPhone';
  static const driverLocation = 'driverLocation';
  static const updatedAt = 'updatedAt';
  static const orderDetails = 'orderDetails';
}

abstract final class FirestoreOrderStatus {
  static const accepted = 'accepted';
  static const picked = 'picked';
  static const outForDelivery = 'outForDelivery';
  static const arrived = 'arrived';
  static const completed = 'completed';
  static const inProgress = 'inProgress';
  static const delivered = 'delivered';

  static const activeStatuses = [
    accepted,
    picked,
    outForDelivery,
    arrived,
    delivered,
    inProgress,
  ];
}
