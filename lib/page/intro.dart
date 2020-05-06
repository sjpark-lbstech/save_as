import 'dart:async';

import 'package:flutter/material.dart';
import 'package:save_as/channel/ch_main.dart';
import 'package:save_as/components/dialogs.dart';
import 'package:save_as/rsc/Assets.dart';
import 'package:save_as/rsc/meta.dart';
import 'package:save_as/rsc/strings.dart';
import 'package:save_as/utility/permission_manager.dart';
import 'package:save_as/route.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> with SingleTickerProviderStateMixin{
  
  Animation _animation;
  AnimationController _animationController;
  String _routeName;
  NavigatorState _navigatorState;

  @override
  void initState() {
    super.initState();
    _animationController = 
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animation = 
        CurvedAnimation(parent: _animationController, curve: Curves.elasticInOut);

  }

  @override
  void didChangeDependencies() {
    _navigatorState = Navigator.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    _animationController.forward(from: 0.0);
    Timer(Duration(milliseconds: 1300), ()=>_checkPermissionState());

    return SafeArea(
      child: Stack(
        children: <Widget>[
          _backGround(),
          Center(
            child: Container(
              width: 300,
              child: ScaleTransition(
                scale: _animation,
                child: Image.asset(Assets.imgLogoBF,
                  height: 300,
                  width: 300,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }


  /// 최초 화면에 View를 만드는 과정, 이때 화면의 해상도 정보를 가져온다.
  /// 그라디언트 배경을 만들어서 반환한다.
  Widget _backGround(){
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraint){
        Meta.maxHeight = constraint.biggest.height;
        Meta.maxWidth = constraint.biggest.width;
        return Container(
          height: constraint.biggest.height,
          width: constraint.biggest.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  Colors.white.withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
          ),
        );
      },
    );
  }

  /// 전체 권한과 정책을 확인하고 권한 동의 여부에 따라
  /// 페이지 라우팅
  void _checkPermissionState() async{
    // 네트워크 상태 확인
    bool networkState = await MainChannel().getConnectionState();
    if (!networkState){
      return showSingleChoiceDialog(context,
        title: IntroText.ccditi,
        description: IntroText.ccdidc,
        btnText: IntroText.ccbtti,
      );
    }

    PermissionManager().check().then((result) async{
      if(result){ // 권한과 정책 모두 동의한 상태
        _routeName = Router.MAIN;

      }else{
        _routeName = Router.PERMISSION;
      }
      _navigatorState.pushReplacementNamed(_routeName);
    });
  }

}
