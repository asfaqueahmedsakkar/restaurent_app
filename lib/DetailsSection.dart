import 'package:flutter/material.dart';
import 'package:restaurent_app/FoodModel.dart';

class DetailsSection extends StatefulWidget {
  final PageController pageController;
  final List<FoodModel> foods;

  DetailsSection({
    @required this.pageController,
    @required this.foods,
  });

  @override
  _DetailsSectionState createState() => _DetailsSectionState();
}

class _DetailsSectionState extends State<DetailsSection> {
  int cp = 0;
  double page = 0.0;

  @override
  void initState() {
    super.initState();
    widget.pageController.addListener(() {
      setState(() {
        page = widget.pageController.page;
        if ((widget.pageController.page - widget.pageController.page.round())
                .abs() <
            0.05) {
          cp = widget.pageController.page.round();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Opacity(
          child: Transform.translate(
            child: _getDetails(widget.foods[cp]),
            offset: Offset(
              0.0 - 60.0 * (page - cp),
              0.0,
            ),
          ),
          opacity: 1.0 - (page - cp).abs().clamp(0.0, 1.0),
        ),
        Opacity(
          child: Transform.translate(
            child: _getDetails((page - cp) >= 0
                ? widget.foods[cp >= widget.foods.length - 1 ? cp : cp + 1]
                : widget.foods[cp <= 0 ? cp : cp - 1]),
            offset: Offset(
              (page - cp) > 0
                  ? 60.0 - 60.0 * (page - cp)
                  : -60.0 + 60.0 * (cp - page),
              0.0,
            ),
          ),
          opacity: (page - cp).abs().clamp(0.0, 1.0),
        ),
        PageView.builder(
          physics: NeverScrollableScrollPhysics(),
          controller: widget.pageController,
          itemBuilder: (context, index) {
            return Container(
              alignment: Alignment.center,
              color: Colors.transparent,
            );
          },
          itemCount: widget.foods.length,
        ),
      ],
    );
  }

  Padding _getDetails(FoodModel food) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Text(
                "${food.name}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.deepOrange,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "${food.details}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    wordSpacing: 2.0,
                    letterSpacing: 0.4,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _getColumn("15", "MIN"),
                _getColumn("12", "INGREDENT"),
                _getColumn("45", "KCAL"),
              ],
            )
          ],
        ),
      ),
    );
  }

  Column _getColumn(String number, String title) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          "$number",
          style: TextStyle(
              color: Colors.deepOrange,
              fontSize: 22.0,
              fontWeight: FontWeight.w800),
        ),
        Text(
          "$title",
          style: TextStyle(
              color: Colors.grey, fontSize: 12.0, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
