import 'package:equatable/equatable.dart';
import 'package:train/Auth/Auth_user.dart';

abstract class AuthState {
  final bool isLoading;
  final String? loadingtext;
  const AuthState({
    required this.isLoading,
    this.loadingtext = 'wait a moment',
  });
}

class AuthUninitState extends AuthState {
  const AuthUninitState({required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthLogInState extends AuthState {
  final Authuser user;
  const AuthLogInState({required this.user, required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthNeedEmailVerificationState extends AuthState {
  const AuthNeedEmailVerificationState({required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthLogOutState extends AuthState with EquatableMixin {
  final Exception? exception;
  const AuthLogOutState(
      {required this.exception, required bool isLoading, String? loadingtext})
      : super(isLoading: isLoading, loadingtext: loadingtext);

  @override
  List<Object?> get props => [exception, isLoading];
}

class AuthRegisterState extends AuthState {
  final Exception? exception;
  const AuthRegisterState({required this.exception, required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthForgetPasswordState extends AuthState {
  final Exception? exception;
  final bool isSent;
  AuthForgetPasswordState(
      {required this.exception, required this.isSent, required bool isLoading})
      : super(isLoading: isLoading);
}
