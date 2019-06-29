import 'package:flutter/material.dart';

class FoodModel {
  String name;
  String details;
  String imageUrl;
  double price;
  final int id;

  FoodModel({
    @required this.id,
    this.name = "sadghjh kjhadh",
    this.details =
        "sakjhdj kahjsdkh aksdjha aksjdh akjsdal asldjkhalk alsdklj asd",
    this.imageUrl,
    this.price = 8.5,
  });
}

class CartModel {
  int foodId;
  FoodModel foodModel;
  int count = 1;
}
