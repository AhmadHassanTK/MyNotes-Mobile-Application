import 'package:train/Auth/Auth_provider.dart';
import 'package:train/Auth/Auth_user.dart';
import 'package:train/Auth/firebase_auth_provider.dart';

class Authservices implements Authprovider {
  Authprovider provider;
  Authservices(this.provider);

  factory Authservices.firebase() => Authservices(FirebaseAuthprovider());

  @override
  Future<void> logout() => provider.logout();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<Authuser> createuser(
          {required String email, required String password}) =>
      provider.createuser(email: email, password: password);

  @override
  Authuser? get currentuser => provider.currentuser;

  @override
  Future<Authuser> logIn({required String email, required String password}) =>
      provider.logIn(email: email, password: password);

  @override
  Future<void> initializeApp() => provider.initializeApp();

  @override
  Future<void> sendForgetPasswordEmail({required String fpEmail}) =>
      provider.sendForgetPasswordEmail(fpEmail: fpEmail);
}
