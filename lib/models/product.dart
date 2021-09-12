import 'package:flutter/cupertino.dart';

class Bill {
  final String? id;
  final String? name;
  final String? mobileNUmber;
  final String? address;
  final String? receivedby;

  final double? total;
  final double? advance;

  final double? balnce;
  final String? paymentMethode;
  final DateTime? delivaryDate;
  final List<Product>? products;
  Bill({
    @required this.id,
    @required this.name,
    @required this.mobileNUmber,
    @required this.address,
    @required this.receivedby,
    @required this.products,
    @required this.total,
    @required this.advance,
    @required this.balnce,
    @required this.paymentMethode,
    @required this.delivaryDate,
  });
}

class Product {
  final String? itemName;
  final String? specifications;
  final int? quantity;
  final double? price;
  final double? gst;
  bool isFinished;

  Product({
    this.itemName,
    this.specifications,
    this.quantity,
    this.price,
    this.gst,
    this.isFinished = false,
  });
}

class Item {
  final String? name;
  final String? discrption;
  Item(
    this.name,
    this.discrption,
  );
}
