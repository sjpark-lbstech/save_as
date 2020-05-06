import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:save_as/channel/ch_main.dart';
import 'package:save_as/components/text.dart';
import 'package:save_as/utility/network_manager.dart';

class LocationSearch extends SearchDelegate<Map<String, dynamic>> {

  @override
  String get searchFieldLabel => '장소 검색';

  double _lat, _lng;

  // 현제 주소
  Completer<String> _address = Completer();
  Completer<List<Map<String, dynamic>>> _searchResult = Completer();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(
          Icons.clear,
          color: Colors.black87,
        ),
        onPressed: (){
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: Colors.black87,
      ),
      onPressed: (){
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    _searchPlace(query);
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _searchResult.future,
      initialData: [],
      builder: (context, snapshot){
        if (snapshot.connectionState == ConnectionState.waiting){
          return Center(
            child: CircularProgressIndicator(),
          );
        }else {
          if (snapshot.data != null){
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  snapshot.data.isNotEmpty ?
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: snapshot.data.map((map){
                      return ListTile(
                        title: UserText(
                          text: map['name'],
                          style: UserText.SUBTITLE,
                        ),
                        subtitle: UserText(
                          text: map['address'],
                          style: UserText.BODY_1,
                          color: Colors.black54,
                        ),
                        onTap: (){
                          close(context, map);
                        },
                      );
                    }).toList(),
                  ) : _missingResult('검색 결과가 없습니다.'),
                ],
              ),
            );
          }else {
            return _missingResult('검색중 오류가 발생했습니다.');
          }
        }
      },
    );
  }

  /// 특정 단어로 검색
  void _searchPlace(String query) {
    if (query == null || query.isEmpty){
      _searchResult.complete(null);
      return;
    }
    if (_searchResult.isCompleted){
      _searchResult = Completer();
    }
    _searchResult.complete(NetworkManager().getPlaces(query));
  }


  @override
  Widget buildSuggestions(BuildContext context) {
    _getAddress();
    return FutureBuilder<String>(
      future: _address.future,
      initialData: '',
      builder: (context, snapshot){
        if (snapshot.connectionState == ConnectionState.waiting){
          // future 수행중
          return ListTile(
            title: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        else{
          if (snapshot.data != null){
            // 성공적인 주소 검색
            return ListTile(
              leading: Container(
                padding: EdgeInsets.all(8),
                child: Icon(
                  Icons.place,
                ),
              ),
              title: UserText(
                text: '현재 위치로 지정',
                style: UserText.SUBTITLE,
              ),
              subtitle: UserText(
                text: snapshot.data,
                style: UserText.BODY_2,
              ),
              onTap: (){
                assert (_lat != null && _lng != null);
                close(context, {
                  'address' : snapshot.data,
                  'latitude' : _lat,
                  'longitude' : _lng,
                });
              },
            );
          }else {
            // 주소 검색 실패
            return _missingResult('현재 위치를 찾을 수 없습니다.');
          }
        }

      },
    );
  }

  Future<void> _getAddress() async{
    final map = await MainChannel().getLocation();
    if (map == null) {
      print('map is null');
      _address.complete(null);
      return;
    }
    print(map);
    _lat = map['latitude'];
    _lng = map['longitude'];
    List<Address> addresses = await Geocoder.local.findAddressesFromCoordinates(
        Coordinates(_lat, _lng));
    if (addresses == null || addresses.isEmpty) _address.complete(null);
    Address firstAddress = addresses.first;

    if (_address.isCompleted) return;
    _address.complete(firstAddress.addressLine);
  }

}

class PlaceSearch extends SearchDelegate<Map<String, dynamic>> {

  Completer<List<Map<String, dynamic>>> _arounds = Completer();
  Completer<List<Map<String, dynamic>>> _searchResult = Completer();

  @override
  String get searchFieldLabel => '장소 검색';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(
          Icons.clear,
          color: Colors.black87,
        ),
        onPressed: (){
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: Colors.black87,
      ),
      onPressed: (){
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    _searchPlace(query);
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _searchResult.future,
      initialData: [],
      builder: (context, snapshot){
        if (snapshot.connectionState == ConnectionState.waiting){
          return Center(
            child: CircularProgressIndicator(),
          );
        }else {
          if (snapshot.data != null){
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  ListTile(
                    title: UserText(
                      text: '현재 검색어 선택',
                      style: UserText.BODY_2,
                    ),
                    subtitle: UserText(
                      text: query,
                      style: UserText.SUBTITLE,
                    ),
                    onTap: (){
                      close(context, {
                        'name' : query,
                        'latitude' : null,
                        'longitude' : null});
                    },
                  ),

                  Divider(height: 0,),

                  snapshot.data.isNotEmpty ?
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: snapshot.data.map((map){
                      return ListTile(
                        title: UserText(
                          text: map['name'],
                          style: UserText.SUBTITLE,
                        ),
                        subtitle: UserText(
                          text: map['address'],
                          style: UserText.BODY_1,
                          color: Colors.black54,
                        ),
                        onTap: (){
                          close(context, map);
                        },
                      );
                    }).toList(),
                  ) : _missingResult('검색 결과가 없습니다.'),
                ],
              ),
            );
          }else {
            return _missingResult('검색중 오류가 발생했습니다.');
          }
        }
      },
    );
  }

  /// 특정 단어로 검색
  void _searchPlace(String query) {
    if (query == null || query.isEmpty){
      _searchResult.complete(null);
      return;
    }
    if (_searchResult.isCompleted){
      _searchResult = Completer();
    }
    _searchResult.complete(NetworkManager().getPlaces(query));
  }


  @override
  Widget buildSuggestions(BuildContext context) {
    _getNearPlaceName();
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _arounds.future,
      initialData: [],
      builder: (context, snapshot){
        if (snapshot.connectionState == ConnectionState.waiting){
          return Center(
            child: CircularProgressIndicator(),
          );
        }else {
          if (snapshot.data != null){
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, pos){
                Map data = snapshot.data[pos];
                return ListTile(
                  title: UserText(
                    text: data['name'],
                    style: UserText.SUBTITLE,
                  ),
                  onTap: (){
                    close(context, data);
                  },
                );
              },
            );
          }else {
            return _missingResult('주변 지명을 찾을 수 없습니다.');
          }
        }
      },
    );
  }

  /// 주변 추천 지역
  void _getNearPlaceName() async {
    Map location = await MainChannel().getLocation();
    double latitude = location['latitude'];
    double longitude = location['longitude'];
    if (_arounds.isCompleted){
      return;
    }
    _arounds.complete(NetworkManager().getNearPlaceNames(latitude, longitude));
  }


}

Widget _missingResult(String message){
  return ListTile(
    leading: Icon(
      Icons.clear,
    ),
    title: UserText(
      text: message,
      style: UserText.BODY_1,
      color: Colors.black45,
    ),
  );
}