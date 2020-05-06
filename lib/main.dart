import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:save_as/channel/ch_main.dart';
import 'package:save_as/route.dart';
import 'package:save_as/rsc/meta.dart';
import 'package:save_as/rsc/strings.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  Map map = await MainChannel().getInformation();
  Meta.osType = map['osType'];
  Meta.androidSDK = map['version'];

  if(Meta.androidSDK != null && Meta.androidSDK >= 24) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark
    ));
  }
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(MyApp());
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: Router.getRouter(),
      initialRoute: Router.INTRO,
      theme: _themeData(),
      onGenerateRoute: Router.onGenerateRoute,
    );
  }

  ThemeData _themeData() {
    return ThemeData(
      primaryColor: Color(0xffE5AA17),
      accentColor: Color(0xffFBE224),
      backgroundColor: Colors.white,
      textTheme: _textTheme(),
      scaffoldBackgroundColor: Colors.white,
    );
  }

  TextTheme _textTheme() {
    return TextTheme(
      headline: TextStyle(
        fontSize: 30.0,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
        color: Colors.black87,
        height: 1.3,
      ),
      title: TextStyle(
        fontSize: 25.0,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
        letterSpacing: -0.5,
        height: 1.3,
      ),
      subhead: TextStyle(
        fontSize: 17.0,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
        letterSpacing: -0.5,
        height: 1.3,
      ),
      subtitle: TextStyle(
        fontSize: 15.0,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
        letterSpacing: -0.5,
        height: 1.3,
      ),
      body1: TextStyle(
        fontSize: 13.0,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
        color: Colors.black87,
        height: 1.3,
      ),
      body2: TextStyle(
        fontSize: 13.0,
        fontWeight: FontWeight.w300,
        color: Colors.black87,
        letterSpacing: -0.5,
        height: 1.3,
      ),
      button: TextStyle(
        fontSize: 13.0,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
        color: Colors.white,
        height: 1.3,
      ),
      caption: TextStyle(
        fontSize:11.0,
        fontWeight: FontWeight.w300,
        color: Colors.black87,
        letterSpacing: -0.5,
        height: 1.3,
      ),
      overline: TextStyle(
        fontSize: 11.0,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
        letterSpacing: -0.5,
        height: 1.3,
      ),
    );
  }

}

