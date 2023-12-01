import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:train/Auth/Bloc/Auth_Bloc.dart';
import 'package:train/Auth/Bloc/Bloc_Event.dart';
import 'package:train/Auth/Bloc/Bloc_State.dart';
import 'package:train/Auth/firebase_auth_provider.dart';
import 'package:train/Screens/Loading_Screen.dart';
import 'package:train/Views/Email_Verify.dart';
import 'package:train/Views/Login_view.dart';
import 'package:train/Views/Notesview.dart';
import 'package:train/Views/Register_view.dart';
import 'package:train/Views/createORupdatenote.dart';
import 'package:train/Views/forgetpasswordview.dart';
import 'package:train/routes/routes.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        // primarySwatch: Colors.blue,
      ),
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthprovider()),
        child: const HomePage(),
      ),
      routes: {
        loginroute: (context) => const LoginPage(),
        registerroute: (context) => const RegisterView(),
        notesroute: (context) => const NotesPage(),
        emailVroute: (context) => const EmailV(),
        newnoteroute: (context) => const Newnote(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthInitEvent());

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen()
              .show(context: context, text: state.loadingtext ?? 'Wait');
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthLogInState) {
          return const NotesPage();
        } else if (state is AuthNeedEmailVerificationState) {
          return const EmailV();
        } else if (state is AuthLogOutState) {
          return const LoginPage();
        } else if (state is AuthRegisterState) {
          return const RegisterView();
        } else if (state is AuthForgetPasswordState) {
          return const Forgetpasswordview();
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
