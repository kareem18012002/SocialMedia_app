abstract class RegisterStates {}

class SocialRegisterInitialState extends RegisterStates {}

class SocialRegisterLoadingState extends RegisterStates {}

class SocialRegisterSuccessState extends RegisterStates {
  final String uId;

  SocialRegisterSuccessState(this.uId);
}

class SocialRegisterErrorState extends RegisterStates
{
  final String error;

  SocialRegisterErrorState(this.error);
}

class SocialCreateUserSuccessState extends RegisterStates {


}

class SocialCreateUserErrorState extends RegisterStates
{
  final String error;

  SocialCreateUserErrorState(this.error);
}

class SocialRegisterChangePasswordVisibilityState extends RegisterStates {}