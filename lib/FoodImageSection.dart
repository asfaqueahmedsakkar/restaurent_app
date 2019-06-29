import 'package:flutter/material.dart';
import 'package:restaurent_app/FoodModel.dart';
import 'dart:ui';
import 'dart:math';

class FoodImageSection extends StatefulWidget {
  final List<FoodModel> foods;
  final PageController pageController;

  const FoodImageSection({
    Key key,
    @required this.foods,
    @required this.pageController,
  }) : super(key: key);

  @override
  _FoodImageSectionState createState() => _FoodImageSectionState();
}

class _FoodImageSectionState extends State<FoodImageSection> {
  PageController _pageController;
  int cp = 0;

  @override
  void initState() {
    _pageController = widget.pageController;
    _pageController.addListener(() {
      setState(() {
        if ((_pageController.page - _pageController.page.round()).abs() < 0.05)
          cp = _pageController.page.round();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          alignment: Alignment.topCenter,
          child: CustomPaint(
            painter: _CustomPainterOrange(),
            child: Container(
              height: 220.0,
              child: Stack(
                children: <Widget>[
                  PageView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          top: 32.0 -
                              32.0 * (index - _getPage()).abs().clamp(0.0, 1.0),
                          bottom: 4.0,
                        ),
                        child: Transform.rotate(
                          angle:
                           pi * (index - _getPage()).clamp(-1.0, 1.0),
                          child: Transform.scale(
                            scale: 1.25 -
                                (index - _getPage()).abs().clamp(0.0, 1.0) *
                                    0.4,
                            child: Image.asset(
                              widget.foods[index].imageUrl,
                              width: 200.0,
                              height: 200.0,
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: widget.foods.length,
                  ),
                  _priceSection(
                    price: _getPage() < cp
                        ? lerpDouble(
                      widget.foods[cp].price,
                      widget.foods[_getPage().floor()].price,
                      cp - _getPage(),
                    )
                        : lerpDouble(
                      widget.foods[cp].price,
                      widget.foods[_getPage().ceil()].price,
                      _getPage() - cp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  double _getPage() {
    try {
      return _pageController.page;
    } catch (e) {
      return 0.0;
    }
  }

  Widget _priceSection({double price}) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0, right: 32.0),
        child: Container(
          alignment: Alignment.center,
          height: 64.0,
          width: 64.0,
          decoration: BoxDecoration(
              color: Colors.yellow[800],
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(1.0, 2.0),
                  blurRadius: 2.0,
                )
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "${price.toStringAsFixed(1)}",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.0,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                "\$",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomPainterOrange extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path _path = new Path()
      ..moveTo(0.0, 0.0)
      ..lineTo(size.width, 0.0)
      ..lineTo(size.width, size.height / 2)
      ..cubicTo(
        size.width,
        size.height / 2,
        size.width / 2,
        size.height,
        0.0,
        size.height / 2,
      )
      ..close();

    Paint _paint = new Paint()..color = Colors.deepOrange;

    canvas.drawPath(_path, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}