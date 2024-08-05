import 'package:flutter/material.dart';
import 'package:publicdata/screens/home_screen.dart';
import 'package:publicdata/services/api_service.dart';

void main() async {
  // Flutter 위젯 바인딩 초기화
  WidgetsFlutterBinding.ensureInitialized();

  // AppService 인스턴스를 생성합니다.
  final appService = AppService();
  await appService.getTodayBoats(); // 비동기 작업이 완료될 때까지 기다립니다.

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}
