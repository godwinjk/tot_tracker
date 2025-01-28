import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'sign_in_ui_state.dart';

class SignInUiCubit extends Cubit<SignInUiLoaded> {
  SignInUiCubit() : super(const SignInUiLoaded(true));

  bool isSignIn = true;

  toggle() {
    isSignIn = !isSignIn;
    emit(SignInUiLoaded(isSignIn));
  }
}
