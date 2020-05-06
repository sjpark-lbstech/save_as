import 'package:flutter/material.dart';
import 'package:save_as/components/text.dart';

AppBar whiteAppbar({String title = '', Widget titleWidget, List<Widget> actions, Widget leading,
  double elevation = 1.0, Color backgroundColor = Colors.white,
  bool centerTitle = false, PreferredSizeWidget bottom,
  bool automaticallyImplyLeading = false}){
  return AppBar(
    title: titleWidget ?? UserText(
      text: title,
      style: UserText.SUBHEAD,
    ),
    centerTitle: centerTitle,
    iconTheme: IconThemeData(color: Colors.black87),
    automaticallyImplyLeading: automaticallyImplyLeading,
    backgroundColor: backgroundColor,
    elevation: elevation,
    leading: leading,
    actions: actions,
    bottom: bottom,
  );
}