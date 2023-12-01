import 'package:flutter/material.dart';

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class AuthInitEvent implements AuthEvent {
  const AuthInitEvent();
}

class AuthForgetPasswordEvent implements AuthEvent {
  final String? fpEmail;
  const AuthForgetPasswordEvent({required this.fpEmail});
}

class AuthLogInEvent implements AuthEvent {
  final String email;
  final String password;
  const AuthLogInEvent(this.email, this.password);
}

class AuthLogOutEvent implements AuthEvent {
  const AuthLogOutEvent();
}

class AuthSendEmailVerificationEvent implements AuthEvent {
  AuthSendEmailVerificationEvent();
}

class AuthRegisterEvent implements AuthEvent {
  final String email;
  final String password;

  AuthRegisterEvent(this.email, this.password);
}

class AuthShouldRegisterEvent implements AuthEvent {
  const AuthShouldRegisterEvent();
}
