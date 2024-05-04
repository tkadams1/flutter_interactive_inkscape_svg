import 'package:flutter/material.dart';
import 'package:interactive_inkscape_svg/interactive_inkscape_svg.dart';
import 'package:flutter/cupertino.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> selectedPieces = ['rightEye', 'leftEye', 'nose', 'mouth'];
  String selectedValue = 'front';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String svgImageFront = 'assets/frontHeadV2.4.svg';
    String svgImageBack = 'assets/backHeadV1.svg';
    List<String> disabledPieces = [
      'rightEyebrow',
      'leftEyebrow',
      'leftEar',
      'rightEar'
    ];
    String svgImage = selectedValue == 'front' ? svgImageFront : svgImageBack;


    return Column(
      children: [
        InteractiveSVG(
          key: ValueKey(svgImage),
          svgImage: svgImage,
          disabledSvgPieces: disabledPieces,
        ),
        _buildFrontBackButton(),
      ],
    );
  }

  void _getSelectedPieces(List<String> selectedPieces) {
    setState(() {
      this.selectedPieces = selectedPieces;
    });
  }

  Widget _buildFrontBackButton() {
    return CupertinoSegmentedControl<String>(
      children: const {
        'front': Padding(
          padding: EdgeInsets.all(10.0),
          child: Text('Front'),
        ),
        'back': Padding(
          padding: EdgeInsets.all(10.0),
          child: Text('Back'),
        ),
      },
      onValueChanged: (String value) {
        setState(() {
          selectedValue = value;
        });
      },
      groupValue: selectedValue,
    );
  }
}
