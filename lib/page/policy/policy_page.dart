import 'dart:async';

import 'package:flutter/material.dart';
import 'package:save_as/components/appbar.dart';
import 'package:save_as/components/text.dart';
import 'package:save_as/route.dart';
import 'package:save_as/rsc/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';


class PolicyPage extends StatefulWidget {
  @override
  _PolicyPageState createState() => _PolicyPageState();
}

class _PolicyPageState extends State<PolicyPage> {
  /// LayoutBuilder 로 Screen width, Height
  double _screenHeight;
  double _weightHeight;

  List<String> _typeList;
  List<String> _urlList;
  List<bool> _agreeList;

  bool _agreeAll = false;

  /// 동의버튼 onPressed. init at build().
  Function _checkPolicy;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _typeList = [PolicyText.ltliti, PolicyText.lcliti, PolicyText.lbliti];
    _urlList = [PolicyText.termsUrl, PolicyText.privateUrl, PolicyText.locationUrl];
    _agreeList = [false, false, false];
  }

  @override
  Widget build(BuildContext context) {

    /// onPress init - 버튼의 enable, disable 표시떄문에 ...
    if(_agreeAll){
      _checkPolicy = (){
        SharedPreferences.getInstance().then((pref)=>pref.setBool('policy', true));
        Navigator.of(context).pushReplacementNamed(Router.MAIN);
      };
    }else _checkPolicy = null;

    return SafeArea(
      child: Scaffold(
        body: _body(),
      ),
    );
  }

  /// widget - body
  Widget _body() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16),
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraint){
            _screenHeight = constraint.biggest.height;
            _weightHeight = _screenHeight / 10;
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  height: _weightHeight,
                  child: Center(
                    child: UserText(
                      text: PolicyText.ctbgti,
                      style: UserText.SUBHEAD,
                    ),
                  ),
                ),

                _policyList(),

                /// 전체동의 체크박스, 텍스트
                Container(
                  padding: EdgeInsets.only(left: 16),
                  height: _weightHeight ,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Checkbox(value: _agreeAll, onChanged: (value){
                        setState(() {
                          _agreeAll = !_agreeAll;
                          if(value) _agreeList = _agreeList.map((v)=>value).toList();
                          else _agreeList = _agreeList.map((v)=>false).toList();
                        });
                      }),
                      UserText(
                        text: PolicyText.lbbgti,
                        style: UserText.BODY_1,
                      ),
                    ],
                  ),
                ),

                /// 확인 버튼
                MaterialButton(
                  disabledColor: Colors.black38,
                  height: _weightHeight,
                  color: Theme.of(context).primaryColor,
                  onPressed: _checkPolicy,
                  child: UserText(
                    text: PolicyText.cbbtti,
                    style: UserText.SUBHEAD,
                    color: Colors.white,
                  ),
                ),

              ],
            );
          }
      ),
    );
  }

  /// widget - 리스트 뷰
  Widget _policyList() {
    return Container(
        height: _weightHeight * 7,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _policyListItem(0),
            _policyListItem(1),
            _policyListItem(2),
          ],
        )
    );
  }

  /// widget - 개별 아이템
  Widget _policyListItem(int index) {
    assert(index >= 0);
    if(index >= _typeList.length) return null;
    return Card(
      elevation: 6,
      child: Container(
        color: Colors.white,
        height: _weightHeight * 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(

              contentPadding: EdgeInsets.only(left: 30),
              title: Text(_typeList[index]),
            ),
            Divider(height: 1, color: Colors.black87,),
            ListTile(
              leading: Checkbox(value: _agreeList[index], onChanged: (value) {
                setState(()=> _agreeList[index] = value);
                _agreeAll = _agreeList[0] && _agreeList[1] && _agreeList[2];
              }),
              title: UserText(
                text: PolicyText.lclian,
                style: UserText.BODY_2,
              ),
              trailing: MaterialButton(
                color: Theme.of(context).primaryColor,
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return _showDetail(index);
                  }));
                },
                child: UserText(
                  text: PolicyText.rcbtti,
                  style: UserText.BODY_2,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// widget - web view
  Widget _showDetail(int index) {
    Completer<WebViewController> _controller = Completer<WebViewController>();

    return Scaffold(
      appBar: whiteAppbar(title: _typeList[index]),
      body: Builder(builder: (BuildContext context){
        return WebView(
          initialUrl: _urlList[index],
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController c)=> _controller.complete(c),
        );
      }),
    );
  }

}
