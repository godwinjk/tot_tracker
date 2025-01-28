part of 'sign_in_ui_cubit.dart';


final class SignInUiLoaded extends Equatable {
  final bool isSignIn;

  const SignInUiLoaded(this.isSignIn);

  @override
  List<Object> get props => [isSignIn];
}
