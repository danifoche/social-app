import 'dart:convert';

import 'package:social_app_bloc/data/models/user.dart';
import 'package:social_app_bloc/settings/make_api_call.dart';

class UserApi {
  final MakeApiCall _makeApiCall = MakeApiCall();

  //? Cerca tutti gli utenti con una pattern specifica
  Future<List<User>?> searchUser(String token, String pattern) async {
    //? Endpoint dell'api
    String endpoint = "/user/search";

    //? Dati che servono alla request
    Map<String, dynamic> requestData = {"username": pattern};

    Map<String, dynamic>? response = await _makeApiCall.makePostRequest(
        jsonEncode(requestData), endpoint, token);

    //? Se la risposta non e andata a buon fine allora ritorno null
    if (response == null || response["success"] == false) {
      return null;
    }

    //? Ciclo per ogni utente e lo trasformo in un model e ritorno una lista di tutti
    return (response["data"] as List<dynamic>)
        .map((user) => User.fromJson(user))
        .toList();
  }

  //? Crea una nuova conversazione con l'utente appena creato
  Future<Map<String, dynamic>?> createChatWithUser(String token, String username) async {
    
    //? Endpoint della chiamata api 
    String endpoint = "/group";

    Map<String, dynamic> requestData = {
      "username": username
    };

    Map<String, dynamic>? response = await _makeApiCall.makePostRequest(jsonEncode(requestData), endpoint, token);

    //? Controllo se la risposta é andata a buon fine
    if(response == null || response["success"] == false) {
      return {
        "message": response?["message"] ?? "An error has occoured!"
      };
    }

    return null;
  }
}
