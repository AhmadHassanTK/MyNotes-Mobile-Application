import 'package:train/Auth/Auth_user.dart';

abstract class Authprovider {
  Authuser? get currentuser;

  Future<Authuser> logIn({
    required String email,
    required String password,
  });

  Future<Authuser> createuser({
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<void> sendEmailVerification();

  Future<void> initializeApp();

  Future<void> sendForgetPasswordEmail({required String fpEmail});
}
