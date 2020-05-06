

import 'dart:convert';

import 'package:http/http.dart';

class NetworkManager{
  static NetworkManager _instance = NetworkManager._internal();
  NetworkManager._internal();

  factory NetworkManager() => _instance;

  /// 특정 텍스트로 지명 검색
  Future<List<Map<String, dynamic>>> getPlaces(String query) async{
    String endPoint = 'https://asia-northeast1-lbstech-korea-service.cloudfunctions.net/magicFunction/getSearch?';
    String parameter = 'word=$query';
    Response response = await get(endPoint+parameter);
    if (response.statusCode == 200){
      List<Map<String, dynamic>> result = [];
      final jsonResponse = jsonDecode(response.body);
      for (Map map in jsonResponse){
        result.add({
          'name' : map['이름'],
          'address' : map['도로명주소'],
          'latitude' : double.parse(map['위도']),
          'longitude' : double.parse(map['경도']),
        });
      }
      return result;
    }else{
      print('getPlaces 의 연결 실패 : ${response.statusCode}');
      return null;
    }
  }

  /// 주변에 있는 지명들을 검색
  Future<List<Map<String, dynamic>>> getNearPlaceNames(double latitude, double longitude) async{
    String endPoint = 'https://asia-northeast1-lbstech-korea-service.cloudfunctions.net/magicFunction/getPublic?';
    String parameter = 'latitude=$latitude&longitude=$longitude&range=800&category=search';
    Response response = await get(endPoint+parameter);
    if (response.statusCode == 200){
       List<Map<String, dynamic>> result = [];
       final jsonResponse = jsonDecode(response.body);
       for (Map map in jsonResponse){
         result.add({
           'name' : map['이름'],
           'latitude' : double.parse(map['위도']),
           'longitude' : double.parse(map['경도']),
         });
       }
       return result;
    }else{
      print('getNearPlaceNames 의 연결 실패 : ${response.statusCode}');
      return null;
    }
  }

}