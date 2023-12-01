import 'package:bloc/bloc.dart';
import 'package:train/Auth/Auth_provider.dart';
import 'package:train/Auth/Bloc/Bloc_Event.dart';
import 'package:train/Auth/Bloc/Bloc_State.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(Authprovider provider)
      : super(const AuthUninitState(isLoading: true)) {
    on<AuthInitEvent>((event, emit) async {
      await provider.initializeApp();
      final user = provider.currentuser;
      if (user == null) {
        emit(const AuthLogOutState(
          exception: null,
          isLoading: false,
        ));
      } else if (!user.isEmailverified) {
        emit(const AuthNeedEmailVerificationState(isLoading: false));
      } else {
        emit(AuthLogInState(user: user, isLoading: false));
      }
    });

    on<AuthShouldRegisterEvent>((event, emit) {
      emit(const AuthRegisterState(exception: null, isLoading: false));
    });

    on<AuthForgetPasswordEvent>(
      (event, emit) async {
        emit(AuthForgetPasswordState(
          exception: null,
          isSent: false,
          isLoading: false,
        ));

        if (event.fpEmail == null) {
          return;
        }

        emit(AuthForgetPasswordState(
          exception: null,
          isSent: false,
          isLoading: true,
        ));

        try {
          await provider.sendForgetPasswordEmail(fpEmail: event.fpEmail!);
          emit(AuthForgetPasswordState(
            exception: null,
            isSent: true,
            isLoading: false,
          ));
        } on Exception catch (e) {
          emit(AuthForgetPasswordState(
            exception: e,
            isSent: false,
            isLoading: false,
          ));
        }
      },
    );

    on<AuthSendEmailVerificationEvent>((event, emit) async {
      try {
        await provider.sendEmailVerification();
        emit(state);
      } on Exception catch (e) {
        emit(AuthLogOutState(
          exception: e,
          isLoading: false,
        ));
      }
    });

    on<AuthRegisterEvent>((event, emit) async {
      try {
        await provider.createuser(
          email: event.email,
          password: event.password,
        );
        await provider.sendEmailVerification();
        emit(const AuthNeedEmailVerificationState(isLoading: false));
      } on Exception catch (e) {
        emit(AuthRegisterState(
          exception: e,
          isLoading: false,
        ));
      }
    });

    on<AuthLogInEvent>((event, emit) async {
      try {
        emit(const AuthLogOutState(
            exception: null,
            isLoading: true,
            loadingtext: 'Please Wait while I log you in'));
        final user = await provider.logIn(
          email: event.email,
          password: event.password,
        );

        if (!user.isEmailverified) {
          emit(const AuthLogOutState(
            exception: null,
            isLoading: false,
          ));
          emit(const AuthNeedEmailVerificationState(isLoading: false));
        } else {
          emit(const AuthLogOutState(
            exception: null,
            isLoading: false,
          ));
        }
        emit(AuthLogInState(
          user: user,
          isLoading: false,
        ));
      } on Exception catch (e) {
        emit(AuthLogOutState(
          exception: e,
          isLoading: false,
        ));
      }
    });

    on<AuthLogOutEvent>((event, emit) async {
      try {
        await provider.logout();
        emit(const AuthLogOutState(
          exception: null,
          isLoading: false,
        ));
      } on Exception catch (e) {
        emit(AuthLogOutState(
          exception: e,
          isLoading: false,
        ));
      }
    });
  }
}
