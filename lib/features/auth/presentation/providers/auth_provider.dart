
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/domain/repositories/auth_repositorie.dart';
import 'package:teslo_shop/features/auth/infrastruction/infrastruction.dart';





final authProvider = StateNotifierProvider<AuthNotifier,AuthState>((ref) {
  final authRepositorie = AuthRepositorieImp();
  
  return AuthNotifier(authRepository: authRepositorie);
});

  class AuthNotifier extends StateNotifier<AuthState> {
    final AuthRepository authRepository;
    AuthNotifier({ required this.authRepository}): super(AuthState());

    Future <void> loginUser ( String email , String password)async{
        await Future.delayed(const Duration(milliseconds: 500));
       try {
          final user = await authRepository.login(email, password);
           _setLogUser(user);
       }on WrongCredentials {
          logout( 'Credenciales no son correctas');
       } catch (e) {
         logout( 'Error no controlado');
       }
       
    }

    void registerUser ( String email , String password)async{

    }
     void checkAuthStatus ( )async{

    }
    
    Future<void> logout([String ? errorMessages]) async{
     // TODO : limipiar o boorrar el token 
     state = state.copyWith(
        authStatus: AuthStatus.notAuthenticated,
        user: null,
        errorMessages: errorMessages
     );

    }
      void _setLogUser( User user){
        // TODO: NECESITO GUARDAR EL TOKEN EN EL DISPOSITIVO
        state = state.copyWith(
          user: user,
          authStatus: AuthStatus.authenticated,
        );
      }
    
  }

enum AuthStatus{ checking,authenticated,notAuthenticated}


class AuthState {
  final AuthStatus authStatus;
  final User? user;
  final String errorMessages;

  AuthState({
    this.authStatus = AuthStatus.checking, 
    this.user, 
    this.errorMessages = ''
    
  });

  AuthState copyWith({
    AuthStatus? authStatus,
    User? user,
    String? errorMessages}
  )=>AuthState(
       authStatus:authStatus?? this.authStatus,
       user: user ?? this.user,
       errorMessages: errorMessages ?? this.errorMessages
  );




}