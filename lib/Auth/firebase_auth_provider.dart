import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:train/Auth/Auth_provider.dart';
import 'package:train/Auth/Auth_user.dart';
import 'package:train/Exceptions/Auth_exceptions.dart';
import 'package:train/firebase_options.dart';

class FirebaseAuthprovider implements Authprovider {
  @override
  Future<Authuser> logIn({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = currentuser;

      if (user != null) {
        return user;
      } else {
        throw UserNotLogedException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        throw InvaildPasswordException();
      } else if (e.code == 'invalid-email') {
        throw InvaildEmailException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> logout() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLogedException();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw UserNotLogedException();
    }
  }

  @override
  Future<Authuser> createuser(
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final user = currentuser;

      if (user != null) {
        return user;
      } else {
        throw FirebaseAuthException;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw WeakPasswordException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  Authuser? get currentuser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return Authuser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<void> initializeApp() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Future<void> sendForgetPasswordEmail({required String fpEmail}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: fpEmail);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        throw InvaildEmailException();
      } else if (e.code == 'user-not-found') {
        throw UserNotFoundException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }
}
