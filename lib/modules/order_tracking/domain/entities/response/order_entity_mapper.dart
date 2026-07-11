import 'package:flowery_rider/modules/order_tracking/data/models/response/order_dto.dart';
import 'package:flowery_rider/modules/order_tracking/data/models/response/order_item_dto.dart';
import 'package:flowery_rider/modules/order_tracking/data/models/response/product_dto.dart';
import 'package:flowery_rider/modules/order_tracking/data/models/response/shipping_address_dto.dart';
import 'package:flowery_rider/modules/order_tracking/data/models/response/store_dto.dart';
import 'package:flowery_rider/modules/order_tracking/data/models/response/user_dto.dart';
import 'package:flowery_rider/modules/order_tracking/domain/entities/response/order_entity.dart';
import 'package:flowery_rider/modules/order_tracking/domain/entities/response/order_item_entity.dart';
import 'package:flowery_rider/modules/order_tracking/domain/entities/response/product_entity.dart';
import 'package:flowery_rider/modules/order_tracking/domain/entities/response/shipping_address_entity.dart';
import 'package:flowery_rider/modules/order_tracking/domain/entities/response/store_entity.dart';
import 'package:flowery_rider/modules/order_tracking/domain/entities/response/user_entity.dart';

extension OrderEntityMapper on OrderEntity {
  OrderDto toDto() => OrderDto(
    id: id,
    user: user?.toDto(),
    orderItems: orderItems?.map((e) => e.toDto()).toList(),
    totalPrice: totalPrice,
    paymentType: paymentType,
    state: state,
    createdAt: createdAt,
    updatedAt: updatedAt,
    orderNumber: orderNumber,
    store: store?.toDto(),
    shippingAddress: shippingAddress?.toDto(),
  );
}

extension UserEntityMapper on UserEntity {
  UserDto toDto() => UserDto(
    id: id,
    firstName: firstName,
    lastName: lastName,
    email: email,
    gender: gender,
    phone: phone,
    photo: photo,
    passwordChangedAt: passwordChangedAt,
  );
}

extension OrderItemEntityMapper on OrderItemEntity {
  OrderItemDto toDto() => OrderItemDto(
    product: product?.toDto(),
    price: price,
    quantity: quantity,
    id: id,
  );
}

extension ProductEntityMapper on ProductEntity {
  ProductDto toDto() =>
      ProductDto(id: id, title: title, imgCover: imgCover, quantity: quantity);
}

extension StoreEntityMapper on StoreEntity {
  StoreDto toDto() => StoreDto(
    name: name,
    image: image,
    address: address,
    phoneNumber: phoneNumber,
    latLong: latLong,
  );
}

extension ShippingAddressEntityMapper on ShippingAddressEntity {
  ShippingAddressDto toDto() => ShippingAddressDto(
    street: street,
    city: city,
    phone: phone,
    lat: lat,
    long: long,
  );
}
