part of main_page;

AppBar _appbar(_MainPageState pageState){
  String title = '';
  Widget leading;
  Widget action;
  Widget titleWidget;
  TabBar tabBar;
  switch (pageState._bottomNavIndex){
    case 0:
      title = 'BF CAMERA';
      leading = Container(
        padding: EdgeInsets.only(left: 16),
        child: Image.asset(
          Assets.imgLogoBF,
          scale: 16,
        ),
      );
      action = IconButton(
        icon: Icon(Icons.menu),
        onPressed: (){
          pageState._openEndDrawer();
        },
      );
      tabBar = _tabBar(pageState);
      break;
    case 1:
      titleWidget = GestureDetector(
        onTap: () async{
          Map<String, dynamic> result = await showSearch(
            context: pageState.context,
            delegate: LocationSearch(),
          );
          if (result != null) {
            print(result['latitude'].runtimeType);
            double lat = result['latitude'];
            double lng = result['longitude'];
            __LocalState.moveMap(lat, lng);
          }
        },
        child: UserText(
          text: '주변검색...',
          style: UserText.SUBHEAD,
          color: Colors.black45,
        ),
      );
      leading = IconButton(
        onPressed: () async{
          Map<String, dynamic> result = await showSearch(
            context: pageState.context,
            delegate: LocationSearch(),
          );
          if (result != null) {
            print(result['latitude'].runtimeType);
            double lat = result['latitude'];
            double lng = result['longitude'];
            __LocalState.moveMap(lat, lng);
          }
        },
        icon: Icon(Icons.search),
      );
      action = null;
      tabBar = _tabBar(pageState);
      break;
    case 2:
      title = '';
      leading = null;
      action = null;
      tabBar = null;
      break;
    case 3:
      title = '활동';
      leading = null;
      action = null;
      tabBar = null;
      break;
    case 4:
      return null;
      break;
  }


  return whiteAppbar(
    title: title ?? '',
    leading: leading,
    titleWidget: titleWidget,
    actions: action != null ? [action] : [Container()],
    bottom: tabBar,
  );
}

_tabBar(_MainPageState state){
  return TabBar(
    tabs: state._tabList.map((type){
      return Container(
        padding: EdgeInsets.only(bottom: 8),
        child: UserText(
          text: type,
          style: UserText.SUBTITLE,
        ),
      );
    }).toList(),
    labelPadding: EdgeInsets.symmetric(horizontal: 12),
    indicatorSize: TabBarIndicatorSize.label,
    isScrollable: true,
    controller: state._tabController,
    indicatorColor: Colors.black87,
    labelColor: Colors.black87,
    unselectedLabelColor: Colors.black45,
    onTap: state._onTabBarTab,
  );
}