import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  late FirebaseAuth _firebaseAuth;

  late GoogleSignIn _googleSignIn;

  void initialize() {
    _firebaseAuth = FirebaseAuth.instance;
    _googleSignIn = GoogleSignIn();
  }

  Future<User?> getCurrentUser() async {
    return _firebaseAuth.currentUser;
  }

  // Sign in with email and password
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      emit(const AuthLoading());
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError('Error during Sign-In: $e'));
    }
  }

  // Sign up with email and password
  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    try {
      emit(const AuthLoading());
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError('Error during Sign-Up: $e'));
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      emit(const AuthLoading());
      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // The user canceled the sign-in
        return;
      }

      // Obtain the Google Sign-In authentication details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential using the Google token
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credentials
      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      final User? user = userCredential.user;

      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError('Error during Google Sign-In: $e'));
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    emit(const AuthSignOut());
  }
}
