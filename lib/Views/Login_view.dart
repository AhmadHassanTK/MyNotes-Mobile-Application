import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:train/Auth/Bloc/Auth_Bloc.dart';
import 'package:train/Auth/Bloc/Bloc_Event.dart';
import 'package:train/Auth/Bloc/Bloc_State.dart';
import 'package:train/Exceptions/Auth_exceptions.dart';
import 'package:train/Dialogs/Error_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginState();
}

class LoginState extends State<LoginPage> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthLogOutState) {
          if (state.exception is InvaildEmailException ||
              state.exception is InvaildPasswordException) {
            await showErrordialog(context, 'Wrong-User');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Login Page')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            TextField(
                autofocus: true,
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                enableSuggestions: false,
                decoration:
                    const InputDecoration(hintText: '  Enter your email here')),
            TextField(
              controller: _password,
              decoration:
                  const InputDecoration(hintText: '  Enter your password here'),
              autocorrect: false,
              enableSuggestions: false,
              obscureText: true,
            ),
            TextButton(
              onPressed: () async {
                HapticFeedback.vibrate();
                final email = _email.text;
                final password = _password.text;
                context.read<AuthBloc>().add(AuthLogInEvent(email, password));
              },
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(const AuthShouldRegisterEvent());
              },
              child: const Text('Not registered?'),
            ),
            TextButton(
              onPressed: () {
                context
                    .read<AuthBloc>()
                    .add(AuthForgetPasswordEvent(fpEmail: _email.text));
              },
              child: const Text('Forget Password ?'),
            )
          ]),
        ),
      ),
    );
  }
}
