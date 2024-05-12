import 'package:flutter/material.dart';
import 'firstscreen.dart'; // firstscreen.dart 파일을 임포트합니다.
import 'eye_protection_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'state_update.dart';
import 'package:pedometer/pedometer.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(
    MaterialApp(
      home: FirstScreen(),
    ),
  );
}
