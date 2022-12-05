library five_pointed_star;

import 'dart:math';

import 'package:flutter/material.dart';

class FivePointedStar extends StatefulWidget {
  int count;
  double gap;
  Size size;
  Color color;
  Color selectedColor;
  int defaultSelectedCount;
  void Function(int count)? onChange;
  FivePointedStar(
      {Key? key,
      this.count = 5,
      this.gap = 4,
      this.size = const Size(24, 24),
      this.color = const Color.fromRGBO(200, 200, 200, 1),
      this.selectedColor = const Color.fromRGBO(255, 96, 10, 1),
      this.defaultSelectedCount = 0,
      this.onChange})
      : super(key: key);
  @override
  State<FivePointedStar> createState() => _FivePointedStarState();
}

class _FivePointedStarState extends State<FivePointedStar> {
  late List<Widget> _list;
  late int selectedNumber = 0;
  resetStar(int selectedNumber) {
    setState(() {
      _list = [];
      var list = List.generate(
          widget.count,
          (index) => GestureDetector(
                onTap: () {
                  setState(() {
                    selectedNumber = index + 1;
                    resetStar(selectedNumber);
                    if (widget.onChange != null) {
                      widget.onChange!(selectedNumber);
                    }
                  });
                },
                child: Container(
                    height: widget.size.height,
                    width: widget.size.width,
                    child: CustomPaint(
                        painter: FivePointedStarPainter(
                            color: index < selectedNumber
                                ? widget.selectedColor
                                : widget.color),
                        size: widget.size)),
              ));
      list.forEach((item) {
        _list.add(item);
        _list.add(SizedBox(
          width: widget.gap,
        ));
      });
      _list.removeLast();
    });
  }

  @override
  void initState() {
    super.initState();
    resetStar(widget.defaultSelectedCount);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(children: _list),
    );
  }
}

class FivePointedStarPainter extends CustomPainter {
  PaintingStyle paintingStyle;
  Color color;
  FivePointedStarPainter(
      {this.paintingStyle = PaintingStyle.fill, this.color = Colors.red});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = paintingStyle;
    final rect = Offset.zero & size;
    return canvas.drawPath(getPentagramPath(size.width / 2), paint);
  }

  Path getPentagramPath(double radius) {
    var initDegreen = 180;
    final path = Path();
    var posOne = getOffsetPosition(initDegreen, radius);
    var posTwo = getOffsetPosition(72 + initDegreen, radius);
    var posThree = getOffsetPosition(144 + initDegreen, radius);
    var posfour = getOffsetPosition(216 + initDegreen, radius);
    var posFive = getOffsetPosition(288 + initDegreen, radius);
    path.moveTo(posOne.dx, posOne.dy);
    path.lineTo(posfour.dx, posfour.dy);
    path.lineTo(posTwo.dx, posTwo.dy);
    path.lineTo(posFive.dx, posFive.dy);
    path.lineTo(posThree.dx, posThree.dy);
    path.close();
    return path;
  }

  Offset getOffsetPosition(int degreen, double radius) {
    var middle = degreen * pi / 180;
    var dx = sin(middle) * radius;
    var dy = cos(middle) * radius;
    return Offset(dx + radius, dy + radius);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
