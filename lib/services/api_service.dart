import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

class AppService {
  final String baseUrl =
      "http://apis.data.go.kr/1192000/select0230List/getselect0230List?serviceKey=9IZyKdl19TjST2Cjq0YYi8XwbV%2BGTCOD3DE2XdT%2BTGHY9akOskrVLU28bT8AlUpk8%2B%2BHg2zE5PP3BntcMsiM6Q%3D%3D&pageNo=20&numOfRows=100";

  Future<void> getTodayBoats() async {
    final url = Uri.parse(baseUrl);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      try {
        final responseBody = utf8.decode(response.bodyBytes);
        final document = xml.XmlDocument.parse(responseBody);
        
        print(document.toXmlString(pretty: true)); 
        
      } catch (e) {
        print("Failed to parse XML: $e");
      }
    } else {
      print("Request failed with status: ${response.statusCode}");
    }
  }
}
