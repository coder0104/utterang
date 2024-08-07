import 'package:flutter/material.dart';
import 'package:publicdata/models/boat_model.dart';
import 'package:publicdata/services/api_service.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedProvince = '부산';
  String selectedCity = '부산';
  List<BoatModel> boats = [];
  bool isLoading = false;
  int maxPerson = 8;

  final Map<String, List<String>> provinceCities = {
    '부산': ['부산'],
    '인천': ['인천'],
    '울산': ['울산'],
    '경기도': ['평택시', '안산시', '시흥시', '화성시'],
    '강원도': ['강릉시', '동해시', '속초시', '삼척시', '고성군', '양양군'],
    '충청남도': ['보령시', '서산시', '서천군', '홍성군', '태안군', '당진'],
    '전라북도': ['군산시', '목포시'],
    '전라남도': ['여수시', '고흥시', '보성군', '강흥군', '강진군', '해남군', '영암군', '무안군', '함평군', '영광군', '완도군', '진도군', '신안군'],
    '경상북도': ['포항시', '경주시', '영덕군', '울진군', '울릉군'],
    '경상남도': ['통영시', '사천시', '거제시', '고성군', '남해군', '하동군', '창원시'],
    '제주특별자치도': ['제주시', '서귀포시'],
  };

  void fetchBoats() async {
    setState(() {
      isLoading = true;
    });

    List<BoatModel> allBoats = await ApiService.getBoatsByRegion(selectedProvince, selectedCity);

    // maxPerson 값을 기준으로 필터링
    boats = allBoats.where((boat) {
      return boat.maxperson <= maxPerson;
    }).toList();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        foregroundColor: Color.fromARGB(255, 68, 183, 255),
        title: Text(
          '어터티켓',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: selectedProvince,
              onChanged: (String? newValue) {
                setState(() {
                  selectedProvince = newValue!;
                  selectedCity = provinceCities[selectedProvince]!.first;
                });
              },
              items: provinceCities.keys.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            DropdownButton<String>(
              value: selectedCity,
              onChanged: (String? newValue) {
                setState(() {
                  selectedCity = newValue!;
                });
              },
              items: provinceCities[selectedProvince]!.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            Slider(
              value: maxPerson.toDouble(),
              min: 0,
              max: 100,
              divisions: 100,
              label: maxPerson.toString(),
              onChanged: (double value) {
                setState(() {
                  maxPerson = value.toInt();
                });
              },
            ),
            Text('Max Person: $maxPerson'),
            ElevatedButton(
              onPressed: isLoading ? null : fetchBoats,
              child: Text(isLoading ? 'Loading...' : 'Fetch Boats'),
            ),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : boats.isEmpty
                      ? Center(child: Text('검색결과가 없습니다'))
                      : ListView.separated(
                          scrollDirection: Axis.vertical,
                          itemCount: boats.length,
                          itemBuilder: (context, index) {
                            var boat = boats[index];
                            return ListTile(
                              title: Text(boat.boatname),
                              subtitle: Text('Location: ${boat.boatloca}, Max Person: ${boat.maxperson}'),
                            );
                          },
                          separatorBuilder: (context, index) => SizedBox(height: 10),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
