part of main_page;

class _HomeFrag extends StatefulWidget {
  final _MainPageState pageState;

  const _HomeFrag(this.pageState);

  @override
  __HomeFragState createState() => __HomeFragState();
}

class __HomeFragState extends State<_HomeFrag> {
  static int _tabIndex = 0;

  _MainPageState main;
  List<Widget> _tabViews = [];

  @override
  void initState() {
    main = widget.pageState;
    _buildTabViews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: main._tabController,
      physics: NeverScrollableScrollPhysics(),
      children: _tabViews,
    );
  }

  /// 모든 데이터를 불러온 이후 진행
  void _buildTabViews(){
    for(int i=0; i<main._tabList.length; i++){
      switch (i){
        case 0:
          break;
        case 1:
          break;
        case 2:
          break;
        case 3:
          break;
        case 4:
          break;
        case 5:
          break;
        case 6:
          break;
      }

      _tabViews.insert(i, ListView.builder(
        itemBuilder: (context, pos){
          return _listItem();
        },
        itemCount: 5,
      ));
    }
  }

  /// 리스트 뷰의 각 아이템에 들어가는 정보들.
  /// 업로드 유저 정보 (프로필 썸네일, 아이디)
  /// 컨텐츠에 대한 정보 (사진, 촬영일, 글, 평가, 촬영장소)
  /// 컨텐츠와 연결된 정보 (댓글, 좋아요)
  /// 컨텐츠로 가능한 기능 (상세보기, 따라찍기, 저장하기)
  /// [profile] - 프로필 썸네일 경로
  /// [userName] - 업로드 사용자 이름
  /// [imgPath] - 사진 경로
  /// [takenDate] - 촬영일자
  /// [text] - 사진에 남긴 글
  /// [place] - 사진을 찍은 장소
  /// [score] - 접근 편의성 점수
  /// [replies] - 댓글들
  /// [likeCnt] - 좋아요 개수
  /// [isLike] - 사용자가 좋아요를 눌렀는지,
  Widget _listItem({String profile, String userName, String imgPath,
    DateTime takenDate, String text, String place, double score, List<dynamic> replies,
    int likeCnt, bool isLike}){

    text = '피고 가는 자신과 운다. '
    '\n꽃이 평화스러운 귀는 어디 힘있다. '
    '\n행복스럽고 것이다.보라, 사랑의 미묘한 위하여서.';

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        // header 부분 업로드 사용자 정보 보여지고 상세보기 버튼
        Container(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(Assets.imgProfile, // TODO : 실제 프로필로.
                width: 40,
                height: 40,
              ),
              SizedBox(
                width: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  UserText(
                    text: 'tour_culture', // TODO : 실제 사용자 아이디.
                    style: UserText.BODY_1,
                  ),
                  UserText(
                    text: '바닷가', // TODO : 실제 데이터
                    style:  UserText.BODY_2,
                  ),
                ],
              ),
              Expanded(child: SizedBox()),
              GestureDetector(
                child: Container(
                  padding: EdgeInsets.all(4),
                  child: UserText(
                    text: '상세보기',
                    style: UserText.BODY_1,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),

        // 사진 부분
        Image.asset(
          Assets.imgLoginPageView2,
          height: Meta.maxWidth,
          fit: BoxFit.cover,
        ),

        // 아래 아이콘 영역
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
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

        // 아래 택스트 표시
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: (){
            main._showCommentBox();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: LayoutBuilder(
                  builder: (context, box){
                    TextSpan span = TextSpan(
                      text: text,
                      style: Theme.of(context).textTheme.body2,
                    );
                    TextPainter tp = TextPainter(
                      maxLines: 2,
                      textAlign: TextAlign.start,
                      textDirection: TextDirection.ltr,
                      text: span,
                    );
                    tp.layout(maxWidth: box.maxWidth);
                    bool isOver = tp.didExceedMaxLines;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        UserText(
                          text: text, // TODO : 실제 택스트로 변경
                          style: UserText.BODY_2,
                          maxLine: 2,
                        ),
                        isOver ? UserText(
                          text: '더보기..',
                          style: UserText.BODY_1,
                          color:  Theme.of(context).primaryColor,
                        ) : null,
                      ],
                    );
                  },
                ),
              ),

              // 댓글화면
              // TODO : 실제 대이터로 교체
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    UserText(
                      text: 'FriendsID',
                      style: UserText.BODY_1,
                    ),
                    SizedBox(width: 8,),
                    UserText(
                      text: '댓글내용 들어가는 공간',
                      style: UserText.BODY_2,
                    ),
                  ],
                ),
              ),

              // 댓글 쓰는 공간
              Container(
                width: Meta.maxWidth,
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(Assets.imgProfile,
                      width: 30,
                      height: 30,
                    ),

                    SizedBox(width: 8,),

                    UserText(
                      text: '댓글쓰기...',
                      style: UserText.SUBTITLE,
                      color: Colors.black45,
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),

        Container(
          padding: EdgeInsets.only(left: 16),
          margin: EdgeInsets.only(bottom: 8),
          child: UserText(
            text: '몇분전', //TODO: 실제 시간이랑 연동
            style: UserText.CAPTION,
            fontWeight: FontWeight.w600,
            color: Colors.black38,
          ),
        ),
      ],
    );
  }

}
