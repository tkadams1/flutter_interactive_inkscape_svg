import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

class Clipper extends CustomClipper<Path> {
  String svgPath;
  double scaleX;
  double scaleY;
  double offsetX;
  double offsetY;

  Clipper({
    required this.svgPath,
    this.scaleX = 1.8,
    this.scaleY = 1.8,
    this.offsetX = 0,
    this.offsetY = 0,
  });

  @override
  Path getClip(Size size) {
    var path = parseSvgPathData(svgPath);
    final Matrix4 matrix4 = Matrix4.identity();

    matrix4.scale(scaleX, scaleY);

    return path.transform(matrix4.storage).shift(Offset(offsetX, offsetY));
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }
}
