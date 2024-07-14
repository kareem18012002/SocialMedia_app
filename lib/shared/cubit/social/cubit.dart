import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socialapp/models/massage_model.dart';
import 'package:socialapp/shared/components/widgets/navigate_to.dart';
import 'package:socialapp/shared/cubit/social/state.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../../../models/comment_model.dart';
import '../../../models/post_model.dart';
import '../../../models/user_model.dart';
import '../../../modules/social_modules/chats/chats_screen.dart';
import '../../../modules/social_modules/home/home_screen.dart';
import '../../../modules/social_modules/post/post_screen.dart';
import '../../../modules/social_modules/setting/settings_screen.dart';
import '../../../modules/social_modules/user/user_screen.dart';
import '../../components/constants.dart';

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(context) => BlocProvider.of(context);

  UserModel? userModel;

  void getUserData() {
    emit(SocialGetUserLoadingState());

    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      //print(value.data());
      userModel = UserModel.fromJson(value.data()!);
      emit(SocialGetUserSuccessState());
    }).catchError((error) {
      debugPrint(error.toString());
      emit(SocialGetUserErrorState(error.toString()));
    });
  }

  int currentIndex = 0;

  List<Widget> screens = [
    FeedsScreen(),
    const ChatsScreen(),
    PostScreen(),
    const UserScreen(),
    SettingsScreen(),
  ];

  List<String> titles = [
    'Home',
    'Chats',
    'Post',
    'Users',
    'Settings',
  ];

  void changeBottomNav(int index, context) {
    if (index == 1) {
      getAllUsers();
    }
    if (index == 2) {
      navigateTo(context, PostScreen());
      emit(SocialNewPostState());
    } else {
      currentIndex = index;
      emit(SocialChangeBottomNavState());
    }
  }

  File? profileImage;
  var picker = ImagePicker();

  Future<void> getProfileImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      debugPrint(pickedFile.path);
      emit(SocialProfileImagePickedSuccessState());
    } else {
      debugPrint('No image selected.');
      emit(SocialProfileImagePickedErrorState());
    }
  }

  // image_picker7901250412914563370.jpg

  File? coverImage;

  Future<void> getCoverImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(SocialCoverImagePickedSuccessState());
    } else {
      debugPrint('No image selected.');
      emit(SocialCoverImagePickedErrorState());
    }
  }

  void uploadProfileImage({
    required String name,
    required String phone,
    required String bio,
  }) {
    emit(SocialUserUpdateLoadingState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri
        .file(profileImage!.path)
        .pathSegments
        .last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        //emit(SocialUploadProfileImageSuccessState());
        debugPrint(value);
        updateUser(
          name: name,
          phone: phone,
          bio: bio,
          image: value,
        );
      }).catchError((error) {
        emit(SocialUploadProfileImageErrorState());
      });
    }).catchError((error) {
      emit(SocialUploadProfileImageErrorState());
    });
  }

  void uploadCoverImage({
    required String name,
    required String phone,
    required String bio,
  }) {
    emit(SocialUserUpdateLoadingState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri
        .file(coverImage!.path)
        .pathSegments
        .last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        //emit(SocialUploadCoverImageSuccessState());
        debugPrint(value);
        updateUser(
          name: name,
          phone: phone,
          bio: bio,
          cover: value,
        );
      }).catchError((error) {
        emit(SocialUploadCoverImageErrorState());
      });
    }).catchError((error) {
      emit(SocialUploadCoverImageErrorState());
    });
  }

