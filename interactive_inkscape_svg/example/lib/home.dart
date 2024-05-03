import 'package:flutter/material.dart';
import 'package:interactive_inkscape_svg/interactive_inkscape_svg.dart';

class Home extends StatefulWidget {
  
  const Home({Key? key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String svgImage = 'assets/frontHeadV2.4.svg';
    return Column(
      children: [
        InteractiveSVG(svgImage: svgImage),
      ],
    );
  }

}
