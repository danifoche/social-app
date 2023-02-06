import 'package:social_app_bloc/data/models/user.dart';
import 'package:social_app_bloc/data/providers/user_api.dart';

class UserRepository {

  UserApi _userApi = UserApi();

  //? Cerco tutti gli utenti con quella pattern specifica
  Future<List<User>?> searchUser(String token, String pattern) async => await _userApi.searchUser(token, pattern);

  //? Crea una nuova conversazione con l'utente specificato
  Future<Map<String, dynamic>?> createChatWithUser(String token, String username) async => await _userApi.createChatWithUser(token, username);

}