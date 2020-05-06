import 'package:flutter/material.dart';
import 'package:save_as/channel/ch_permission.dart';
import 'package:save_as/components/text.dart';
import 'package:save_as/route.dart';
import 'package:save_as/rsc/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';


class PermissionPage extends StatefulWidget {
  @override
  _PermissionPageState createState() => _PermissionPageState();
}

class _PermissionPageState extends State<PermissionPage> {

  int _weightSum;
  double _screenHeight;
  double _weightHeight;

  PermissionChannel _channel;

  @override
  void initState() {
    super.initState();
    _weightSum = 10;
    _channel = PermissionChannel();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: _body()
      ),
    );
  }

  Widget _body() {
    return Container(
        padding: EdgeInsets.all(16),
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints){
              _screenHeight = constraints.biggest.height;
              _weightHeight = _screenHeight / _weightSum;

              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[

                  Container(
                    height: _weightHeight * 1,
                    child: Center(
                      child: UserText(
                        text: PermissionText.ctapti,
                        style: UserText.SUBHEAD,
                      ),
                    ),
                  ),

                  Container(
                    height: _weightHeight * 1,
                    child: UserText(
                      text: PermissionText.ctbgst,
                      style: UserText.BODY_2,
                      textAlign: TextAlign.center,
                      color: Colors.black54,
                    ),
                  ),

                  _permissionList(),

                  Container(
                    height: _weightHeight * 1,
                    child: Center(
                      child: UserText(
                        text: PermissionText.cbbgan,
                        style: UserText.BODY_2,
                        color: Colors.black54,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  MaterialButton(
                    color: Theme.of(context).primaryColor,
                    height: _weightHeight * 1,
                    onPressed: _getPermission,
                    child: UserText(
                      text: PermissionText.cbbtti,
                      style: UserText.SUBHEAD,
                      color: Colors.white,
                    ),
                  ),

                ],
              );
            }
        )
    );
  }

  _permissionList() {
    return Container(
      height: _weightHeight * 6,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            height: 1.5,
            color: Colors.black38,
          ),

          _permissionListItem(type: 1),
          _permissionListItem(type: 2),
          _permissionListItem(type: 3),
          _permissionListItem(type: 4),

          Container(
            margin: EdgeInsets.only(bottom: 0),
            height: 1.5,
            color: Colors.black38,
          ),
        ],
      ),
    );
  }

  Widget _permissionListItem({@required int type}){
    String typeTitle;
    String desc;
    IconData icon;

    switch(type){
      case 1:
        typeTitle = PermissionText.ccliti1;
        desc = PermissionText.cclist1;
        icon = Icons.camera_alt;
        break;
      case 2:
        typeTitle = PermissionText.ccliti2;
        desc = PermissionText.cclist2;
        icon = Icons.location_on;
        break;
      case 3:
        typeTitle = PermissionText.ccliti3;
        desc = PermissionText.cclist3;
        icon = Icons.storage;
        break;
      case 4:
        typeTitle = PermissionText.ccliti4;
        desc = PermissionText.cclist4;
        icon = Icons.mic;
        break;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
            margin: EdgeInsets.symmetric(horizontal: 24),
            child: Icon(icon, size: 40, color: Colors.black45,)
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: <Widget>[
            UserText(
              text: typeTitle,
              style: UserText.BODY_1,
            ),
            UserText(
              text: desc,
              style: UserText.BODY_2,
              color: Colors.black54,
            ),
          ],
        )
      ],
    );
  }

  _getPermission() {
    _channel.checkState().then((boolean){
      if(boolean){

      }else{
        _channel.requestPermission().then((value){
          if(value){

          }else{
            _channel.requestPermission().then((_){

            });
          }
        });
      }
      Navigator.of(context).pushReplacementNamed(Router.POLICY);
    });
  }

}
