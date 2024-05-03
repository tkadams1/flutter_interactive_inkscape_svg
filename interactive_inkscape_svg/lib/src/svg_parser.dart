import 'package:flutter/services.dart';
import 'package:xml/xml.dart';

class svgSegment {
  final String id;
  final String path;
  String color;
  final String name;

  svgSegment(
      {required this.id,
      required this.path,
      required this.color,
      required this.name});

  static Future<List<svgSegment>> loadSvgImage({required String svgImage}) async {
    List<svgSegment> maps = [];
    String generalString = await rootBundle.loadString(svgImage);

    XmlDocument document = XmlDocument.parse(generalString);

    final paths = document.findAllElements('path');

    for (var element in paths) {
      String partId = element.getAttribute('id').toString();
      print(partId);
      String partPath = element.getAttribute('d').toString();
      print(partPath);
      String name = partId;
      String color = getFillColor(element);

      maps.add(svgSegment(id: partId, path: partPath, color: color, name: name));
    }

    return maps;
  }

  static String getFillColor(XmlElement element) {
    String defaultColor = '552200';
    String color = defaultColor;
    String? style = element.getAttribute('style');
    if (style != null) {
      List<String> properties = style.split(';');
      for (var property in properties) {
        List<String> nameValue = property.split(':');
        if (nameValue.length == 2 && nameValue[0].trim() == 'fill') {
          color = nameValue[1].trim();
          break;
        }
      }
    }
    return color;
  }
}
