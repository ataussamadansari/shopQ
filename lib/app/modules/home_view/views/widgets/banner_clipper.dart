import 'package:flutter/material.dart';

class BannerClipper extends CustomClipper<Path> {
  @override
  Path getPath(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 40);
    // Creates the deep curve that makes the banner look "dipped"
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 40);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
  @override
  bool shouldRebuild(CustomClipper<Path> oldClipper) => false;

  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    throw UnimplementedError();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    throw UnimplementedError();
  }
}