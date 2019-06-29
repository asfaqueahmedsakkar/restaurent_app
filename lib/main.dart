import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:restaurent_app/CartFood.dart';
import 'package:restaurent_app/DetailsSection.dart';
import 'package:restaurent_app/FoodImageSection.dart';
import 'package:restaurent_app/FoodModel.dart';
import 'package:restaurent_app/Storage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: ProductPage(),
    );
  }
}

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage>
    with SingleTickerProviderStateMixin {
  List<FoodModel> foods;
  PageController _pageController2;
  PageController _pageController1;
  PageController _pageController;
  PageController _pageController3;

  int currentPage = 0;
  double _topOffset = 8.0;
  double _lastTopOffset;
  AnimationController _animationController;
  Storage _storage;

  double frac = 0.6;

  GlobalKey _key;

  @override
  void initState() {
    super.initState();

    foods = new List();
    foods.add(FoodModel(
      id: 1,
      imageUrl: "images/Chicken_shawarma_bowl.png",
      name: "Chicken Shawarma Bowl",
      details: "sadhj asdjk asldkj ewoir nkajsdkh",
      price: 7.5,
    ));
    foods.add(FoodModel(
      id: 2,
      imageUrl: "images/donair_plate.png",
      name: "Donair Plate",
      details: "sadhj asdjk asd asdawr m vb sldkj ewoir nkajsdkh",
      price: 6.5,
    ));
    foods.add(FoodModel(
      id: 3,
      imageUrl: "images/Kid_Falafel.png",
      name: "Kid's Falafel",
      details: "sadhj asdjk aslsda dkj ewoir nkajsdkasd asd asdah",
      price: 9.5,
    ));
    foods.add(FoodModel(
      id: 4,
      imageUrl: "images/shawarma_plate.png",
      name: "Shawarma Plate",
      details: "sadhj asdjk asldkj ewoir nka asd sd jsdkh",
      price: 2.5,
    ));
    foods.add(FoodModel(
      id: 5,
      imageUrl: "images/shawarma_poutine.png",
      name: "Shawarma Poutine",
      details: "sadhj asdjk asldkj ewoir dsf sfasd asdnkajsdkh",
      price: 3.0,
    ));

    _pageController3 = new PageController(viewportFraction: 0.3);

    _pageController1 = new PageController(viewportFraction: frac);

    _pageController2 = new PageController(viewportFraction: frac);

    _pageController = new PageController(viewportFraction: frac);

    _pageController.addListener(() {
      _pageController1.jumpTo(_pageController.offset);
      _pageController2.jumpTo(_pageController.offset);
      _storage.enableAdd = false;
      if (_pageController.page == _pageController.page.round()) {
        setState(() {
          currentPage = _pageController.page.round();
          _storage.enableAdd = true;
        });
      }
    });

    _animationController = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.value = 0.0;
        if (_storage.toAdd != null)
          setState(() {
            _storage.addToCart();
          });
      }
    });

    _key = new GlobalKey();

    _storage = new Storage();
  }

  @override
  void dispose() {
    _pageController3.dispose();
    _pageController2.dispose();
    _pageController1.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
        title: Text("Food"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                child: Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        FoodImageSection(
                          foods: foods,
                          pageController: _pageController1,
                        ),
                        Expanded(
                          child: DetailsSection(
                            pageController: _pageController2,
                            foods: foods,
                          ),
                        ),
                      ],
                    ),
                    PageView.builder(
                      controller: _pageController,
                      itemBuilder: (context, index) => Container(),
                      itemCount: foods.length,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 70.0,
              ),
              Container(
                alignment: Alignment.center,
                height: 72.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4.0,
                    )
                  ],
                ),
                child: RawMaterialButton(
                  padding: EdgeInsets.symmetric(
                    horizontal: 32.0,
                    vertical: 12.0,
                  ),
                  onPressed: () {},
                  fillColor: Colors.yellow[800],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                  child: Text(
                    "ODER NOW",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12.0,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              )
            ],
          ),
          Positioned(
            bottom: 50.0,
            child: Container(
              key: _key,
              height: 100.0,
              width: 400.0,
              alignment: Alignment.center,
              child: PageView.builder(
                controller: _pageController3,
                itemBuilder: (context, index) {
                  if (index == _storage.cart.length) return SizedBox();
                  return CartFoodWidget(
                    item: _storage.cart[index],
                    removeItem: (CartModel item) {
                      setState(() {
                        _storage.remove(item);
                      });
                    },
                  );
                },
                itemCount: _storage.cart.length + 1,
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              if (_lastTopOffset == null) {
                final RenderBox renderBox =
                    _key.currentContext.findRenderObject();
                _lastTopOffset = _getLastPos(renderBox);
                print(_lastTopOffset);
              }
              return _animationController.value != 0 && _lastTopOffset != null
                  ? Transform.translate(
                      offset: Offset(
                        0.0,
                        lerpDouble(
                          _topOffset,
                          _lastTopOffset.abs() - 82,
                          _animationController.value,
                        ),
                      ),
                      child: Image.asset(
                        foods[currentPage].imageUrl,
                        width: 240.0 - 140 * _animationController.value,
                        height: 240.0 - 140 * _animationController.value,
                      ),
                    )
                  : SizedBox();
            },
          ),
          Positioned(
            bottom: 60.0,
            right: 16.0,
            child: RawMaterialButton(
              fillColor: Colors.yellow[800],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0)),
              constraints: BoxConstraints.tight(Size(48.0, 48.0)),
              onPressed: () {
                if (_storage.enableAdd) {
                  _storage.toAdd = foods[currentPage];
                  _animationController.forward();
                  int ind = _storage.getIndexOfToAdd();
                  //print("$currentPage  $ind");
                  _pageController3.animateToPage(
                      ind == -1 ? _storage.cart.length : ind,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.linear);
                }
              },
              child: Icon(
                Icons.add,
                size: 36.0,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _getLastPos(RenderBox renderBox) {
    try {
      return renderBox.globalToLocal(Offset.zero).dy;
    } catch (e) {
      return null;
    }
  }
}
