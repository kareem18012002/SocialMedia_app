class MassageModel {
  String? senderId;
  String? receiverId;
  String? text;
  String? massageImage;
  String? dateTime;

  MassageModel({
    this.senderId,
    this.receiverId,
    this.text,
    this.massageImage,
    this.dateTime,
  });

  MassageModel.fromJson(Map<String, dynamic> json) {
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    text = json['text'];
    dateTime = json['dateTime'];
    massageImage = json['massageImage'];
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'dateTime': dateTime,
      'massageImage': massageImage,
    };
  }
}
