import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:publicdata/models/boat_model.dart';

class ApiService {
  static const String baseUrl =
      "http://apis.data.go.kr/1192000/select0230List/getselect0230List?serviceKey=9IZyKdl19TjST2Cjq0YYi8XwbV%2BGTCOD3DE2XdT%2BTGHY9akOskrVLU28bT8AlUpk8%2B%2BHg2zE5PP3BntcMsiM6Q%3D%3D&type=json";
  
  static const int numOfRows = 100;

  static const Map<String, Map<String, List<int>>> regionPages = {
    "부산": {
      "부산": [1, 2],
    },
    "인천": {
      "인천": [2, 4],
    },
    "울산": {
      "울산": [4, 4],
    },
    "경기도": {
      "평택시": [4, 5],
      "안산시": [5, 5],
      "시흥시": [5, 5],
      "화성시": [36, 36],
    },
    "강원도": {
      "강릉시": [5, 6],
      "동해시": [6, 6],
      "속초시": [6, 6],
      "삼척시": [6, 7],
      "고성군": [7, 8],
      "양양군": [8, 8],
    },
    "충청남도": {
      "보령시": [8, 10],
      "서산시": [10, 11],
      "서천군": [12, 12],
      "홍성군": [12, 12],
      "태안군": [12, 15],
      "당진": [38, 39],
    },
    "전라북도": {
      "군산시": [15, 17],
      "목포시": [17, 18],
    },
    "전라남도": {
      "여수시": [18, 20],
      "고흥시": [21, 22],
      "보성군": [22, 22],
      "강흥군": [22, 22],
      "강진군": [22, 23],
      "해남군": [23, 23],
      "영암군": [23, 23],
      "무안군": [23, 23],
      "함평군": [23, 23],
      "영광군": [23, 23],
      "완도군": [23, 24],
      "진도군": [24, 25],
      "신안군": [25, 25],
    },
    "경상북도": {
      "포항시": [25, 26],
      "경주시": [26, 26],
      "영덕군": [26, 26],
      "울진군": [26, 26],
      "울릉군": [26, 26],
    },
    "경상남도": {
      "통영시": [26, 29],
      "사천시": [29, 31],
      "거제시": [31, 34],
      "고성군": [34, 35],
      "남해군": [35, 36],
      "하동군": [36, 36],
      "창원시": [36, 38],
    },
    "제주특별자치도": {
      "제주시": [40, 41],
      "서귀포시": [41, 42],
    }
  };

  static Future<List<BoatModel>> getBoatsByRegion(String province, String city) async {
    List<BoatModel> boatInstances = [];
    if (!regionPages.containsKey(province) || !regionPages[province]!.containsKey(city)) {
      print('Invalid province or city');
      return boatInstances;
    }

    final range = regionPages[province]![city];
    final startPage = range![0];
    final endPage = range[1];

    List<Future> requests = [];

    for (int pageNo = startPage; pageNo <= endPage; pageNo++) {
      final url = Uri.parse('$baseUrl&pageNo=$pageNo&numOfRows=$numOfRows');
      requests.add(http.get(url));
    }

    List responses = await Future.wait(requests);

    for (var response in responses) {
      if (response.statusCode == 200) {
        try {
          Map<String, dynamic> decodedResponse =
              json.decode(response.body) as Map<String, dynamic>;

          if (decodedResponse['responseJson'] != null &&
              decodedResponse['responseJson']['body'] != null &&
              decodedResponse['responseJson']['body']['item'] != null) {
            List<dynamic> boatList = decodedResponse['responseJson']['body']
                ['item'] as List<dynamic>;

            for (var boat in boatList) {
              final instance = boat as Map<String, dynamic>;
              boatInstances.add(BoatModel.fromJson(instance));
            }
          } else {
            throw FormatException('Unexpected JSON format');
          }
        } catch (e) {
          print('Error parsing JSON for response: $e');
        }
      } else {
        print('Failed to load boats: ${response.statusCode}');
      }
    }

    return boatInstances;
  }
}
