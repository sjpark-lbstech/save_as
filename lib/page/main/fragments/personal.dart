part of main_page;

class _Personal extends StatefulWidget {
  final _MainPageState state;

  const _Personal(this.state);

  @override
  __PersonalState createState() => __PersonalState();
}

class __PersonalState extends State<_Personal> with SingleTickerProviderStateMixin{
  _MainPageState main;
  TabController _tabController;

  @override
  void initState() {
    main = widget.state;
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        _sliverAppbar(),
        _sliverGridView(),
      ],
    );
  }

  _sliverAppbar(){
    double expandedHeight = 250.0;
    double profileSize = 80.0;

    return SliverAppBar(
      pinned: true,
      floating: true,
      snap: false,
      title: UserText(
        text: 'userID',
        style: UserText.SUBTITLE,
      ),
      automaticallyImplyLeading: false,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.menu),
          onPressed: (){
            main._openEndDrawer();
          },
        )
      ],
      backgroundColor: Color.fromRGBO(245, 245, 245, 1.0),
      expandedHeight: expandedHeight,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.none,
        background: Container(
          padding: EdgeInsets.only(top: 65, left: 16, right: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[

              // 프로필 영역
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: profileSize,
                    height: profileSize,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(profileSize/2),
                      color: Colors.black12,
                    ),
                  ),

                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        UserText(
                          text: '30',
                          style: UserText.SUBHEAD,
                        ),
                        UserText(
                          text: '게시물',
                          style: UserText.BODY_2,
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        UserText(
                          text: '16',
                          style: UserText.SUBHEAD,
                        ),
                        UserText(
                          text: '경로제공',
                          style: UserText.BODY_2,
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        UserText(
                          text: '30',
                          style: UserText.SUBHEAD,
                        ),
                        UserText(
                          text: '정보평가',
                          style: UserText.BODY_2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 8,),

              // 프로필
              UserText(
                text: '사용자명',
                style: UserText.BODY_2,
              ),

              // 프로필 수정 버튼
              Container(
                margin: EdgeInsets.only(top: 16),
                padding: EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    width: 1.0,
                    color: Colors.black12,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: UserText(
                    text: '프로필 수정',
                    style: UserText.BODY_1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }

  _sliverGridView() {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      delegate: SliverChildBuilderDelegate(
            (context, pos){
          return Image.asset(
            Assets.imgAroundSample,
            fit: BoxFit.cover,
          );
        },
        childCount: 30,
      ),
    );
  }
}
