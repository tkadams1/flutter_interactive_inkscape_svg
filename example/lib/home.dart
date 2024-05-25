import 'package:flutter/material.dart';
import 'package:interactive_inkscape_svg/interactive_inkscape_svg.dart';
import 'package:flutter/cupertino.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> selectedFrontPieces = [];
  List<String> selectedBackPieces = [];
  List<String> selectedPieces = [];
  String selectedValue = 'front';
  Future<List<String>>? test;
  String svgImageFront = 'assets/frontHeadV3.1.svg';
  String svgImageBack = 'assets/backHeadV1.svg';
  List<String> frontPieces = [];
  List<String> backPieces = [];

  @override
  void initState() {
    super.initState();

    //These functions are used to get the names of the paths in the SVG file before the widget is built
    svgSegment.getSvgPathNames(svgImageFront).then((value) {
    setState(() {
      frontPieces = value;
    });
    print(frontPieces);
  });

   svgSegment.getSvgPathNames(svgImageBack).then((value) {
    setState(() {
      backPieces = value;
    });
    print(backPieces);
  });
  }

  @override
  Widget build(BuildContext context) {
    List<String> disabledPieces = [
      'rightEyebrow',
      'leftEyebrow',
      'leftEar',
      'rightEar',
      'innerRightEar',
      'innerLeftEar',
      'noseBridge',
    ];
    String svgImage = selectedValue == 'front' ? svgImageFront : svgImageBack;

    const scaleMultiplier = 1.6;
    const originalHeight = 255.0;
    const originalWidth = 215.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InteractiveSVG(
          containerDecoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 2.0,
            ),
          ),
          key: ValueKey(svgImage),
          svgImage: svgImage,
          enabledSvgPieces: selectedValue == 'front'
              ? selectedFrontPieces
              : selectedBackPieces,
          disabledSvgPieces: disabledPieces,
          onPieceSelected: _getSelectedPieces,
          height: originalHeight,
          width: originalWidth,
          scaleMultiplier: scaleMultiplier,
          offsetX: 0,
        ),
        _buildFrontBackButton(),
      ],
    );
  }

  void _getSelectedPieces(List<String> selectedPieces) {
    if (selectedValue == 'front') {
      selectedFrontPieces = selectedPieces;
    } else {
      selectedBackPieces = selectedPieces;
    }
    selectedPieces = selectedFrontPieces + selectedBackPieces;
    setState(() {});
    print(selectedPieces);
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
