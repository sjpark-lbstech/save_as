part of main_page;

BottomNavigationBar _bottomNav(_MainPageState pageState){
  return BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    backgroundColor: Colors.white,
    onTap: pageState._onBottomNavTab,
    currentIndex: pageState._bottomNavIndex,
    items: [
      BottomNavigationBarItem(
        icon: ImageIcon(
          AssetImage(Assets.iconHome),
          color: Colors.black54,
          size: 28,
        ),
        title: Container(),
        activeIcon: ImageIcon(
          AssetImage(Assets.iconHomeActive),
          color: Colors.black87,
          size: 28,
        ),
      ),
      BottomNavigationBarItem(
        icon: ImageIcon(
          AssetImage(Assets.iconMap),
          color: Colors.black54,
          size: 28,
        ),
        title: Container(),
        activeIcon: ImageIcon(
          AssetImage(Assets.iconMapActive),
          color: Colors.black87,
          size: 28,
        ),
      ),
      BottomNavigationBarItem(
        icon: ImageIcon(
          AssetImage(Assets.iconAdd),
          color: Colors.black54,
          size: 28,
        ),
        title: Container(),
        activeIcon: ImageIcon(
          AssetImage(Assets.iconAddActive),
          color: Colors.black87,
          size: 28,
        ),
      ),
      BottomNavigationBarItem(
        icon: ImageIcon(
          AssetImage(Assets.iconHeart),
          color: Colors.black54,
          size: 28,
        ),
        title: Container(),
        activeIcon: ImageIcon(
          AssetImage(Assets.iconHeartActive),
          color: Colors.black87,
          size: 28,
        ),
      ),
      BottomNavigationBarItem(
        icon: ImageIcon(
          AssetImage(Assets.iconProfile),
          color: Colors.black54,
          size: 28,
        ),
        title: Container(),
        activeIcon: ImageIcon(
          AssetImage(Assets.iconProfileActive),
          color: Colors.black87,
          size: 28,
        ),
      ),
    ],
  );
}