class CommentModel {
  String? name;
  String? uId;
  String? image;
  String? text;
  String? commentImage;
  String? dateTime;

  CommentModel({
    this.uId,
    this.text,
    this.name,
    this.commentImage,
    this.image,
    this.dateTime,
  });

  CommentModel.fromJson(Map<String, dynamic> json) {
    uId = json['uId'];
    name = json['name'];
    image = json['image'];
    text = json['text'];
    dateTime = json['dateTime'];
    commentImage = json['commentImage'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uId': uId,
      'image': image,
      'text': text,
      'dateTime': dateTime,
      'commentImage': commentImage,
    };
  }
}
