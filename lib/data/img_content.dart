import 'dart:io';

class ImageContent {

  final int index;
  final String mimeType;
  final String title;
  String originPath;
  String thumbnailPath;

  factory ImageContent.fromMap(Map map){
    return ImageContent(
      index: map['index'],
      mimeType: map['mimeType'],
      title: map['title'],
      originPath: map['absolutePath'],
      thumbnailPath: map['thumbnailPath'],
    );
  }

  ImageContent({this.index, this.mimeType, this.title,
    this.originPath, this.thumbnailPath});


  File get originFile{
    if(originPath == null) return null;
    return File(originPath);
  }

  File get thumbnailFile {
    if (thumbnailPath == null) {
      print('ImageContent.thumbnailFile Error \n>> $originPath 의 썸네일 경로가 없습니다.');
      return null;
    }
    return File(thumbnailPath);
  }

  @override
  bool operator ==(other) {
    // TODO: implement ==
    if (other is ImageContent) {
      return other.index == this.index;
    }else return false;
  }

  @override
  // TODO: implement hashCode
  int get hashCode => this.index;

}