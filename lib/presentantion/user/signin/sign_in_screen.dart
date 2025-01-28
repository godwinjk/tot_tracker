import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tot_tracker/di/injection_base.dart';
import 'package:tot_tracker/presentantion/user/password_widget.dart';
import 'package:tot_tracker/presentantion/user/signin/bloc/auth_cubit.dart';
import 'package:tot_tracker/presentantion/user/signin/bloc/sign_in_ui_cubit.dart';
import 'package:tot_tracker/res/asset_const.dart';
import 'package:tot_tracker/router/route_path.dart';

import '../../../persistence/shared_pref_const.dart';
import '../../../util/setup_steps.dart'; // Add google_sign_in package for Google sign-in functionality

class SignInPage extends StatelessWidget {
  SignInPage({super.key});

  final _formKey = GlobalKey<FormState>(); // Form key to validate the form

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Regex for validating email
  final String emailPattern =
      r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is AuthAuthenticated) {
            SharedPreferences.getInstance().then((pref) {
              pref.setInt(
                  SharedPrefConstants.settingsCompleted, SetupSteps.home);
              GetIt.instance<GoRouter>().replace(RoutePath.home);
            });
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Title
                      Text(
                        'Welcome',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      BlocBuilder<SignInUiCubit, SignInUiLoaded>(
                        builder: (context, state) {
                          String text = state.isSignIn ? 'Login' : 'Signup';
                          return Text(
                            text,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          );
                        },
                      ),
                      SizedBox(height: 40),
                      // Email Input
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          } else if (!RegExp(emailPattern).hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      PasswordTextField(
                        controller: _passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          } else if (value.length < 6) {
                            return 'Password must be at least 6 characters long';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                          onPressed: state is AuthInitial || state is AuthError
                              ? () {
                                  if (!_formKey.currentState!.validate()) {
                                    // If form is valid, print the entered values
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text(
                                          'Please check the errors and click continue'),
                                    ));
                                  } else {
                                    bool isSignIn = context
                                        .read<SignInUiCubit>()
                                        .state
                                        .isSignIn;
                                    if (isSignIn) {
                                      context
                                          .read<AuthCubit>()
                                          .signInWithEmailAndPassword(
                                              _emailController.text,
                                              _passwordController.text);
                                    } else {
                                      context
                                          .read<AuthCubit>()
                                          .signUpWithEmailAndPassword(
                                              _emailController.text,
                                              _passwordController.text);
                                    }
                                  }
                                }
                              : null,
                          child: Text(
                            'Continue',
                          )),
                      // Email/Password Sign In Button
                      // Google Sign In Button
                      SizedBox(height: 10),
                      BlocBuilder<SignInUiCubit, SignInUiLoaded>(
                        builder: (context, state) {
                          String firstText = 'Not a user? ';
                          String loginText = 'Signup';
                          if (!state.isSignIn) {
                            firstText = 'Already a user? ';
                            loginText = 'Login';
                          }
                          return RichText(
                            textAlign: TextAlign.right,
                            text: TextSpan(
                              text: firstText,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                              children: [
                                TextSpan(
                                  text: loginText,
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      context.read<SignInUiCubit>().toggle();
                                    },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 20),
                      Text(
                        'OR',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          OutlinedButton(
                            onPressed:
                                state is AuthInitial || state is AuthError
                                    ? () {
                                        context
                                            .read<AuthCubit>()
                                            .signInWithGoogle();
                                      }
                                    : null,
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width: 20),
                                Image.asset(
                                  AssetConstant.google,
                                  width: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Sign in with Google',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(width: 20),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
