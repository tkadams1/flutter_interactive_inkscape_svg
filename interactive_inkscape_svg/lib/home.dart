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
  var currentCountry;

  @override
  void initState() {
    super.initState();
    var currentCountry =widget.countries.firstWhere((element) => element.id == 'rightEyebrow');
  }

  @override
  Widget build(BuildContext context) {
    print(widget.countries.length);

    void onCountrySelected(Country country) {
      setState(() {
        currentCountry = country;
        print(currentCountry.name);
      });
    }

    return Container(
      alignment: Alignment.center,
      // Widget content goes here
      height: 500,
      width: 350,
      child: InteractiveViewer(
        maxScale: 5,
        minScale: 0.5,
        child: Stack(
          children: [
            for (var country in widget.countries)
              _getClippedImage(
                clipper: Clipper(
                  svgPath: country.path,
                ),
                color: Color(int.parse('FF${country.color}', radix: 16))
                    .withOpacity(currentCountry == null
                        ? 0.3
                        : currentCountry.id == country.id
                            ? 1.0
                            : 0.3),
                country: country,
                onCountrySelected: onCountrySelected,
              ),
          ],
        ),
      ),
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
        child: Container(
          color: color,
        ),
      ),
    );
  }
}
