import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pedometer/pedometer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class StepCounter extends StatefulWidget {
  const StepCounter({Key? key}) : super(key: key);
  @override
  StepCounterState createState() => StepCounterState();
}

class StepCounterState extends State<StepCounter> {
  static const int THRESHOLD = 1000;
  MethodChannel? _methodChannel;
  Stream<StepCount>? _stepCountStream;
  StreamSubscription<StepCount>? _stepCountSubscription;
  int _stepCount = 0;
  int _previousStepCount = -1;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initStepCount();
    _initPedometer();
    _requestPermissions();
    _startTimer();
    _methodChannel = MethodChannel('com.example.p3/brightness');
  }

  void _initStepCount() {
    Pedometer.stepCountStream.listen((StepCount event) {
      if (_previousStepCount == -1) {
        _previousStepCount = event.steps;
      }
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      if ((_stepCount - _previousStepCount).abs() > 3) {
        setState(() {
          _previousStepCount = _stepCount;
        });
      }
    });
  }

  Future<void> _requestPermissions() async {
    await _requestLocationPermission();
    await _requestActivityRecognitionPermission();
  }

  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        print('위치정보 권한 거부');
      }
    }
    print('위치정보 권한 허용');
  }

  Future<void> _requestActivityRecognitionPermission() async {
    if (await Permission.activityRecognition.request().isGranted) {
      print('신체활동 권한 허용');
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('권한 요청'),
          content: const Text('신체활동을 감지하기 위해서는 권한이 필요합니다.'),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('다시 요청'),
              onPressed: () {
                openAppSettings();
              },
            ),
            ElevatedButton(
              child: const Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  void _initPedometer() {
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream!.listen((StepCount event) {
      setState(() {
        _stepCount = event.steps;
      });
    });
  }

  void startPedometer() {
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountSubscription = _stepCountStream!.listen((StepCount event) {
      setState(() {
        _stepCount = event.steps;
      });
      if (_stepCount > THRESHOLD) {
        _methodChannel?.invokeMethod('showOverlay');
      }
    });
  }

  void stopPedometer() {
    _stepCountSubscription?.cancel();
    _stepCountSubscription = null;
  }

  @override
  void dispose() {
    stopPedometer();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StreamBuilder<StepCount>(
          stream: _stepCountStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('걸음 감지중입니다.');
            } else if (snapshot.hasError) {
              return const Text('오류가 검출되었습니다.');
            } else {
              StepCount? data = snapshot.data;
              if (data != null) {
                _stepCount = data.steps;
                if (_stepCount == _previousStepCount) {
                  print('가만');
                  print(_previousStepCount);
                  return const Text('걸음이 감지되지 않았습니다.');
                } else {
                  _previousStepCount = _stepCount;
                  print('걸음');
                  print(_stepCount);
                  return const Text('걸음이 인식되었습니다.');
                }
              } else {
                return const Text('걸음 감지중입니다.');
              }
            }
          },
        ),
      ),
    );
  }
}
