import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:train/Auth/Bloc/Auth_Bloc.dart';
import 'package:train/Auth/Bloc/Bloc_Event.dart';
import 'package:train/Auth/Bloc/Bloc_State.dart';
import 'package:train/Dialogs/Error_dialog.dart';
import 'package:train/Dialogs/forgetpassworddialog.dart';
import 'package:train/Exceptions/Auth_exceptions.dart';

class Forgetpasswordview extends StatefulWidget {
  const Forgetpasswordview({super.key});

  @override
  State<Forgetpasswordview> createState() => ForgetpasswordviewState();
}

class ForgetpasswordviewState extends State<Forgetpasswordview> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthForgetPasswordState) {
          if (state.isSent) {
            if (_controller.text.isNotEmpty) {
              _controller.clear();
              await showPasswordForgetDialog(context);
            }
          } else if (state.exception != null) {
            if (state.exception is InvaildEmailException) {
              await showErrordialog(context, 'Invaild Email');
            } else if (state.exception is UserNotFoundException) {
              await showErrordialog(context, 'User not Found');
            } else if (state.exception is GenericAuthException) {
              await showErrordialog(context, 'Something went wrong');
            } else {
              await showErrordialog(context, 'Error');
            }
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Reset Password'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text('Reset your password from here !!'),
              TextField(
                keyboardType: TextInputType.emailAddress,
                controller: _controller,
                autofocus: true,
                autocorrect: false,
                decoration:
                    const InputDecoration(hintText: 'Write your email here !'),
              ),
              TextButton(
                onPressed: () {
                  context
                      .read<AuthBloc>()
                      .add(AuthForgetPasswordEvent(fpEmail: _controller.text));
                },
                child: const Text('Send Email'),
              ),
              TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(const AuthLogOutEvent());
                  },
                  child: const Text('Back')),
            ],
          ),
        ),
      ),
    );
  }
}
