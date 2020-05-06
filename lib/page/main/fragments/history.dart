part of main_page;

class _History extends StatefulWidget {
  final _MainPageState pageState;

  const _History(this.pageState);
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<_History> {
  _MainPageState main;

  double _leadingSize = 45.0;

  @override
  void initState() {
    main = widget.pageState;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: UserText(
              text: '이번주',
              style: UserText.SUBTITLE,
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _eachItem(),
            ],
          ),

          Container(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: UserText(
              text: '이전 활동',
              style: UserText.SUBTITLE,
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _eachItem(),
              _eachItem(),
            ],
          ),

        ],
      ),
    );
  }

  ListTile _eachItem(){
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 24),
      
      leading: Container(
        width: _leadingSize,
        height: _leadingSize,
        child: Image.asset(Assets.imgProfile),
      ),
      trailing: Container(
        width: _leadingSize,
        height: _leadingSize,
        child: Image.asset(Assets.imgLoginPageView2,
          fit: BoxFit.cover,
        ),
      ),
      title: Text.rich(
        TextSpan(
            children: <InlineSpan>[
              WidgetSpan(
                child: GestureDetector(
                  onTap: (){
                    print('아이디 클릭');
                  },
                  child: UserText(
                    text: 'someone_id',
                    style: UserText.BODY_1,
                  ),
                ),
              ),

              TextSpan(
                text: '님이 댓글을 남겼습니다. ',
                style: UserText.body2(context),
              ),
              TextSpan(
                text: '5일',
                style: UserText.body1(context).copyWith(color: Colors.black38),
              ),
            ]
        ),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
