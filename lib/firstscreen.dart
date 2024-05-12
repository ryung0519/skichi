// firstscreen.dart
import 'package:flutter/material.dart';
import 'pedometer_screen.dart';
import 'eye_protection_screen.dart'; // eye_protection_screen.dart 파일을 임포트합니다.
import 'main.dart';

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '환영합니다',
              style: TextStyle(fontSize: 24),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EyeProtectionScreen(), // 여기를 EyeProtectionScreen으로 변경합니다.
                  ),
                );
              },
              child: Text('눈 보호'),
            ),
            ElevatedButton(  // 추가된 버튼
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PedometerScreen(), // Pedometer_Screen으로 이동합니다.
                  ),
                );
              },
              child: Text('걸음 수 측정'), // 버튼의 텍스트입니다.
            ),
          ],
        ),
      ),
    );
  }
}
