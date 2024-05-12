import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

// state_update.dart
// state_update.dart

// 버튼 상태 업데이트 전용 클래스
class ButtonStateUpdate {
  static final ButtonStateUpdate _singleton = ButtonStateUpdate._internal();

  factory ButtonStateUpdate() {
    return _singleton;
  }

  ButtonStateUpdate._internal();
  bool _isRunning = false;

  bool get isRunning => _isRunning;

  void toggleState() {
    _isRunning = !_isRunning;
  }
}

// 서비스 시작 및 중지 전용 클래스
class ServiceControl {
  static final ServiceControl _singleton = ServiceControl._internal();

  factory ServiceControl() {
    return _singleton;
  }

  ServiceControl._internal();
  static const platform = MethodChannel("com.example.p3/brightness");

  Future<void> checkServiceStatus() async {
    bool isRunning = await platform.invokeMethod('isServiceRunning');
    ButtonStateUpdate()._isRunning = isRunning; // _isRunning 상태를 업데이트합니다.
  }

  Future<void> toggleService() async {
    bool isRunning = await platform.invokeMethod('isServiceRunning');
    if (isRunning) {
      await platform.invokeMethod('stopService');
    } else {
      await platform.invokeMethod('startService');
    }
    ButtonStateUpdate()._isRunning = await platform.invokeMethod('isServiceRunning'); // 이 부분 추가
  }
}