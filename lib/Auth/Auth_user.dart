import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';

@immutable
class Authuser {
  final String id;
  final String email;
  final bool isEmailverified;

  const Authuser({
    required this.id,
    required this.isEmailverified,
    required this.email,
  });

  factory Authuser.fromFirebase(User user) => Authuser(
        id: user.uid,
        isEmailverified: user.emailVerified,
        email: user.email!,
      );
}
