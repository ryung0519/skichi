import 'package:flutter/material.dart';
import 'pedometer_run.dart';

class PedometerScreen extends StatefulWidget {
  @override
  _PedometerScreenState createState() => _PedometerScreenState();
}

class _PedometerScreenState extends State<PedometerScreen> {
  bool _isRunning = false;
  final _stepCounterKey = GlobalKey<StepCounterState>();

  void walkstartService() {
    setState(() {
      _isRunning = !_isRunning;
      if (_isRunning) {
        _stepCounterKey.currentState?.startPedometer();
      } else {
        _stepCounterKey.currentState?.stopPedometer();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('걷기감지')),
      backgroundColor: Colors.lightBlue,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
              onPressed: walkstartService,
              child: Text(_isRunning ? '중지' : '시작'),
            ),
          ),
          if (_isRunning)
            Expanded(child: StepCounter(key: _stepCounterKey)),
        ],
      ),
    );
  }
}
