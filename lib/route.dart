import 'package:flutter/material.dart';
import 'package:save_as/page/add/add_page.dart';
import 'package:save_as/page/intro.dart';
import 'package:save_as/page/main/main_page.dart';
import 'package:save_as/page/path_set/path_set_page.dart';
import 'package:save_as/page/permission/permission_page.dart';
import 'package:save_as/page/policy/policy_page.dart';

class Router{
  static const String INTRO = "/";
  static const String MAIN = "/main";
  static const String PERMISSION = '/permission';
  static const String POLICY = '/policy';
  static const String CAMERA = '/camera';
  static const String ADD = '/add';
  static const String PATH_SET = '/path_set';

  static Map<String, WidgetBuilder> getRouter() {
    return {
      INTRO : (_)=> IntroPage(),
      MAIN : (_) => MainPage(),
      POLICY : (_) => PolicyPage(),
      PERMISSION : (_) => PermissionPage(),
      ADD : (_) => AddPage(),
      PATH_SET : (_) => PathSetPage(),
    };
  }

  static Route<dynamic> onGenerateRoute(RouteSettings settings){

  }

}