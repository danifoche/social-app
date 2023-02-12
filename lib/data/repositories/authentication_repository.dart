import 'package:social_app_bloc/data/models/user.dart';
import 'package:social_app_bloc/data/providers/authentication_api.dart';

class AuthenticationRepository {

  //? Ottengo l'istanza dell'api per il login
  final AuthenticationApi _authenticationApi = AuthenticationApi();

  //? Logga l'utente
  Future<Map<String, dynamic>?> logIn(Map<String, dynamic> userCredentials) async => await _authenticationApi.logIn(userCredentials);

  //? Registra l'utente
  Future<Map<String, dynamic>?> register(Map<String, dynamic> userCredentials) async => await _authenticationApi.register(userCredentials);

  //? Controlla il token dell'utente corrente
  Future<Map<String, dynamic>?> checkUserToken() async => await _authenticationApi.checkUserToken();

  //? Ottengo il token dell'utente
  Future<Map<String, dynamic>?> getUserToken() async => await _authenticationApi.getUserToken();

  //? Ottengo l'id dell'utente loggato
  Future<Map<String, dynamic>?> getUserId() async => await _authenticationApi.getUserId();

  //? Scollega l'utente corrente
  Future<void> logout() async => await _authenticationApi.logout();

}