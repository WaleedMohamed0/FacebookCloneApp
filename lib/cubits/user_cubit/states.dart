abstract class UserStates {}

class InitialAppState extends UserStates {}
class ChangePasswordVisibilityState extends UserStates{}

class RegisterLoadingState extends UserStates{}
class RegisterSuccessState extends UserStates{}
class RegisterErrorState extends UserStates{}
class ChangeGenderState extends UserStates{}

class CreateUserLoadingState extends UserStates{}
class CreateUserSuccessState extends UserStates{}
class CreateUserErrorState extends UserStates{}
class LoginLoadingState extends UserStates{}
class LoginSuccessState extends UserStates{}
class LoginErrorState extends UserStates{}
class GetUsersDataLoadingState extends UserStates{}
class GetUsersDataSuccessState extends UserStates{}
class GetUsersDataErrorState extends UserStates{}

class GotImagePathSuccessState extends UserStates{}

class UploadProfileImageState extends UserStates{}
class UploadCoverImageState extends UserStates{}
class UpdateUserLoadingState extends UserStates{}
class UpdateUserSuccessState extends UserStates{}
class UpdateUserErrorState extends UserStates{}


