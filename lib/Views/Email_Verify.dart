import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:train/Auth/Bloc/Auth_Bloc.dart';
import 'package:train/Auth/Bloc/Bloc_Event.dart';

class EmailV extends StatefulWidget {
  const EmailV({super.key});

  @override
  State<EmailV> createState() => EmailVState();
}

class EmailVState extends State<EmailV> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Email Verification page')),
        body: Column(
          children: [
            const Center(child: Text('Verify your Email')),
            const Text('Open your email to verify your account'),
            const Text('Press the button to resend the verification email'),
            TextButton(
                onPressed: () async {
                  context
                      .read<AuthBloc>()
                      .add(AuthSendEmailVerificationEvent());
                },
                child: const Text('Verify your email')),
            TextButton(
              onPressed: () async {
                context.read<AuthBloc>().add(const AuthLogOutEvent());
              },
              child: const Text('Restart'),
            ),
          ],
        ));
  }
}
