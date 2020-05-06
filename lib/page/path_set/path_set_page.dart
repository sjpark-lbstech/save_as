import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map_test/flutter_naver_map_test.dart';
import 'package:geocoder/geocoder.dart';
import 'package:http/http.dart';
import 'package:save_as/channel/ch_main.dart';
import 'package:save_as/components/appbar.dart';
import 'package:save_as/components/search_delegate.dart';
import 'package:save_as/components/text.dart';
import 'package:save_as/rsc/Assets.dart';
import 'package:save_as/rsc/meta.dart';

class PathSetPage extends StatefulWidget {
  @override
  _PathSetPageState createState() => _PathSetPageState();
}

class _PathSetPageState extends State<PathSetPage> {
  /// 입력 시작안한 단계
  static const int STEP_NONE = 0XA002D1;

  /// 출발지 설정중
  static const int STEP_START_PREPARING = 0XA002D2;

  /// 출발지 설정 중이고 2번째 입력 대기
  static const int STEP_START_SET = 0XA002D3;

  /// 2번째 지점 입력됫고 입력 종료 가능
  static const int STEP_NEXT_NODE = 0XA002D4;


  Completer<String> _userPosition = Completer();
  Completer<NaverMapController> _mapController = Completer();

  Completer<ImageConfiguration> configuration = Completer();
  OverlayImage _selectorIcon;
  OverlayImage _selectedIcon;

  String _startPointAddress = '위치검색...';
  String _btnText = '지도에서 출발지 선택';

  List<Marker> _markers = [];
  Marker _startMarker;
  Set<PathOverlay> _paths = Set.identity();
  List<LatLng> _coodinates = [];
  bool _isSetting = false;

  int _step = STEP_NONE;

  @override
  Widget build(BuildContext context) {
    _makeOverlayImage();

    switch (_step){
      case STEP_NONE :
        _btnText = '지도에서 출발지 선택';
        break;
      case STEP_START_PREPARING :
        _btnText = '출발지 확정';
        break;
      case STEP_START_SET :
      case STEP_NEXT_NODE :
        _btnText = '다음 지점';
        break;
    }

    return Scaffold(
      appBar: _appbar(),
      body: _body(),
    );
  }

  void _makeOverlayImage() async{
    if (_selectedIcon == null || _selectorIcon == null) {
      if (!configuration.isCompleted) {
        configuration.complete(createLocalImageConfiguration(context));
      }
      OverlayImage.fromAssetImage(
          await configuration.future, Assets.iconMarkerUndefined)
          .then((image) {
        _selectorIcon = image;
      });
      OverlayImage.fromAssetImage(
          await configuration.future, Assets.iconMarkerDefined)
          .then((image) {
        _selectedIcon = image;
      });
    }
  }

