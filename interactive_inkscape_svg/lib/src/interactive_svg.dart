import 'package:flutter/material.dart';
import './svg_parser.dart';
import './clipper.dart';

class InteractiveSVG extends StatefulWidget {
  
  final String svgImage;
  final List<String> disabledSvgPieces;
  final Function? onPieceSelected;
  
  final double height;
  final double width;
  final double maxInteractiveViewerScale;
  final double minInteractiveViewerScale;

  final Color selectedColor;
  //values for Clipper
  final double scaleX;
  final double scaleY;
  final double offsetX;
  final double offsetY;

  final Color outlineColor;
  final double outlineWidth;

  const InteractiveSVG(
      {super.key, 
      required this.svgImage,
      this.disabledSvgPieces = const [],
      this.onPieceSelected,
      this.height = 500.0, 
      this.width = 350.0,
      this.maxInteractiveViewerScale = 1.0,
      this.minInteractiveViewerScale = 1.0,
      this.selectedColor = Colors.red,
      this.scaleX = 1.8,
      this.scaleY = 1.8,
      this.offsetX = -20,
      this.offsetY = 0,
      this.outlineColor = Colors.black,
      this.outlineWidth = 2.0,
      });
  @override
  InteractiveSVGState createState() => InteractiveSVGState();
}

class InteractiveSVGState extends State<InteractiveSVG> {
  List<svgSegment> selectedSvgPieces = []; // changed to list
  List<svgSegment> svgPieces = [];

  @override
  void initState() {
    super.initState();
    //load the svg image and segment it into its various paths (parts)
    Future.microtask(() async {
    //load the svg image and segment it into its various paths (parts)
    svgPieces = await svgSegment.loadSvgImage(svgImage: widget.svgImage);
    // selectedSvgPieces.add(
    //     countries.firstWhere((element) => element.id == 'rightEyebrow'));
    setState(() {}); // Call setState to trigger a rebuild of the widget
  });
  }

  @override
  Widget build(BuildContext context) {
    //print(widget.countries.length);

    void onSVGPieceSelect(svgSegment svgPiece) {
      // Check if the cosvgPiece is disabled
      if (widget.disabledSvgPieces.contains(svgPiece.id)) {
        return;
      }
      setState(() {
        // Add or remove svgSegment from the list
        if (selectedSvgPieces.contains(svgPiece)) {
          selectedSvgPieces.remove(svgPiece);
        } else {
          selectedSvgPieces.add(svgPiece);
        }
        // Sends the list of selected countries to the parent widget
      if (widget.onPieceSelected != null) {
        widget.onPieceSelected!(selectedSvgPieces.map((e) => e.id).toList());
        return;
      }
        // Print all selected countries
        //selectedSvgPieces.forEach((svgPiece) => print(svgPiece.name));
      });
    }

    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          // Widget content goes here
          height: widget.height,
          width: widget.width,
          child: InteractiveViewer(
            maxScale: widget.maxInteractiveViewerScale,
            minScale: widget.minInteractiveViewerScale,
            child: Stack(
              children: [
                //loop through the svg parts and create a clipped image for each
                for (var svgPiece in svgPieces)
                  _getClippedImage(
                    clipper: Clipper(
                      svgPath: svgPiece.path,
                      scaleX: widget.scaleX,
                      scaleY: widget.scaleY,
                      offsetX: widget.offsetX,
                      offsetY: widget.offsetY,
                    ),
                    color: selectedSvgPieces.any(
                            (currentCountry) => currentCountry.id == svgPiece.id)
                        ? widget.selectedColor
                        : Color(int.parse(svgPiece.color.replaceAll("#", ""),
                                radix: 16))
                            .withOpacity(1),
                    svgPiece: svgPiece,
                    onSVGPieceSelect: onSVGPieceSelect,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _getClippedImage({
    required Clipper clipper,
    required Color color,
    required svgSegment svgPiece,
    final Function(svgSegment country)? onSVGPieceSelect,
  }) {
    return ClipPath(
      clipper: clipper,
      child: GestureDetector(
        onTap: () => onSVGPieceSelect?.call(svgPiece),
        child: CustomPaint(
          foregroundPainter: _OutlinePainter(
            color: widget.outlineColor,
            outlineWidth: widget.outlineWidth,
            clipper: clipper,
          ),
          child: Container(
            color: color,
          ),
        ),
      ),
    );
  }
}

class _OutlinePainter extends CustomPainter {
  final Clipper clipper;
  final Color color;
  final double outlineWidth;

  _OutlinePainter({
    required this.clipper, 
    required this.color,
    required this.outlineWidth,
    });

  @override
  void paint(Canvas canvas, Size size) {
    var path = clipper.getClip(size);
    var paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = outlineWidth; // adjust this value to change the outline thickness

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
