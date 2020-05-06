import 'dart:async';
import 'dart:io';

import 'package:save_as/channel/ch_azimuth.dart';
import 'package:save_as/channel/ch_main.dart';
import 'package:save_as/channel/ch_permission.dart';
import 'package:save_as/main.dart';

class ChannelTest {

  void start() async{
    // permission test ...
    await _testPermissionChannel();

    // main channel test...
    await _testMainChannel();

    // Azimuth channel test...
    await _testAzimuthChannel();
  }


  Future<void> _testPermissionChannel() async{
    PermissionChannel permissionChannel = new PermissionChannel();

    await permissionChannel.checkState().then((boolean){
      assert(boolean is bool);
      print('PermissionChannel - checkState >> return - $boolean\n');
    });

    await permissionChannel.requestPermission().then((boolean){
      assert(boolean is bool);
      print('PermissionChannel - requestPermission >> return - $boolean\n');
    });
  }

  Future<void> _testMainChannel() async{
    MainChannel mainChannel = new MainChannel();

    await mainChannel.getInformation().then((map){
      assert(map != null);
      assert(map.containsKey('osType') && map.containsKey('version'));
      assert(map['osType'] is String);
      assert(map['version'] is int);

      print('MainChannel - getInformation \n>> return - $map\n');
    });

    await mainChannel.getLocation().then((map) {
      assert(map != null);
      assert(map.containsKey('latitude') && map.containsKey('longitude'));
      assert(map['latitude'] is double && map['longitude'] is double);

      print('MainChannel - getLocation \n>> return - $map\n');
    });

    await mainChannel.getConnectionState().then((boolean){
      assert(boolean is bool);

      print('MainChannel - getConnectionState >> return - $boolean\n');
    });

    await mainChannel.getTempDirectory().then((dir){
      assert(dir != null && dir is Directory);
      print('MainChannel - getTempDirectory \n>> return - ${dir.path}\n');
    });

    await mainChannel.getPublicDirectory().then((dir){
      assert(dir != null && dir is Directory);
      print('MainChannel - getPublicDirectory \n>> return - ${dir.path}\n');
    });

    mainChannel.keyEventOn((value){
      print('MainChannel - keyEventChannel >> value - $value\n');
      mainChannel.keyEventOff();
    });

  }

  Future<void> _testAzimuthChannel() async{
    AzimuthChannel azimuthChannel = new AzimuthChannel();

    azimuthChannel.turnOn((azimuth, yaw, pitch, roll){
      print('AzimuthChannel - AzimuthEventChannel \n'
          '>> value - Azimuth : $azimuth, Yaw : $yaw, Pitch : $pitch, Roll : $roll\n');
      azimuthChannel.turnOff();
    });
  }

}
