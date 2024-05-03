import 'package:flutter/material.dart';
import './svg_parser.dart';
import './clipper.dart';

class InteractiveSVG extends StatefulWidget {
  
  final String svgImage;
  
  
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
  List<Country> currentCountries = []; // changed to list
  List<Country> countries = [];

  @override
  void initState() {
    super.initState();
    //load the svg image and segment it into its various paths (parts)
    Future.microtask(() async {
    //load the svg image and segment it into its various paths (parts)
    countries = await Country.loadSvgImage(svgImage: widget.svgImage);
    currentCountries.add(
        countries.firstWhere((element) => element.id == 'rightEyebrow'));
    setState(() {}); // Call setState to trigger a rebuild of the widget
  });
  }

  @override
  Widget build(BuildContext context) {
    //print(widget.countries.length);

    void onCountrySelected(Country country) {
      setState(() {
        // Add or remove country from the list
        if (currentCountries.contains(country)) {
          currentCountries.remove(country);
        } else {
          currentCountries.add(country);
        }
        // Print all selected countries
        currentCountries.forEach((country) => print(country.name));
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
                for (var country in countries)
                  _getClippedImage(
                    clipper: Clipper(
                      svgPath: country.path,
                      scaleX: widget.scaleX,
                      scaleY: widget.scaleY,
                      offsetX: widget.offsetX,
                      offsetY: widget.offsetY,
                    ),
                    color: currentCountries.any(
                            (currentCountry) => currentCountry.id == country.id)
                        ? widget.selectedColor
                        : Color(int.parse(country.color.replaceAll("#", ""),
                                radix: 16))
                            .withOpacity(1),
                    country: country,
                    onCountrySelected: onCountrySelected,
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
    required Country country,
    final Function(Country country)? onCountrySelected,
  }) {
    return ClipPath(
      clipper: clipper,
      child: GestureDetector(
        onTap: () => onCountrySelected?.call(country),
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
