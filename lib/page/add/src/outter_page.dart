part of add_page;

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  PageController _pageController;
  int _page = 0;

  _SelectView _selectView;
  _EditView _editView;

  ImageContent _selectedImage;

  @override
  void initState() {
    _pageController = new PageController();

    // 페이지 생성 & 참조
    _selectView = _SelectView(state: this,);
    _editView = _EditView(state: this,);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        if(_page == 1){
          _pageController.previousPage(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: SafeArea(
        child: Scaffold(
          appBar: _appbar(),
          body: PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: _pageController,
            onPageChanged: (pos){
              setState(() {
                _page = pos;
              });
            },
            children: <Widget>[
              _selectView,
              _editView,
            ],
          ),
        ),
      ),
    );
  }

  _appbar() {
    String title = '';
    Widget leading;
    String actionText = '';
    switch (_page){
      case 0:
        title = '사진 선택';
        actionText = '다음';
        leading = GestureDetector(
          onTap: (){
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.close,
            color: Colors.black87,
          ),
        );
        break;
      case 1:
        title = '게시물 등록';
        actionText = '공유';
        leading = GestureDetector(
          onTap: (){
            _pageController.previousPage(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black87,
          ),
        );
        break;
      default :
        title = '';
        break;
    }

    return whiteAppbar(
      title: title,
      leading: leading,
      actions: [
        MaterialButton(
          onPressed: _clickNext,
          child: UserText(
            text: actionText,
            style: UserText.SUBTITLE,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ]
    );
  }


  /// 다음 버튼 눌러졌을때 불리는 콜백
  void _clickNext() async {
    switch (_page){
      case 0:
        {
          if (_selectedImage == null) return;
          File croppedFile = await ImageCropper.cropImage(
            sourcePath: _selectedImage.originPath,
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio5x4,
            ],
            androidUiSettings: AndroidUiSettings(
              backgroundColor: Colors.white,
              activeControlsWidgetColor: Theme.of(context).primaryColor,
              activeWidgetColor: Colors.white,
              toolbarColor: Colors.white,
              dimmedLayerColor: Colors.white60,
            ),
          );
          if (croppedFile != null){
            _selectedImage.originPath = croppedFile.path;
            _pageController.nextPage(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        }
        break;
      case 1:
        Navigator.of(context).pop();
        _editView.upload().then((bool isUpload){
          if(isUpload){
            MainChannel().showSelfNotification('업로드 성공',
                '회원님의 게시물이 성공적으로 공유되었습니다.');
          }else {
            MainChannel().showSelfNotification('업로드 실패',
                '회원님의 게시물이 정상적으로 업도드되지 않았습니다. 다시 시도해주세요.');
          }
        });
        break;
    }
  }
}
