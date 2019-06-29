import 'package:restaurent_app/FoodModel.dart';

class Storage {
  List<CartModel> cart = new List();

  FoodModel toAdd;

  bool enableAdd = true;

  void addToCart() {
    int ind = getIndexOfToAdd();
    if (ind != -1) {
      cart[ind].count++;
    } else {
      cart.add(
        CartModel()
          ..foodModel = toAdd
          ..foodId = toAdd.id,
      );
    }
    toAdd = null;
  }

  int getIndexOfToAdd({int id}) {
    id = id ?? toAdd.id;
    int ind = -1;
    for (CartModel food in cart) {
      ind++;
      if (food.foodId == id) return ind++;
    }
    return -1;
  }

  void remove(CartModel item) {
    int ind = getIndexOfToAdd(id: item.foodId);
    if (cart[ind].count == 1) {
      cart.removeAt(ind);
    } else
      cart[ind].count--;
  }
}
