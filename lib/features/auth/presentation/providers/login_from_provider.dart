import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/auth/presentation/providers/providers.dart';
import 'package:teslo_shop/features/shared/infrastructions/inputs/inputs.dart';

//! 3- Como se va a consumir el provider  - consume afuera
final loginFormProvider =
    StateNotifierProvider.autoDispose<LoginFromNotifier, LoginFromState>((ref) {
  final loginUserCallback = ref.watch(authProvider.notifier).loginUser;

  return LoginFromNotifier(loginUserCallback: loginUserCallback);
});

//! 1- Crear el sate del provider
class LoginFromState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Email email;
  final Password password;
  //Constructor
  LoginFromState(
      {this.isPosting = false,
      this.isFormPosted = false,
      this.isValid = false,
      this.email = const Email.pure(),
      this.password = const Password.pure()});
  //Methodo copyWith
  LoginFromState copyWith(
          {bool? isPosting,
          bool? isFormPosted,
          bool? isValid,
          Email? email,
          Password? password}) =>
      LoginFromState(
        isPosting: isPosting ?? this.isPosting,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isValid: isValid ?? this.isValid,
        email: email ?? this.email,
        password: password ?? this.password,
      );

  @override
  String toString() {
    return '''
  LoginFormProvider: 

        isPosting: $isPosting
        isFormPosted: $isFormPosted
        isValid: $isValid
        email: $email
        password: $password
''';
  }
}

//! 2. Como implementar el notifier
class LoginFromNotifier extends StateNotifier<LoginFromState> {
  final Function(String, String) loginUserCallback;

  LoginFromNotifier({required this.loginUserCallback})
      : super(LoginFromState());

  onEmailChanges(String value) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
        email: newEmail, isValid: Formz.validate([newEmail, state.password]));
  }

  onPasswordChanges(String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
        password: newPassword,
        isValid: Formz.validate([newPassword, state.email]));
  }

  onFormSumit() async {
    _touchEveryField();
    if (!state.isValid) return;
    await loginUserCallback(state.email.value, state.password.value);
    print(state);
  }

  _touchEveryField() {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);

    state = state.copyWith(
        isFormPosted: true,
        email: email,
        password: password,
        isValid: Formz.validate([email, password]));
  }
}
