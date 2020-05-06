import 'dart:async';

import 'package:flutter/services.dart';

typedef void OnReceiveSensor(double azimuth, double yaw, double pitch, double roll);

class AzimuthChannel {
  static final String channelName = "proj.net.lbstech.azimuth_event_channel";
  final EventChannel _channel = new EventChannel(channelName);

  StreamSubscription _subscription;

  void turnOn(OnReceiveSensor onReceiveSensor){
    if (_subscription != null) {
      print('스트림이 이미 활성화 되어 있습니다.');
      return;
    }
    _subscription = _channel.receiveBroadcastStream().listen((value){
      Map sensorValue = value;
      onReceiveSensor(
        sensorValue['azimuth'],
        sensorValue['yaw'],
        sensorValue['pitch'],
        sensorValue['roll'],
      );
    });
  }

  void resume(){
    if (_subscription == null){
      print('스트임이 활성화 되어 있지 않습니다.');
      return;
    }
    _subscription.resume();
  }

  void pause(){
    if (_subscription == null){
      print('스트임이 활성화 되어 있지 않습니다.');
      return;
    }
    _subscription.pause();
  }

  void turnOff(){
    if (_subscription == null){
      print('스트임이 활성화 되어 있지 않습니다.');
      return;
    }
    _subscription.cancel();
    _subscription = null;
  }
  
}