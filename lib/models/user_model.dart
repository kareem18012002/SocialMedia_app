class UserModel {
  String? email;
  String? phone;
  String? name;
  String? uId;
  String? image;
  String? cover;
  String? bio;
  bool? isEmailVerified ;

  UserModel(
      {
        this.uId,
        this.phone,
        this.name,
        this.email,
        this.image,
        this.cover,
        this.bio,
        this.isEmailVerified});

  UserModel.fromJson(Map<String, dynamic> json) {
    uId = json['uId'];
    email = json['email'];
    name = json['name'];
    phone = json['phone'];
    image = json['image'];
    cover = json['cover'];
    bio = json['bio'];
    isEmailVerified = json['isEmailVerified'];
  }
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'phone': phone,
      'uId': uId,
      'image': image,
      'cover': cover,
      'bio': bio,
      'isEmailVerified': isEmailVerified,
    };
  }
}