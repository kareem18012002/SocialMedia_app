class PostModel {
  String? name;
  String? uId;
  String? image;
  String? text;
  String? postImage;
  String? dateTime;
  String? postId;

  PostModel({
    this.uId,
    this.text,
    this.name,
    this.postImage,
    this.image,
    this.dateTime,
    this.postId,
  });

  PostModel.fromJson(Map<String, dynamic> json) {
    uId = json['uId'];
    name = json['name'];
    image = json['image'];
    text = json['text'];
    dateTime = json['dateTime'];
    postImage = json['postImage'];
    postId = json['postId'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uId': uId,
      'image': image,
      'text': text,
      'dateTime': dateTime,
      'postImage': postImage,
      'postId': postId,
    };
  }
}
