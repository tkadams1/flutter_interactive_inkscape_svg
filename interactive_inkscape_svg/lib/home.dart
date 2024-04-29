import 'package:flutter/material.dart';
import 'package:interactive_inkscape_svg/base.dart';
import 'package:interactive_inkscape_svg/clipper.dart';

class Home extends StatefulWidget {
  final List<Country> countries;

  const Home({Key? key, required this.countries}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Country> currentCountries = []; // changed to list

  @override
  void initState() {
    super.initState();
    currentCountries.add(widget.countries.firstWhere((element) => element.id == 'rightEyebrow'));
  }

  @override
  Widget build(BuildContext context) {
    print(widget.countries.length);

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
          height: 500,
          width: 350,
          child: InteractiveViewer(
            maxScale: 1,
            minScale: 1,
            child: Stack(
              children: [
                for (var country in widget.countries)
                  _getClippedImage(
                    clipper: Clipper(
                      svgPath: country.path,
                    ),
                    color: currentCountries.any((currentCountry) => currentCountry.id == country.id)
                          ? Colors.red
                          : Color(int.parse(country.color.replaceAll("#", ""), radix: 16)).withOpacity(1),
                           
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
          color: Colors.black,
          clipper: clipper,),
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

  _OutlinePainter({required this.clipper, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    var path = clipper.getClip(size);
    var paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0; // adjust this value to change the outline thickness

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
