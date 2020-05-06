part of main_page;

class _Local extends StatefulWidget {
  final _MainPageState pageState;

  const _Local(this.pageState);
  @override
  __LocalState createState() => __LocalState();
}

class __LocalState extends State<_Local> with TickerProviderStateMixin {
  static Completer<NaverMapController> _controller = Completer();

  _MainPageState main;
  Animation _slideAnimation;
  AnimationController _slideController;
  double _opacity = 0.0;
  List<Marker> _markers = [];

  double _dragStartY, _dragEndY = 0.0;

  @override
  void initState() {
    main = widget.pageState;
    _slideController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _slideAnimation =
        Tween<Offset>(begin: Offset(0.0, 0.3), end: Offset.zero).animate(_slideController);

    _createMarkers();
    super.initState();
  }

  void _createMarkers() {
    _markers.add(Marker(
        markerId: '1',
        position: LatLng(37.563801, 126.962871),
        onMarkerTab: _onMarkerTab,
    ));
  }

  void _onMarkerTab(Marker marker, Map<String, int> size){
    if (!mounted) return;
    if (_slideController.isDismissed){
      setState(() {
        _opacity = 1.0;
        _slideController.forward();
      });
    }else {
      // TODO : 데이터만 변경.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _naverMap(),
        _infoCard(),
      ],
    );
  }

  /// 네이버 지도
  Widget _naverMap(){
    return NaverMap(
      initLocationTrackingMode: LocationTrackingMode.Follow,
      locationButtonEnable: true,
      onMapCreated: (controller) {
        _controller.complete(controller);
      },
      markers: _markers,
    );
  }

  /// 아이템 정보 카드
  Widget _infoCard() {
    String text = '피고 가는 자신과 운다. '
        '꽃이 평화스러운 귀는 어디 힘있다. '
        '\n행복스럽고 것이다.보라, 사랑의 미묘한 위하여서.';

    return SlideTransition(
      position: _slideAnimation,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 350),
        opacity: _opacity,
        child: GestureDetector(
          behavior: HitTestBehavior.deferToChild,
          onVerticalDragEnd: (detail){
            if(!mounted) return;
            if (_dragEndY-_dragStartY > 30){
              setState(() {
                _opacity = 0.0;
                _slideController.reverse();
              });
            }
          },
          onVerticalDragStart: (detail){
            _dragStartY = detail.localPosition.dy;
          },
          onVerticalDragUpdate: (detail){
            _dragEndY = detail.localPosition.dy;
          },
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
              child: Container(
                width: Meta.maxWidth,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    // 가장 위 막대 아이콘 부분
                    Container(
                      height: 5,
                      width: 30,
                      margin: EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // TODO : 실제 데이터로 변환
                        Image.asset(
                          Assets.imgLoginPageView3,
                          width: Meta.maxWidth*0.25,
                          height: Meta.maxWidth*0.25,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 8,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              // TODO : 실제 등록자 아이디
                              UserText(
                                text: 'userid',
                                style: UserText.BODY_1,
                              ),
                              UserText(
                                text: text,
                                maxLine: 3,
                                style: UserText.BODY_2,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // 아이콘들
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: <Widget>[
                          GestureDetector(
                            child: Image.asset(Assets.iconHeart,
                              width: 26,
                              height: 26,
                            ),
                          ),
                          SizedBox(width: 16,),
                          GestureDetector(
                            child: Image.asset(Assets.iconComment,
                              width: 24,
                              height: 24,
                            ),
                          ),
                          SizedBox(width: 16,),
                          GestureDetector(
                            child: Image.asset(Assets.iconCamera,
                              width: 28,
                              height: 28,
                            ),
                          ),
                          SizedBox(width: 16,),
                          GestureDetector(
                            child: Image.asset(Assets.iconTag,
                              width: 24,
                              height: 24,
                            ),
                          ),
                          Expanded(child: SizedBox()),
                          Image.asset(Assets.iconStar,
                            width: 26,
                            height: 26,
                          ),
                          SizedBox(width: 8,),
                          UserText(
                            text: '4.5', // TODO : 실제 데이터로 변경
                            style: UserText.SUBTITLE,
                            color: Theme.of(context).primaryColor,
                          )
                        ],
                      ),
                    ),

                    GestureDetector(
                      onTap: (){
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: UserText(
                          text: '자세히보기',
                          style: UserText.SUBTITLE,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    )

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


  static void moveMap(double lat, double lng) async{
    if (_controller.isCompleted) {
      NaverMapController naverController = await _controller.future;
      naverController.moveCamera(CameraUpdate.scrollTo(LatLng(lat, lng)));
    }else return;
  }

  @override
  void dispose() {
    _controller = Completer();
    super.dispose();
  }

}
