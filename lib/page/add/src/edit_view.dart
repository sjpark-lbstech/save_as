part of add_page;

class _EditView extends StatefulWidget {
  final _AddPageState state;

  const _EditView({Key key, this.state}) : super(key: key);

  @override
  __EditViewState createState() => __EditViewState();

  Future<bool> upload() async {
    // 게시물 업데이트

    return true;
  }

}

class __EditViewState extends State<_EditView> {
  final List<String> _basicTags = [
    '거리', '맛집', '공원', '쇼핑센터', '문화', '역사',
  ];
  List<String> _selectedBasicTag;
  List<String> _addedCustomTag = [];

  TextEditingController _textEditingController;
  TextEditingController _tagEditingController;
  Completer<NaverMapController> _controller = Completer();

  Set<PathOverlay> _path;
  Map<String, dynamic> _location;
  double _rate = 0.0;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    _tagEditingController = TextEditingController();
    _selectedBasicTag = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _textInput(),
          _addLocation(),
          _addPath(),
          _addTag(),
        ],
      ),
    );
  }

  /// 텍스트 입력하는 공간
  _textInput() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(
          width: 1.0,
          color: Colors.black12,
        )),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.file(
            widget.state._selectedImage.originFile,
            width: Meta.maxWidth*0.2,
            height: Meta.maxWidth*0.2,
            frameBuilder: (context, child, frame, wasLoaded){
              if (wasLoaded) return child;
              return AnimatedOpacity(
                opacity: frame == null ? 0 : 1,
                duration: Duration(milliseconds: 500),
                curve: Curves.decelerate,
                child: child,
              );
            },
          ),

          SizedBox(width: 8,),

          Expanded(
            child: TextField(
              controller: _textEditingController,
              style: Theme.of(context).textTheme.body1,
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 10,
              autofocus: false,
              decoration: InputDecoration(
                hintText: '문구 입력...',
                hintStyle: Theme.of(context).textTheme.body1.copyWith(
                  color: Colors.black38,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 위치 추가 부분
  _addLocation() {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(
          width: 1.0,
          color: Colors.black12,
        )),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  onTap: () async{
                    _location = await showSearch(context: context, delegate: PlaceSearch());
                    if(mounted){
                      setState(() {});
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: UserText(
                      text: _location == null ? '위치 입력' : '위치',
                      style: UserText.SUBTITLE,
                    ),
                  ),
                ),
              ),

              _location != null ? GestureDetector(
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: UserText(
                    text: '삭제',
                    style: UserText.SUBTITLE,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ) : SizedBox(),
            ],
          ),

          _location != null ? Container(
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: UserText(
              text: _location['name'],
              style: UserText.BODY_2,
              color: Colors.black54,
            ),
          ) : Container(),
        ],
      ),
    );
  }

  /// 이동경로 추가 부분
  _addPath() {
    return GestureDetector(
      onTap: _onPathEdit,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(
            width: 1.0,
            color: Colors.black12,
          )),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: UserText(
                    text: _path == null ? '이동 경로 입력' : '이동 경로 변경',
                    style: UserText.SUBTITLE,
                  ),
                ),

                _path != null ?
                GestureDetector(
                  onTap: (){
                    _controller = Completer();
                    setState(() {
                      _path = null;
                      _rate = 0.0;
                    });
                  },
                  child: UserText(
                    text: '삭제',
                    style: UserText.SUBTITLE,
                    color: Theme.of(context).primaryColor,
                  ),
                ) : Container(),
              ],
            ),

            _path != null ? _pathMap() : Container(),

            _path != null ? Container(
              padding: EdgeInsets.only(top: 16),
              child: UserText(
                text: '접근성 및 편의성',
                style: UserText.BODY_1,
                color: Colors.black54,
              ),
            ) : Container(),

            _path != null ? _rating() : Container(),
          ],
        ),
      ),
    );
  }

  /// 지도에 표시되는 경로 정보
  _pathMap(){
    return Container(
      padding: EdgeInsets.only(top: 16),
      height: 150,
      child: NaverMap(
        rotationGestureEnable: false,
        tiltGestureEnable: false,
        scrollGestureEnable: false,
        zoomGestureEnable: false,
        pathOverlays: _path,
        onMapCreated: (controller){
          if (_controller.isCompleted){
            _controller = Completer();
          }
          _controller.complete(controller);
          _setMapLatLngBounds(controller);
        },
      ),
    );
  }

  /// 경로 추가 이후 접근 편의성 입력
  _rating() {
    double rate = 0.0;
    if (_rate == 0.0) rate = 0.0;
    else if (_rate < 0.5) rate = 0.5;
    else if (_rate < 1.0) rate = 1.0;
    else if (_rate < 1.5) rate = 1.5;
    else if (_rate < 2.0) rate = 2.0;
    else if (_rate < 2.5) rate = 2.5;
    else if (_rate < 3.0) rate = 3.0;
    else if (_rate < 3.5) rate = 3.5;
    else if (_rate < 4.0) rate = 4.0;
    else if (_rate < 4.5) rate = 4.5;
    else rate = 5.0;


    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          SmoothStarRating(
            rating: _rate,
            allowHalfRating: true,
            size: 35.0,
            spacing: 5.0,
            color: Theme.of(context).primaryColor,
            onRatingChanged: (rating) {
              setState(() {
                _rate = rating;
              });
            },
          ),

          UserText(
            text: rate.toStringAsFixed(1),
            style: UserText.HEADLINE,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }

  /// 태그 추가 부분
  _addTag() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(
          width: 1.0,
          color: Colors.black12,
        )),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          UserText(
            text: '테그 추가',
            style: UserText.SUBTITLE,
          ),

          SizedBox(height: 8,),

          // 필수 태그
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              UserText(
                text: '필수 태그',
                style: UserText.SUBTITLE,
                color: Colors.black54,
              ),

              SizedBox(
                width: 16,
              ),

              Expanded(
                child: Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: _basicTags.map((String tag){
                    bool isSelected = _selectedBasicTag.contains(tag);
                    return GestureDetector(
                      onTap: (){
                        setState(() {
                          if(isSelected){
                            _selectedBasicTag.remove(tag);
                          }else{
                            _selectedBasicTag.add(tag);
                          }
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.only(right: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            UserText(
                              text: '#' +tag,
                              style: UserText.SUBTITLE,
                              color: isSelected
                                  ? Theme.of(context).primaryColor : Colors.black54,
                            ),
                            !isSelected
                                ? Icon(
                              Icons.add_circle_outline,
                              size: 14,
                              color: Colors.black54,
                            ) : Icon(
                              Icons.remove_circle_outline,
                              size: 14,
                              color: Theme.of(context).primaryColor,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

            ],
          ),

          SizedBox(height: 16,),

          Divider(
            color: Colors.black12,
            height: 0,
          ),

          // 추가 태그
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 12),
                child: UserText(
                  text: '추가 태그',
                  style: UserText.SUBTITLE,
                  color: Colors.black54,
                ),
              ),

              SizedBox(
                width: 16,
              ),

              // 입력창이랑 아래 태그 보여지는 곳
              Expanded(
                child: Column(
                  children: <Widget>[

                    // 입력창
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: _tagEditingController,
                            autofocus: false,
                            maxLines: 1,
                            maxLength: 10,
                            onSubmitted: (_)=>_addCustomTag,
                            style: Theme.of(context).textTheme.subtitle,
                            decoration: InputDecoration(
                              hintText: '문구 입력...',
                              hintStyle: Theme.of(context).textTheme.subtitle.copyWith(
                                color: Colors.black38,
                              ),
                              border: InputBorder.none,
                              counterText: '',
                            ),
                          ),
                        ),

                        GestureDetector(
                          onTap: _addCustomTag,
                          child: Icon(
                            Icons.add_box,
                            color: Theme.of(context).primaryColor,
                            size: 30,
                          ),
                        ),
                      ],
                    ),

                    // 추가 태그 보여지는 곳
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: _addedCustomTag.map((String tag){
                        return GestureDetector(
                          onTap: (){
                            setState(() {
                              _addedCustomTag.remove(tag);
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.only(right: 8),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                UserText(
                                  text: '#' +tag,
                                  style: UserText.SUBTITLE,
                                  color: Theme.of(context).primaryColor,
                                ),
                                Icon(
                                  Icons.remove_circle_outline,
                                  size: 14,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ],
      ),
    );
  }

  // 추가태그 입력후 추가시 불리는 콜백
  void _addCustomTag() async {
    String tag = _tagEditingController.text;
    if(tag == null || tag.isEmpty) return;
    setState(() {
      _addedCustomTag.add(tag);
      _tagEditingController.clear();
    });
  }

  /// 이동 경로정보 추가 누를경우 호출
  void _onPathEdit() async{
    final result = await Navigator.of(context).pushNamed(Router.PATH_SET);
    if (result != null) {
      _path = result;
      if (_controller.isCompleted){
        _setMapLatLngBounds(await _controller.future);
      }
      if (mounted) setState(() { });
    }
  }

  /// [NaverMap]의 표시영역 설정
  void _setMapLatLngBounds(NaverMapController controller){
    List<LatLng> latLng = _path.first.coords;
    assert (latLng.length > 1);
    double minLat = 1000.0, minLng = 1000.0;
    double maxLat = -1000.0, maxLng = -1000.0;
    for (LatLng position in latLng) {
      if (position.latitude > maxLat)
        maxLat = position.latitude;
      if (position.latitude < minLat)
        minLat = position.latitude;
      if (position.longitude > maxLng)
        maxLng = position.longitude;
      if (position.longitude < minLng)
        minLng = position.longitude;
    }
    print('southWest : $minLat, $minLng');
    print('northWest : $maxLat, $maxLng');
    double offset = 0.00005;
    controller.moveCamera(CameraUpdate.fitBounds(LatLngBounds(
      southwest: LatLng(minLat - offset, minLng - offset),
      northeast: LatLng(maxLat + offset, maxLng + offset),
    )));
  }


}
