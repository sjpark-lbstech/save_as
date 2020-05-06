import 'package:save_as/data/data_interface.dart';

class UserData implements DataInterface{
  static const IDX = 'idx';
  static const ID = 'id';
  static const NAME = 'name';
  static const EMAIL = 'email';
  static const IMAGE = 'image';
  static const THUMBNAIL = 'thumbnail';
  static const STATE = 'state';
  static const DATE_JOIN = 'date_join';
  static const DATE_CHANGE = 'date_change';
  static const DATE_OUT = 'date_out';

  int idx;
  String id;
  String name;
  String email;
  String image;
  String thumbnail;
  int state;
  int date_join;
  int date_change;
  int date_out;

  UserData({this.idx, this.id, this.email, this.image, this.thumbnail,
    this.state, this.date_join, this.date_change, this.date_out, this.name});

  factory UserData.fromMap(Map map){

    int idxTmp = map[IDX] == null ? null : map[IDX] is String ? int.parse(map[IDX]) : map[IDX];
    int stateTmp = map[STATE] == null ? null : map[STATE] is String ? int.parse(map[STATE]) : map[STATE];
    int date_joinTmp = map[DATE_JOIN] == null ? null : map[DATE_JOIN] is String ? int.parse(map[DATE_JOIN]) : map[DATE_JOIN];
    int date_changeTmp = map[DATE_CHANGE] == null ? null : map[DATE_CHANGE] is String ? int.parse(map[DATE_CHANGE]) : map[DATE_CHANGE];
    int date_outTmp = map[DATE_OUT] == null ? null : map[DATE_OUT] is String ? int.parse(map[DATE_OUT]) : map[DATE_OUT];

    return UserData(
      idx: idxTmp,
      id: map[ID],
      name : map[NAME],
      email: map[EMAIL],
      image: map[IMAGE],
      thumbnail: map[THUMBNAIL],
      state: stateTmp,
      date_join: date_joinTmp,
      date_change: date_changeTmp,
      date_out: date_outTmp,
    );
  }

  @override
  int getServerPrimaryKey() {
    return idx;
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      IDX : idx,
      ID : id,
      NAME : name,
      EMAIL : email,
      IMAGE : image,
      THUMBNAIL : thumbnail,
      STATE : state,
      DATE_JOIN : date_join,
      DATE_CHANGE : date_change,
      DATE_OUT : date_out,
    };
  }

  @override
  bool operator ==(other) {
    return other is UserData &&
        this.idx == other.idx;
  }

}