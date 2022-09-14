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
import 'package:social_app/models/like_model.dart';
import 'package:social_app/models/user_data.dart';
import 'package:social_app/screens/profile_screen/my_profile_screen.dart';

import '../../components/components.dart';
import '../../components/constants.dart';
import '../../models/post_model.dart';
import '../../screens/comments_screen/comments_screen.dart';

class PostsCubit extends Cubit<PostsStates> {
  PostsCubit() : super(PostsCubitInitialState());

  static PostsCubit get(context) => BlocProvider.of(context);
  final ImagePicker postImagePicker = ImagePicker();
  File? postImagePath;

  void getPostImage() {
    emit(GotPostImagePathLoadingState());

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
      {required String text,
      String? postImage,
      required UserModel currentUser}) {
    emit(CreateNewPostLoadingState());

    postModel = PostModel(
        text: text,
        postImage: postImage ?? "",
        name: currentUser.name!,
        uId: loggedUserID,
        profilePhoto: currentUser.profilePhoto!,
        dateTime: DateTime.now().toIso8601String());
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
          PostModel.fromJson(element.data()),
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

    for (var post in allPosts) {
      if (post.uId == loggedUserID) {
        myPosts.add(post);
      }
    }
    gotMyPosts = true;
    emit(GetMyPostsSuccessState());
  }

  void removePost({required String postId, required int postIndex}) {
    emit(RemovePostLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .delete()
        .then((value) {
      allPosts.removeAt(postIndex);
      myPosts.removeAt(postIndex);
      searchPostsList.removeAt(postIndex);
      emit(RemovePostSuccessState());
    }).catchError((error) {
      emit(RemovePostErrorState());
    });
  }

  void updatePostsData({required UserModel currentUser}) {
    emit(UpdatePostsDataLoadingState());
    Map<String, dynamic> updateUserMap = {
      'name': currentUser.name,
      'profilePhoto': currentUser.profilePhoto,
    };
    FirebaseFirestore.instance.collection('posts').get().then((value) {
      for (var element in value.docs) {
        if (element['uId'] == loggedUserID) {
          FirebaseFirestore.instance
              .collection('posts')
              .doc(element.id)
              .update(updateUserMap);
        }

        // update users data who liked post
        element.reference
            .collection('likes')
            .doc(loggedUserID)
            .update(updateUserMap);

        // update users data who commented on post
        element.reference.collection('comments').get().then((value) {
          for (var element in value.docs) {
            if (element['uId'] == loggedUserID) {
              element.reference.update(updateUserMap);
            }
          }
        }).catchError((error) {});
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
  LikeModel? userLikedPost;

  void likePost(
      {required String postId, required int index, UserModel? currentUser}) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .get()
        .then((value) {
      for (var i = 0; i < value.size; i++) {
        // dislike a post
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
        userLikedPost = LikeModel(
          name: currentUser!.name!,
          uId: currentUser.uId!,
          profilePhoto: currentUser.profilePhoto!,
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
    // print(element['text']);
    element.reference.collection('likes').get().then((value) {
      likes.add(value.docs.length);
      // print(value.docs.length);
      emit(GetPostsLikesSuccessState());
    });
  }

  List<LikeModel> usersLikedData = [];

  void getLikedUsers({required String postId, context, index}) {
    usersLikedData.clear();
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .get()
        .then((value) {
      for (var element in value.docs) {
        usersLikedData.add(LikeModel.fromJson(element.data()));
      }
    }).then((value) {
      emit(GetUsersPostsLikesSuccessState());
    });
  }

  // when user click on profilePhoto or name of any user
  List<PostModel> userClickedPosts = [];
  UserModel? userClickedData;

  Future<void> getUserClickedData({required String uId}) async {
    userClickedData = null;
    userClickedPosts.clear();

    emit(GetUserDataClickedLoadingState());
    // get profile data of user who has been clicked
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      userClickedData = UserModel.fromJson(value.data()!);
      emit(GetUserDataClickedSuccessState());
    });

    // get user' posts
    FirebaseFirestore.instance.collection('posts').get().then((value) {
      for (var element in value.docs) {
        if (element['uId'] == uId) {
          userClickedPosts.add(PostModel.fromJson(element.data()));
        }
      }
    }).then((value)
    {
      emit(GetUserPostsClickedSuccessState());
    });

  }

  CommentModel? commentModel;

  void addNewComment(
      {required String postId,
      required String commentText,
      required UserModel currentUser}) {
    emit(AddNewCommentLoadingState());
    commentModel = CommentModel(
        profilePhoto: currentUser.profilePhoto!,
        name: currentUser.name!,
        commentText: commentText,
        uId: loggedUserID,
        dateTime: DateTime.now().toIso8601String());
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
          comments.add(CommentModel.fromJson(element.data()));
        }
        emit(GotCommentsSuccessState());
      });
    });
  }

  PostModel? sharePostModel;

  void sharePost({required PostModel post, required UserModel currentUser}) {
    emit(SharePostLoadingState());
    sharePostModel = PostModel(
        text: post.text,
        postImage: post.postImage ?? "",
        name: currentUser.name!,
        uId: loggedUserID,
        profilePhoto: currentUser.profilePhoto!,
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

  List<PostModel> searchPostsList = [];

  void searchPosts({required String searchQuery}) {
    emit(SearchPostsLoadingState());
    searchPostsList.clear();

    for (var i = 0; i < allPosts.length; i++) {
      if (allPosts[i].text.toLowerCase().contains(searchQuery.toLowerCase())) {
        searchPostsList.add(allPosts[i]);
      }
    }
    if (searchQuery == "") {
      searchPostsList.clear();
    }
    emit(SearchPostsSuccessState());
  }
}
