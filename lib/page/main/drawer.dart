part of main_page;

class _Drawer extends StatefulWidget {
  final _MainPageState state;

  const _Drawer({Key key, this.state}) : super(key: key);

  @override
  __DrawerState createState() => __DrawerState();
}

class __DrawerState extends State<_Drawer> {

  Map<String, String> _navItems = {
    Assets.iconImage : '따라찍은 사진',
    Assets.iconTag : '저장됨',
    Assets.iconSetting : '설정',
  };

  List<Widget> _navs = [];

  @override
  void initState() {
    super.initState();
    _navItems.forEach((icon, title){
      _navs.add(Container(
        margin: EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: <Widget>[
            Image.asset(
              icon,
              width: 26,
              height: 26,
              color: Colors.black87,
            ),
            SizedBox(width: 16,),
            UserText(
              text: title,
              style: UserText.SUBTITLE,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.state._drawerWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.horizontal(left: Radius.circular(10)),
      ),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 14),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _profile(),
          Divider(
            color: Colors.black26,
            height: 10,
          ),

          SizedBox(
            height: 10,
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: _navs,
          ),

          Expanded(child: Container()),

          Container(
            child: Image.asset(
              Assets.imgLogoBF,
              width: 50,
              height: 50,
            ),
          ),

          Divider(
            color: Colors.black26,
            height: 10,
          ),

          Container(
            child: UserText(
              text: 'version : 1.0.0\nCopyright 2020 LBSTECH\nall right reserved.',
              style : UserText.CAPTION,
              textAlign: TextAlign.center,
            ),
          ),

        ],
      ),
    );
  }

  _profile(){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: <Widget>[
          Image.asset(
            Assets.imgProfile,
            height: 45,
            width: 45,
          ),
          SizedBox(width: 12,),
          UserText(
            text: 'user ID',
            style: UserText.BODY_1,
          ),
        ],
      ),
    );
  }

}