//   void updateUserImages({
//   @required String name,
//   @required String phone,
//   @required String bio,
// })
//   {
//     emit(SocialUserUpdateLoadingState());
//
//     if(coverImage != null)
//     {
//       uploadCoverImage();
//     } else if(profileImage != null)
//     {
//       uploadProfileImage();
//     } else if (coverImage != null && profileImage != null)
//     {
//
//     } else
//       {
//         updateUser(
//           name: name,
//           phone: phone,
//           bio: bio,
//         );
//       }
//   }

  void updateUser({
    required String name,
    required String phone,
    required String bio,
    String? cover,
    String? image,
  }) {
    UserModel model = UserModel(
      name: name,
      phone: phone,
      bio: bio,
      email: userModel?.email,
      cover: cover ?? userModel?.cover,
      image: image ?? userModel?.image,
      uId: userModel?.uId,
      isEmailVerified: false,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel?.uId)
        .update(model.toMap())
        .then((value) {
      getUserData();
    }).catchError((error) {
      emit(SocialUserUpdateErrorState());
    });
  }

  File? postImage;

  Future<void> getPostImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(SocialPostImagePickedSuccessState());
    } else {
      debugPrint('No image selected.');
      emit(SocialPostImagePickedErrorState());
    }
  }

  void removePostImage() {
    postImage = null;
    emit(SocialRemovePostImageState());
  }

  void uploadPostImage({
    required String text,
    required String dateTime,
  }) {
    emit(SocialCreatePostLoadingState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('Posts/${Uri
        .file(postImage!.path)
        .pathSegments
        .last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        //emit(SocialUploadCoverImageSuccessState());
        debugPrint(value);
        createPost(
          postImage: value,
          text: text,
          dateTime: dateTime,
        );
      }).catchError((error) {
        emit(SocialUploadCoverImageErrorState());
      });
    }).catchError((error) {
      emit(SocialUploadCoverImageErrorState());
    });
  }

  void createPost({
    required String text,
    required String dateTime,
    String? postImage,
  }) {
    emit(SocialCreatePostLoadingState());
    PostModel model = PostModel(
      name: userModel?.name,
      image: userModel?.image,
      uId: userModel?.uId,
      text: text,
      dateTime: dateTime,
      postImage: postImage ?? '',
    );

    FirebaseFirestore.instance
        .collection('Posts')
        .add(model.toMap())
        .then((value) {
      emit(SocialCreatePostSuccessState());
      removePostImage();
    }).catchError((error) {
      emit(SocialCreatePostErrorState());
    });
  }

  List<PostModel> posts = [];
  List<String> postId = [];
  List<int> likes = [];
  List<int> commentsNum = [];

  void getPost() {
    emit(SocialGetPostsLoadingState());
    FirebaseFirestore.instance.collection('Posts').snapshots().listen((event) {
      posts = [];
      postId = [];
      for (var element in event.docs) {
        element.reference.collection('Likes').get().then((value) {
          likes.add(value.docs.length);
        }).catchError((error) {});
        element.reference.collection('Comments').get().then((value) {
          posts.add(PostModel.fromJson(element.data()));
          postId.add(element.id);
          commentsNum.add(value.docs.length);
        }).catchError((error) {});
      }
      emit(SocialGetPostsSuccessState());
    });
  }

  void likePost(String postId) {
    FirebaseFirestore.instance
        .collection('Posts')
        .doc(postId)
        .collection('Likes')
        .doc(userModel?.uId)
        .set({'like': true}).then((value) {
      emit(SocialLikePostSuccessState());
    }).catchError((error) {
      emit(SocialLikePostErrorState(error.toString()));
    });
  }

  late List<UserModel> users;

  void getAllUsers() {
    emit(SocialGetAllUsersLoadingState());
    users = [];
    FirebaseFirestore.instance.collection('users').snapshots().listen((event) {
      for (var element in event.docs) {
        if (element.data()['uId'] != userModel?.uId) {
          users.add(UserModel.fromJson(element.data()));
        }
      }
      emit(SocialGetAllUsersSuccessState());
    });
  }

  void sendMassage({
    String? receiverId,
    String? text,
    String? massageImage,
    String? dateTime,
  }) {
    MassageModel model = MassageModel(
        text: text,
        dateTime: dateTime,
        receiverId: receiverId,
        massageImage: massageImage,
        senderId: userModel?.uId);

    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel?.uId)
        .collection('Chats')
        .doc(receiverId)
        .collection('Massages')
        .add(model.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
      text = '';
    }).catchError((error) {
      emit(SocialSendMessageErrorState());
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('Chats')
        .doc(userModel?.uId)
        .collection('Massages')
        .add(model.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState());
    });
  }

  List<MassageModel> massages = [];

  getMassages({String? receiverId}) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel?.uId)
        .collection('Chats')
        .doc(receiverId)
        .collection('Massages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      massages = [];
      for (var element in event.docs) {
        massages.add(MassageModel.fromJson(element.data()));
      }
      emit(SocialGetMessagesSuccessState());
    });
  }

  File? commentImage;

  Future<void> getCommentImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      commentImage = File(pickedFile.path);
      emit(SocialCommentImagePickedSuccessState());
    } else {
      debugPrint('No image selected.');
      emit(SocialCommentImagePickedErrorState());
    }
  }

  void removeCommentImage() {
    commentImage = null;
    emit(SocialRemoveCommentImageState());
  }

  void sendComment({
    String? text,
    String? dateTime,
    String? postId,
  }) {
    emit(SocialSendCommentLoadingState());
    CommentModel model = CommentModel(
      name: userModel?.name,
      image: userModel?.image,
      uId: userModel?.uId,
      text: text,
      dateTime: dateTime,
    );

    FirebaseFirestore.instance
        .collection('Posts')
        .doc(postId)
        .collection('Comments')
        .add(model.toMap())
        .then((value) {
      emit(SocialSendCommentSuccessState());
    }).catchError((error) {
      emit(SocialSendCommentErrorState());
    });
  }

  List<CommentModel> comments = [];

  getComment(String? postId) {
    FirebaseFirestore.instance
        .collection('Posts')
        .doc(postId)
        .collection('Comments')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      comments = [];
      for (var element in event.docs) {
        comments.add(CommentModel.fromJson(element.data()));
      }
      print(comments);
      emit(SocialGetCommentsSuccessState());
    });
  }
}
