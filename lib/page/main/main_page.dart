library main_page;

import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map_test/flutter_naver_map_test.dart';
import 'package:save_as/channel/ch_main.dart';
import 'package:save_as/components/appbar.dart';
import 'package:save_as/components/search_delegate.dart';
import 'package:save_as/components/text.dart';
import 'package:save_as/route.dart';
import 'package:save_as/rsc/Assets.dart';
import 'package:save_as/rsc/meta.dart';
import 'package:save_as/rsc/strings.dart';

part 'drawer.dart';
part 'appbar.dart';
part 'bottom_nav.dart';
part 'fragments/home.dart';
part 'fragments/local.dart';
part 'fragments/upload.dart';
part 'fragments/history.dart';
part 'fragments/personal.dart';

class MainPage extends StatefulWidget{
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with TickerProviderStateMixin, WidgetsBindingObserver{
  
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  FocusNode _tfNode = FocusNode();
  TextEditingController _textController = TextEditingController();
  TabController _tabController;
  Animation _slideAnimation;
  AnimationController _slideController;
  
  double _drawerWidth = 200.0;
  int _bottomNavIndex = 0;
  
  List<String> _tabList = [
    '#거리', '#맛집', '#공원', '#쇼핑센터', '#문화', '#역사', '#종교',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _slideController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.2),
      end: Offset.zero
    ).animate(_slideController);
    _tabController = TabController(
      length: _tabList.length,
      vsync: this,
      initialIndex: 0,
    );
    _tfNode.addListener((){
      if(_tfNode.hasFocus)
        print('포커스 얻음');
      else
        print('포커스 잃음');
    });

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: (){
          _hideCommentBox();
        },
        child: Scaffold(
          key: _scaffoldKey,
          appBar: _appbar(this),
          body: _bodyRouter(),
          endDrawer: _Drawer(state: this),
          drawerEdgeDragWidth: 0,
          drawerScrimColor: Colors.black26,
          bottomNavigationBar: _bottomNav(this),
        ),
      ),
    );
  }

  /// Tab bar 인덱스에 따라 화면 라우트
  Widget _bodyRouter() {
    Widget target;
    switch (_bottomNavIndex){
      case 0:
        target = _HomeFrag(this);
        break;
      case 1:
        target = _Local(this);
        break;
      case 2:
        target = _Upload(this);
        break;
      case 3:
        target = _History(this);
        break;
      case 4:
        target = _Personal(this);
        break;
      default:
        FlutterError('bottom navigation index가 범위를 벗어남');
        return Container();
    }
    return Stack(
      children: <Widget>[
        target,
        _commentBox(),
      ],
    );
  }

  /// 댓글 작성하는 댓글창
  /// 평소에는 가려져서 안보이다가 TextField 에 focus 되면
  /// 올라와서 보이게 된다.
  Widget _commentBox(){
    TextStyle textStyle = Theme.of(context).textTheme.subhead;
    TextStyle hintStyle = textStyle.copyWith(color: Colors.black38);

    return SlideTransition(
      position: _slideAnimation,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: Colors.black26,width: 0.25),
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(Assets.imgProfile,
                width: 40,
                height: 40,
              ),
              SizedBox(width: 16,),
              Expanded(
                child: TextField(
                  focusNode: _tfNode,
                  maxLines: 1,
                  style: textStyle,
                  autofocus: false,
                  controller: _textController,
                  decoration: InputDecoration(
                    hintText: '댓글 입력...',
                    hintStyle: hintStyle,
                    border: InputBorder.none,
                  ),
                ),
              ),

              UserText(
                text: '게시',
                style: UserText.SUBTITLE,
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 드로우어 열기
  void _openEndDrawer(){
    _scaffoldKey.currentState.openEndDrawer();
  }

  /// bottomNav 초기값
  int _prevBottomIndex = 0;

  /// 아래쪽 바텀 네비게이션 클릭 리스너
  void _onBottomNavTab(int pos){
    _bottomNavIndex = pos;
    setStateIfMounted();
    if (pos == 2) {
      Navigator.of(context).pushNamed(Router.ADD).then((_){
        _bottomNavIndex = _prevBottomIndex;
        setStateIfMounted();
      });
    } else {
      _prevBottomIndex = pos;
    }
  }

  /// 상단 텝바 클릭 리스너
  void _onTabBarTab(int index){
    if (_bottomNavIndex == 0){
      __HomeFragState._tabIndex = index;
      _tfNode.unfocus();
      setStateIfMounted();
    }else {

    }
  }

  /// setState 에 mounted 조건 추가
  void setStateIfMounted(){
    if(mounted){
      setState(() {});
    }
  }

  /// softkeyboard 내려갈때 리스너
  @override
  void didChangeMetrics() {
    if (!mounted) return;
    if(_tfNode.hasFocus && MediaQuery.of(context).viewInsets.bottom > 0.0 ){
      _hideCommentBox();
    }
    super.didChangeMetrics();
  }

  /// 코멘트 박스 올리기
  void _showCommentBox(){
    _slideController.forward();
    _tfNode.requestFocus();
  }

  /// 코멘트 박스 내리기
  void _hideCommentBox(){
    _slideController.reverse();
    _tfNode.unfocus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tfNode.dispose();
    super.dispose();
  }

}
