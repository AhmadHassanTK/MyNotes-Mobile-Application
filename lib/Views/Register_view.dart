import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:train/Auth/Bloc/Auth_Bloc.dart';
import 'package:train/Auth/Bloc/Bloc_Event.dart';
import 'package:train/Auth/Bloc/Bloc_State.dart';
import 'package:train/Dialogs/Error_dialog.dart';
import 'package:train/Exceptions/Auth_exceptions.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => RegisterViewState();
}

class RegisterViewState extends State<RegisterView> {
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
        if (state is AuthRegisterState) {
          if (state.exception is WeakPasswordException) {
            await showErrordialog(context, 'Weak-Password');
          } else if (state.exception is EmailAlreadyInUseException) {
            await showErrordialog(context, 'Email-Already-In-Use');
          } else if (state.exception is GenericAuthException) {
            await showErrordialog(context, 'Falied to register');
          } else if (state.exception is InvaildEmailException) {
            await showErrordialog(context, 'Invalid Email');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Register')),
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
                context
                    .read<AuthBloc>()
                    .add(AuthRegisterEvent(email, password));
              },
              child: const Text('Register'),
            ),
            TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthLogOutEvent());
                },
                child: const Text('Already registerd? Login!'))
          ]),
        ),
      ),
    );
  }
}
