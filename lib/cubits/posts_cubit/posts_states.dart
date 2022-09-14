abstract class PostsStates {}

class PostsCubitInitialState extends PostsStates {}
class CreateNewPostLoadingState extends PostsStates{}
class CreateNewPostSuccessState extends PostsStates{}
class CreateNewPostErrorState extends PostsStates{}
class GetAllPostsLoadingState extends PostsStates{}
class GetAllPostsSuccessState extends PostsStates{}
class GetAllPostsErrorState extends PostsStates{}

class GetMyPostsLoadingState extends PostsStates{}
class GetMyPostsSuccessState extends PostsStates{}
class GetMyPostsErrorState extends PostsStates{}



class RemovePostImageSuccessState extends PostsStates{}
class UploadPostImageLoadingState extends PostsStates{}
class GotPostImagePathLoadingState extends PostsStates{}
class GotPostImagePathSuccessState extends PostsStates{}

class RemovePostLoadingState extends PostsStates{}
class RemovePostSuccessState extends PostsStates{}
class RemovePostErrorState extends PostsStates{}

class UpdatePostsDataLoadingState extends PostsStates{}
class UpdatePostsDataSuccessState extends PostsStates{}
class UpdatePostsDataErrorState extends PostsStates{}
class LikePostSuccessState extends PostsStates{}
class LikePostErrorState extends PostsStates{}
class UpdateLikePostsLoadingState extends PostsStates{}

class UpdateLikePostsSuccessState extends PostsStates{}

class AddNewCommentLoadingState extends PostsStates{}
class AddNewCommentSuccessState extends PostsStates{}
class AddNewCommentErrorState extends PostsStates{}

class GotCommentsSuccessState extends PostsStates{}
class GetPostsLikesSuccessState extends PostsStates{}
class GetUsersPostsLikesSuccessState extends PostsStates{}
class GetUserDataClickedLoadingState extends PostsStates{}
class GetUserDataClickedSuccessState extends PostsStates{}
class GetUserPostsClickedSuccessState extends PostsStates{}


class SharePostLoadingState extends PostsStates{}
class SharePostSuccessState extends PostsStates{}
class SharePostErrorState extends PostsStates{}

class SearchPostsLoadingState extends PostsStates{}
class SearchPostsSuccessState extends PostsStates{}