import 'dart:io' as Io;
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:social_app/cubits/posts_cubit/posts_states.dart';
import 'package:social_app/cubits/user_cubit/user_cubit.dart';
import 'package:social_app/models/comment_model.dart';
import 'package:social_app/models/user_data.dart';

import '../../components/components.dart';
import '../../components/constants.dart';
import '../../models/post_model.dart';
import '../../screens/posts_screen/comments_screen.dart';

class PostsCubit extends Cubit<PostsStates> {
  PostsCubit() : super(PostsCubitInitialState());

  static PostsCubit get(context) => BlocProvider.of(context);
  final ImagePicker postImagePicker = ImagePicker();
  File? postImagePath;

  void getPostImage() {
    postImagePicker.pickImage(source: ImageSource.gallery).then((value) {
      postImagePath = Io.File(value!.path);
      emit(GotPostImagePathSuccessState());
    });
  }

  void uploadPostImage({required String text, required UserModel currentUser}) {
    emit(UploadPostImageLoadingState());
    FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImagePath!.path).pathSegments.last}')
        .putFile(postImagePath!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createNewPost(
            text: text, postImage: value.toString(), currentUser: currentUser);
      }).catchError((error) {});
    }).catchError((error) {});
  }

  PostModel? postModel;

  void createNewPost(
      {required String text, String? postImage, required UserModel currentUser}) {
    emit(CreateNewPostLoadingState());

    postModel = PostModel(
        text: text,
        postImage: postImage ?? "",
        name: currentUser.name!,
        uId: loggedUserID,
        profilePhoto: currentUser.profilePhoto!,
        coverPhoto: currentUser.coverPhoto!,
        education: currentUser.education!,
        residence: currentUser.residence!,
        dateTime: DateFormat('yyyy-MM-dd – h:mm a')
            .format(DateTime.now())
            .toString());
    FirebaseFirestore.instance
        .collection('posts')
        // to add random ID for Each Post
        .add(postModel!.toMap())
        .then((value) {
      // gotAllPosts = false;
      emit(CreateNewPostSuccessState());
    }).catchError((error) {
      emit(CreateNewPostErrorState());
    });
  }

  List<PostModel> allPosts = [];
  bool gotAllPosts = false;
  List<String> postsId = [];
  List<int> likes = [];
  List<CommentModel> comments = [];

  Future<void> getAllPosts() async {
    emit(GetAllPostsLoadingState());
    allPosts.clear();
    postsId.clear();
    likes.clear();
    userLikedBefore = false;
    FirebaseFirestore.instance
        .collection('posts')
        .orderBy("dateTime", descending: true)
        .get()
        .then((value) {
      for (var element in value.docs) {
        allPosts.add(
          PostModel(
              text: element['text'],
              name: element['name'],
              uId: element['uId'],
              postImage: element['postImage'],
              profilePhoto: element['profilePhoto'],
              coverPhoto: element['coverPhoto'],
              education: element['education'],
              residence: element['residence'],
              dateTime: element['dateTime']),
        );
        postsId.add(element.id);
        getLikes(element: element);
      }

      getMyPosts();
    }).then((value) {
      gotAllPosts = true;
      emit(GetAllPostsSuccessState());
    }).catchError((error) {
      emit(GetAllPostsErrorState());
    });
  }

  List<PostModel> myPosts = [];
  bool gotMyPosts = false;

  Future<void> getMyPosts() async {
    emit(GetMyPostsLoadingState());
    myPosts.clear();
    FirebaseFirestore.instance
        .collection('posts')
        .orderBy("dateTime", descending: true)
        .get()
        .then((value) {
      for (var element in value.docs) {
        if (element['uId'] == loggedUserID) {
          myPosts.add(PostModel(
              text: element['text'],
              name: element['name'],
              uId: element['uId'],
              postImage: element['postImage'],
              profilePhoto: element['profilePhoto'],
              coverPhoto: element['coverPhoto'],
              education: element['education'],
              residence: element['residence'],
              dateTime: element['dateTime']));
        }
      }
      gotMyPosts = true;
      emit(GetMyPostsSuccessState());
    }).catchError((error) {
      emit(GetMyPostsErrorState());
    });
  }

  void removePost({required String postId, required int postIndex}) {
    emit(RemovePostLoadingState());
    print(postId);
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .delete()
        .then((value) {
      allPosts.removeAt(postIndex);
      myPosts.removeAt(postIndex);
      emit(RemovePostSuccessState());
    }).catchError((error) {
      emit(RemovePostErrorState());
    });
  }

  // void updatePosts()
  // {
  //   FirebaseFirestore.instance.collection('posts').snapshots().listen((querySnapshot)
  //   {
  //     for (var element in querySnapshot.docChanges) {
  //       print(element.doc);
  //     }
  //   });
  // }

  void updatePostsData({required UserCubit userCubit}) {
    emit(UpdatePostsDataLoadingState());
    FirebaseFirestore.instance.collection('posts').get().then((value) {
      for (var element in value.docs) {
        if (element['uId'] == loggedUserID) {
          FirebaseFirestore.instance
              .collection('posts')
              .doc(element.id)
              .update({
                'name': userCubit.userLogged!.name,
                'profilePhoto': userCubit.profileImageUrl == ""
                    ? userCubit.userLogged!.profilePhoto
                    : userCubit.profileImageUrl,
              })
              .then((value) {})
              .catchError((error) {});

          // update users data who liked post
          FirebaseFirestore.instance
              .collection('posts')
              .doc(element.id)
              .collection('likes')
              .doc(loggedUserID)
              .update({
                'name': userCubit.userLogged!.name,
                'profilePhoto': userCubit.profileImageUrl == ""
                    ? userCubit.userLogged!.profilePhoto
                    : userCubit.profileImageUrl,
              })
              .then((value) {})
              .catchError((error) {});

          // update users data who commented on post
          FirebaseFirestore.instance
              .collection('posts')
              .doc(element.id)
              .collection('comments')
              .get()
              .then((value) {
            for (var element in value.docs) {
              if (element['uId'] == loggedUserID) {
                element.reference.update({
                  'name': userCubit.userLogged!.name,
                  'profilePhoto': userCubit.profileImageUrl == ""
                      ? userCubit.userLogged!.profilePhoto
                      : userCubit.profileImageUrl,
                });
              }
            }
          }).catchError((error) {});
        }
      }
      getAllPosts();
      emit(UpdatePostsDataSuccessState());
    }).catchError((error) {
      emit(UpdatePostsDataErrorState());
    });
  }

  void removePostImage() {
    postImagePath = null;
    emit(RemovePostImageSuccessState());
  }

  bool userLikedBefore = false;
  UserModel? userLikedPost;

  void likePost(
      {required String postId, required int index, UserModel? currentUser}) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .get()
        .then((value) {
      for (var i = 0; i < value.size; i++) {
        if (value.docs[i].id.contains(loggedUserID)) {
          FirebaseFirestore.instance
              .collection('posts')
              .doc(postId)
              .collection('likes')
              .doc(loggedUserID)
              .delete()
              .then((value) {
            decrementLikes(index: index);
          });
          userLikedBefore = true;
        }
      }
    }).then((value) {
      if (!userLikedBefore) {
        userLikedPost = UserModel(
          name: currentUser!.name,
          email: currentUser.email,
          phone: currentUser.phone,
          uId: currentUser.uId,
          profilePhoto: currentUser.profilePhoto,
          coverPhoto: currentUser.coverPhoto,
          education: currentUser.education,
          residence: currentUser.residence,
        );
        FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .collection('likes')
            .doc(loggedUserID)
            .set(userLikedPost!.toMap())
            .then((value) {
          incrementLikes(index: index);
        });
      }
    });
    emit(LikePostSuccessState());
  }

  void incrementLikes({required int index}) {
    likes[index]++;
    emit(UpdateLikePostsSuccessState());
  }

  void decrementLikes({required int index}) async {
    if (likes[index] > 0) {
      likes[index]--;
    }
    userLikedBefore = false;
    emit(UpdateLikePostsSuccessState());
  }

  void getLikes({required QueryDocumentSnapshot element}) {
    // to get all posts' likes
    element.reference.collection('likes').get().then((value) {
      likes.add(value.docs.length);
      emit(GetPostsLikesSuccessState());
    });
  }

  List<UserModel> usersLiked = [];

  void getLikedUsers({required String postId, context, index}) {
    usersLiked.clear();
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .get()
        .then((value) {
      for (var element in value.docs) {
        usersLiked.add(UserModel(
            name: element.data()['name'],
            email: element.data()['email'],
            phone: element.data()['phone'],
            uId: element.data()['uId'],
            profilePhoto: element.data()['profilePhoto'],
            coverPhoto: element.data()['coverPhoto'],
            education: element.data()['education'],
            residence: element.data()['residence']));
      }
    }).then((value) {
      navigateToWithAnimation(
          context: context,
          nextScreen: CommentsScreen(
            postId: postId,
            postIndex: index,
          ),
          durationInMilliSecs: 300,
          pageTransitionType: PageTransitionType.rightToLeft);
    });
  }

  List<PostModel> otherUsersPosts = [];

  void getOtherUsersPosts({required String uId}) {
    otherUsersPosts.clear();
    emit(GetOthersProfileLoadingState());
    FirebaseFirestore.instance.collection('posts').get().then((value) {
      for (var element in value.docs) {
        if (element['uId'] == uId) {
          otherUsersPosts.add(PostModel(
              text: element['text'],
              name: element['name'],
              uId: element['uId'],
              postImage: element['postImage'],
              profilePhoto: element['profilePhoto'],
              coverPhoto: element['coverPhoto'],
              education: element['education'],
              residence: element['residence'],
              dateTime: element['dateTime']));
        }
      }
      emit(GetOthersProfileSuccessState());
    });
  }

  CommentModel? commentModel;

  void addNewComment(
      {required String postId,
      required String commentText,
      required UserCubit userCubit}) {
    emit(AddNewCommentLoadingState());
    commentModel = CommentModel(
        profilePhoto: userCubit.userLogged!.profilePhoto!,
        name: userCubit.userLogged!.name!,
        commentText: commentText,
        education: userCubit.userLogged!.education!,
        coverPhoto: userCubit.userLogged!.coverPhoto!,
        residence: userCubit.userLogged!.residence!,
        uId: loggedUserID);
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .add(commentModel!.toMap())
        .then((value) {
      comments.add(commentModel!);
      emit(AddNewCommentSuccessState());
    }).catchError((error) {
      emit(AddNewCommentErrorState());
    });
  }

  // void getComments({required QueryDocumentSnapshot element}) {
  //   // to get all posts' comments
  //   element.reference.collection('comments').get().then((value) {
  //     for (var element in value.docs) {
  //       comments.add(CommentModel(
  //           profilePhoto: element.data()['profilePhoto'],
  //           name: element.data()['name'],
  //           uId: element.data()['uId'],
  //           commentText: element.data()['comment']));
  //       print(element.id);
  //     }
  //     emit(GotCommentsSuccessState());
  //   });
  // }

  void getComments({required String postId}) {
    comments.clear();
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .get()
        .then((value) {
      value.reference.collection('comments').get().then((value) {
        for (var element in value.docs) {
          comments.add(CommentModel(
              profilePhoto: element['profilePhoto'],
              name: element['name'],
              uId: element['uId'],
              education: element['education'],
              coverPhoto: element['coverPhoto'],
              residence: element['residence'],
              commentText: element['comment']));
        }
        emit(GotCommentsSuccessState());
      });
    });
  }
  PostModel? sharePostModel;
  void sharePost({required PostModel post,required UserModel currentUser})
  {
    emit(SharePostLoadingState());
    sharePostModel = PostModel(
        text: post.text,
        postImage: post.postImage ?? "",
        name: currentUser.name!,
        uId: loggedUserID,
        profilePhoto: currentUser.profilePhoto!,
        coverPhoto: currentUser.coverPhoto!,
        education: currentUser.education!,
        residence: currentUser.residence!,
        dateTime: DateFormat('yyyy-MM-dd – h:mm a')
            .format(DateTime.now())
            .toString());
    FirebaseFirestore.instance
        .collection('posts')
    // to add random ID for Each Post
        .add(sharePostModel!.toMap())
        .then((value) {
      emit(SharePostSuccessState());
    }).catchError((error) {
      emit(SharePostErrorState());
    });
  }
}
