part of add_page;

class _SelectView extends StatefulWidget {
  final _AddPageState state;

  const _SelectView({Key key, this.state}) : super(key: key);
  @override
  __SelectViewState createState() => __SelectViewState();
}

class __SelectViewState extends State<_SelectView> {
  Completer<List<ImageContent>> _galleryCompleter = Completer();
  ScrollController _scrollController;

  // 이미지들 사이의 공간
  double _spacing = 4.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    MainChannel().getImageContents().then((list){
      widget.state._selectedImage = list.first;
      _galleryCompleter.complete(list);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _galleryCompleter.future,
      initialData: <ImageContent>[],
      builder: (context, snapShot){
        if (snapShot.hasData) {
          return _onSuccess(snapShot.data);
        } else if (snapShot.hasError){
          // 겔러리 사진 못가져 온 경우
          return _onError();
        } else {
          // 아직 가져 오고 있는 중
          return _onLoading();
        }
      },
    );
  }

  /// 로딩중에 불리는 위젯
  _onLoading() {
    return Center(child: CircularProgressIndicator(),);
  }

  /// 에러발생시 불리지는 위젯
  _onError() {
    return Center(
      child: UserText(
        text: '데이터를 가져오지 못합니다. \n'
            '저장소 권한을 확인해주세요.',
        style: UserText.BODY_1,
        textAlign: TextAlign.center,
      ),
    );
  }

  /// 데이터가 불러졌을때 사용되는 위젯.
  _onSuccess(List<ImageContent> gallery) {
    return LayoutBuilder(
      builder: (context, box){
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            widget.state._selectedImage?.originFile != null ?
            Image.file(
              widget.state._selectedImage.originFile,
              width: box.maxWidth,
              height: box.maxHeight/2,
              fit: BoxFit.cover,
              frameBuilder: (context, child, frame, wasLoaded){
                if (wasLoaded) return child;
                return AnimatedOpacity(
                  opacity: frame == null ? 0 : 1,
                  duration: Duration(milliseconds: 500),
                  curve: Curves.decelerate,
                  child: child,
                );
              },
            ) : Container(),
            SizedBox(
              height: _spacing,
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: _spacing,
                crossAxisSpacing: _spacing,
                controller: _scrollController,
                children: gallery.map((content){
                  return _singleImageThumbnail(content, gallery.indexOf(content));
                }).toList(),
              ),
            )
          ],
        );
      },
    );
  }


  /// 개별적인 사진에 대한 위젯
  Widget _singleImageThumbnail(ImageContent content, int idx){
    double lineHeight = (Meta.maxWidth - (_spacing*2))/3.0 + _spacing;
    int line = (idx/3).floor();
    return GestureDetector(
      onTap: (){
        if(mounted){
          setState(() {
            widget.state._selectedImage = content;
            _scrollController.animateTo(
              line*lineHeight,
              duration: Duration(milliseconds: 400),
              curve: Curves.decelerate,
            );
          });
        }
      },
      child: Image.file(
        content.thumbnailFile ?? content.originFile,
        fit: BoxFit.cover,
        color: content == widget.state._selectedImage ? Colors.white54 : null,
        colorBlendMode: BlendMode.screen,
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
    );
  }

}
