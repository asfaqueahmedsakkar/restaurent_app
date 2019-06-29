
import 'package:flutter/material.dart';
import 'package:restaurent_app/FoodModel.dart';

class CartFoodWidget extends StatelessWidget {
  const CartFoodWidget({
    Key key,
    @required CartModel item,
    @required this.removeItem,
  })  : _item = item,
        super(key: key);

  final CartModel _item;
  final Function(CartModel item) removeItem;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: () => removeItem(_item),
            child: Image.asset(
              _item.foodModel.imageUrl,
              height: 100.0,
              width: 100.0,
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: EdgeInsets.only(left: 40.0),
            padding: EdgeInsets.all(8.0),
            child: Text(
              _item.count.toString(),
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.0),
            ),
            decoration: BoxDecoration(
                color: Colors.deepOrange,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4.0,
                  )
                ]),
          ),
        )
      ],
    );
  }
}