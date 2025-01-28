part of 'auth_cubit.dart';

sealed class AuthState extends Equatable {
  const AuthState();
}

final class AuthInitial extends AuthState {
  @override
  List<Object> get props => [];
}

final class AuthLoading extends AuthState {
  const AuthLoading();

  @override
  List<Object> get props => [];
}

final class AuthAuthenticated extends AuthState {
  final User? user;

  const AuthAuthenticated(this.user);

  @override
  List<Object> get props => [user!];
}

final class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}

final class AuthSignOut extends AuthState {
  const AuthSignOut();

  @override
  List<Object> get props => [];
}
