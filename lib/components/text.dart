import 'package:flutter/material.dart';

class UserText extends StatefulWidget {

  /// 크기 : 30, 두께 : w600 (bold), 색갈 : black84
  static const int HEADLINE = 0XFBB05;

  /// 크기 : 25, 두께 : w600 (bold), 색갈 : black84
  static const int TITLE = 0XFBB06;

  /// 크기 : 17, 두께 : w600 (bold), 색갈 : black84
  static const int SUBHEAD = 0XFBB07;

  /// 크기 : 15, 두께 : w600 (bold), 색갈 : black84
  static const int SUBTITLE = 0XFBB08;

  /// 크기 : 13, 두께 : w600 (bold), 색갈 : black84
  static const int BODY_1 = 0XFBB09;

  /// 크기 : 13, 두께 : w300 (regular), 색갈 : black84
  static const int BODY_2 = 0XFBB10;

  /// 크기 : 13, 두께 : w600 (bold), 색갈 : white
  static const int BTN = 0XFBB11;

  /// 크기 : 11, 두께 : w300 (regular), 색갈 : black84
  static const int CAPTION = 0XFBB12;

  /// 크기 : 11, 두께 : w600 (bold), 색갈 : black84
  static const int OVER_LINE = 0XFBB13;

  /// 크기 : 30, 두께 : w600 (bold), 색갈 : black84
  static TextStyle headLine(BuildContext context) => Theme.of(context).textTheme.headline;

  /// 크기 : 25, 두께 : w600 (bold), 색갈 : black84
  static TextStyle title(BuildContext context) => Theme.of(context).textTheme.title;

  /// 크기 : 17, 두께 : w600 (bold), 색갈 : black84
  static TextStyle subHead(BuildContext context) => Theme.of(context).textTheme.subhead;

  /// 크기 : 15, 두께 : w600 (bold), 색갈 : black84
  static TextStyle subtitle(BuildContext context) => Theme.of(context).textTheme.subtitle;

  /// 크기 : 13, 두께 : w600 (bold), 색갈 : black84
  static TextStyle body1(BuildContext context) => Theme.of(context).textTheme.body1;

  /// 크기 : 13, 두께 : w300 (regular), 색갈 : black84
  static TextStyle body2(BuildContext context) => Theme.of(context).textTheme.body2;

  /// 크기 : 13, 두께 : w600 (bold), 색갈 : white
  static TextStyle button(BuildContext context) => Theme.of(context).textTheme.button;

  /// 크기 : 11, 두께 : w300 (regular), 색갈 : black84
  static TextStyle caption(BuildContext context) => Theme.of(context).textTheme.caption;

  /// 크기 : 11, 두께 : w600 (bold), 색갈 : black84
  static TextStyle overLine(BuildContext context) => Theme.of(context).textTheme.overline;


  final String text;
  final Color color;
  final int style;
  final TextAlign textAlign;
  final TextOverflow overflow;
  final int maxLine;
  final FontWeight fontWeight;
  final double letterSpacing;

  UserText({@required this.text, this.color = Colors.black87, @required this.style,
    this.textAlign = TextAlign.start, this.overflow = TextOverflow.ellipsis,
    this.maxLine, this.fontWeight, this.letterSpacing})
  {
    if (style < 0XFBB01 || style > 0XFBB13){
      RangeError.range(style, HEADLINE, OVER_LINE);
    }
  }

  @override
  _UserTextState createState() => _UserTextState();
}

class _UserTextState extends State<UserText> {
  TextStyle _style;

  @override
  void didChangeDependencies() {
    _setStyle();
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(UserText oldWidget) {
   _setStyle();
    super.didUpdateWidget(oldWidget);
  }

  void _setStyle(){
    switch (widget.style){
      case UserText.HEADLINE :
        _style = Theme.of(context).textTheme.headline;
        break;
      case UserText.TITLE :
        _style = Theme.of(context).textTheme.title;
        break;
      case UserText.SUBHEAD :
        _style = Theme.of(context).textTheme.subhead;
        break;
      case UserText.SUBTITLE :
        _style = Theme.of(context).textTheme.subtitle;
        break;
      case UserText.BODY_1 :
        _style = Theme.of(context).textTheme.body1;
        break;
      case UserText.BODY_2 :
        _style = Theme.of(context).textTheme.body2;
        break;
      case UserText.BTN :
        _style = Theme.of(context).textTheme.button;
        break;
      case UserText.CAPTION :
        _style = Theme.of(context).textTheme.caption;
        break;
      case UserText.OVER_LINE :
        _style = Theme.of(context).textTheme.overline;
        break;
      default :
        ArgumentError.notNull('_UserTextState initState 에서 style null!');
        break;
    }
    if (widget.color != null) {
      _style = _style.copyWith(color: widget.color);
    }
    if (widget.fontWeight != null){
      _style = _style.copyWith(fontWeight: widget.fontWeight);
    }
    _style = _style.copyWith(letterSpacing: widget.letterSpacing);
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text ?? '',
      style: _style,
      textAlign: widget.textAlign,
      overflow: widget.overflow,
      maxLines: widget.maxLine,
      softWrap: true,
    );
  }

}
