import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'main.dart';
import 'firstscreen.dart';
import 'state_update.dart';  // StateUpdate 클래스가 정의된 파일을 import합니다.

//eye_protection_screen.dart
class EyeProtectionScreen extends StatefulWidget {
  @override
  _EyeProtectionScreenState createState() => _EyeProtectionScreenState();
}

class _EyeProtectionScreenState extends State<EyeProtectionScreen> with WidgetsBindingObserver {
  ServiceControl serviceControl = ServiceControl();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initServiceStatus();
  }

  Future<void> initServiceStatus() async {
    await serviceControl.checkServiceStatus();
    setState(() {});  // 상태 변경 후 화면을 갱신합니다.
  }


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      // 앱이 활성 상태로 돌아올 때마다 서비스의 상태를 체크합니다.
      await serviceControl.checkServiceStatus();
      setState(() {});  // 상태 변경 후 화면을 갱신합니다.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('눈 보호 설정'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await serviceControl.toggleService();
            setState(() {});
          },
          child: Text(ButtonStateUpdate().isRunning ? 'Stop' : 'Start'),
        ),
      ),
    );
  }
}
