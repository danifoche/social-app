import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:social_app_bloc/data/repositories/authentication_repository.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {

  //? Ottengo l'istanza della repository
  final AuthenticationRepository _authenticationRepository = AuthenticationRepository();

  AuthenticationCubit([AuthenticationState? state]) : super(AuthenticationInitial()) {
    if(state != null && state is CheckTokenSuccess) {
      emit(CheckTokenSuccess());
    }
  }

  //? Funzione per loggare l'utente
  void logIn(Map<String, dynamic> userCredentials) async {

    try {

      emit(AuthenticationLoading());

      Map<String, dynamic>? response = await _authenticationRepository.logIn(userCredentials);

      if(response != null && response.isNotEmpty) {
        emit(LoginError(message: response["message"]));
      } else {
        emit(LoginSuccess());
      }
    } catch (e) {
      emit(LoginError(message: e.toString()));
    }

  }

  //? Funzione per registrare l'utente
  void register(Map<String, dynamic> userCredentials) async {

    try {

      emit(AuthenticationLoading());

      Map<String, dynamic>? response = await _authenticationRepository.register(userCredentials);

      if(response != null && response.isNotEmpty) {
        emit(RegistrationError(message: response["message"]));
      } else {
        emit(RegistrationSuccess());
      }
      
    } catch (e) {
      emit(RegistrationError(message: e.toString()));
    }

  }

  void checkUserToken() async {

    try {

      emit(AuthenticationLoading());

      Map<String, dynamic>? response = await _authenticationRepository.checkUserToken();

      if(response != null && response.isNotEmpty) {
        emit(CheckTokenError(message: response["message"]));
      } else {
        emit(CheckTokenSuccess());
      }

    } catch (e) {
      emit(CheckTokenError(message: e.toString()));
    }

  }

  void logout() async {

    try {

      emit(LogoutLoading());

      await _authenticationRepository.logout();

      emit(LogoutSuccess(message: "Logged out successfully!"));

    } catch (e) {
      emit(LogoutError(message: e.toString()));
    }

  }

}