  _appbar() {
    double bottomHeight = 125.0;

    return whiteAppbar(
      title: '경로 입력',
      leading: IconButton(
        onPressed: (){
          Navigator.of(context).pop();
        },
        icon: Icon(Icons.clear),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(bottomHeight),
        child: Container(
          height: bottomHeight,
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // 출발지 입력부분
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    child: UserText(
                      text: '출발',
                      style: UserText.SUBTITLE,
                    ),
                  ),

                  /// 지역 검색 부분
                  Expanded(
                    child: GestureDetector(
                      onTap: _searchPlace,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Color.fromRGBO(245, 245, 245, 1.0),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        child: UserText(
                          text: _startPointAddress,
                          style: UserText.SUBTITLE,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: _reset,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(Icons.clear),),
                  ),
                ],
              ),

              // 버튼 부분
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // 출발지 직접 입력
                  Expanded(
                    child: GestureDetector(
                      onTap: _clickStepBtn,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black26, width: 0.5),
                            borderRadius: BorderRadius.circular(8)
                        ),
                        child: Center(
                          child: UserText(
                            text: _btnText,
                            style: UserText.BODY_1,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // 리셋 버튼
                  Expanded(
                    child: GestureDetector(
                      onTap: _reset,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        margin: EdgeInsets.only(left: 8),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black26, width: 0.5),
                            borderRadius: BorderRadius.circular(8)
                        ),
                        child: Center(
                          child: UserText(
                            text: '전체 리셋',
                            style: UserText.BODY_1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }

  // body
  _body() {

    return Stack(
      children: <Widget>[
        NaverMap(
          initLocationTrackingMode: LocationTrackingMode.Follow,
          locationButtonEnable: true,
          onMapCreated: (controller) => _mapController.complete(controller),
          markers: _markers,
          onCameraChange: _onCameraChange,
          pathOverlays: _paths,
        ),

        Align(
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.only(bottom: 50),
            child: _isSetting ? Image.asset(
              Assets.iconMarkerUndefined,
              height: 50,
              fit: BoxFit.fitHeight,
            ) : null,
          ),
        ),

        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: _step == STEP_NEXT_NODE ? Meta.maxWidth : 0,
                padding: EdgeInsets.only(left: 16,right: 16, bottom: 8),
                child: MaterialButton(
                  onPressed: _clickDone,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  color: Theme.of(context).primaryColor,
                  child: UserText(
                    text: '경로 입력 완료',
                    style: UserText.BTN,
                    color: Colors.white,
                  ),
                ),
              ),

              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: _isSetting ? Meta.maxWidth : 0,
                padding: EdgeInsets.only(left: 16,right: 16, bottom: 16),
                child: MaterialButton(
                  onPressed: _clickStepBtn,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  color: Theme.of(context).primaryColor,
                  child: UserText(
                    text: _btnText,
                    style: UserText.BTN,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }


  // 위치 검색 함수
  void _searchPlace() async{
    final map = await showSearch(
      context: context,
      delegate: LocationSearch(),
    );
    if (map != null && map.isNotEmpty && _mapController.isCompleted){
      String address = map['address'];
      double lat = map['latitude'];
      double lng = map['longitude'];

      if (!mounted) return;
      _mapController.future.then((controller){
        controller.moveCamera(CameraUpdate.toCameraPosition(CameraPosition(
          target: LatLng(lat, lng),
          zoom: 18.0,
        ))).then((_){
          if (mounted) {
            setState(() {
              _startPointAddress = address;
              _isSetting = true;
              _step = STEP_START_PREPARING;
            });
          }
        });
      });
    }
  }

  /// 전체 입력 리셋
  void _reset(){
    if (mounted) {
      setState(() {
        _step = STEP_NONE;
        _markers.clear();
        _startMarker = null;
        _paths = Set.identity();
        _coodinates.clear();
        _isSetting = false;
        _startPointAddress = '위치검색...';
      });
    }
  }

  Marker _marker(double lat, double lng) {
    return Marker(
      position: LatLng(lat, lng),
      markerId: '$lat,$lng',
      icon: _selectedIcon,
      width: 85,
      height: 130,
    );
  }

  /// 다음 스텝 버튼 눌렀을 경우
  void _clickStepBtn() {
    switch (_step){
      case STEP_NONE :
        _mapController.future.then((controller) async{
          controller.moveCamera(CameraUpdate.zoomTo(18.0));
          CameraPosition position = await controller.getCameraPosition();
          Geocoder.local.findAddressesFromCoordinates(Coordinates(
              position.target.latitude, position.target.longitude)).then((list){
                if (list != null && list.isNotEmpty){
                  setState(() {
                    _startPointAddress = list.first.addressLine;
                  });
                }
          });
        });
        setState(() {
          _isSetting = true;
          _step = STEP_START_PREPARING;
        });
        break;
      case STEP_START_PREPARING:
        _mapController.future.then((controller) async{
          CameraPosition position = await controller.getCameraPosition();
          LatLng latLng = position.target;
          _startMarker = _marker(latLng.latitude, latLng.longitude);

          controller.moveCamera(CameraUpdate.scrollTo(LatLng(
            latLng.latitude+0.00005,
            latLng.longitude + 0.00005,
          )));
          _markers.add(_startMarker);
          setState(() {
            _step = STEP_START_SET;
          });
        });
        break;
      case STEP_START_SET:
        _mapController.future.then((controller) async{
          CameraPosition position = await controller.getCameraPosition();
          _coodinates.add(_startMarker.position);
          _coodinates.add(position.target);
          _paths.add(PathOverlay(
            PathOverlayId('path'),
            _coodinates,
            width: 6,
            color: Theme.of(context).primaryColor,
            outlineWidth: 1,
          ));
          setState(() {
            _step = STEP_NEXT_NODE;
          });
        });
        break;
      case STEP_NEXT_NODE:
        _mapController.future.then((controller) async{
          CameraPosition position = await controller.getCameraPosition();
          setState(() {
            _coodinates.add(position.target);
          });
        });
        break;
    }

  }

  /// 모든 작업이 완료되었을때
  void _clickDone() {
    if (_step != STEP_NEXT_NODE || _paths.isEmpty) return;
    Navigator.of(context).pop(_paths);
  }

  /// 카메라 움직임 콜백
  void _onCameraChange(LatLng latLng) {


  }
}
