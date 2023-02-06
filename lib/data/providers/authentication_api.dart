import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:social_app_bloc/data/models/user.dart';
import 'package:social_app_bloc/settings/app_settings.dart';
import 'package:social_app_bloc/settings/make_api_call.dart';

class AuthenticationApi {

  final MakeApiCall _makeApiCall = MakeApiCall();
  final storage = const FlutterSecureStorage();

  //? Funzione che fa chiamata api a backend per loggare l'utente
  Future<Map<String, dynamic>?> logIn(Map<String, dynamic> user) async {

    //? Endpoint api per il login
    String endpoint = "/auth/login";

    //? Faccio la chiamata api
    Map<String, dynamic>? response = await _makeApiCall.makePostRequest(jsonEncode(user), endpoint, null);

    //? Se la chiamata non è andata a buon fine allora mando messaggio di errore
    if(response?["success"] == false && response?["message"].isNotEmpty) {
      return {
        "message": response?["message"]
      };
    }

    //? Salvo l'utente nella storage
    await storage.write(key: userStorageKey, value: jsonEncode(response?["data"]));

    //? Se la chiamata è andata a buon fine ritorno nullo
    return null;

  }

  //? Funzione che fa chiamata api a backend per registrare l'utente
  Future<Map<String, dynamic>?> register(Map<String, dynamic> user) async {

    //? Endpoint api per la registrazione
    String endpoint = "/auth/register";

    //? Faccio la chiamata api
    Map<String, dynamic>? response = await _makeApiCall.makePostRequest(jsonEncode(user), endpoint, null);

    //? Se la chiamata non è andata a buon fine allora mando messaggio di errore
    if(response?["success"] == false) {

      if(response?["message"].isNotEmpty) {
        return {
          "message": response?["message"]
        };
      } else if(response?["errors"].isNotEmpty) {
        return {
          "message": response?["errors"]
        };
      } else {
        return {
          "message": "An error has occoured!"
        };
      }
    }

    //? Salvo l'utente nella storage
    await storage.write(key: userStorageKey, value: jsonEncode(response?["data"]));

    //? Se la chiamata è andata a buon fine ritorno nullo
    return null;

  }

  //? Controllo se il token della storage è valido
  Future<Map<String, dynamic>?> checkUserToken() async {

    //? Ottengo l'utente loggato dalla storage
    String? storedUser = await storage.read(key: userStorageKey);

    //? Se non trovo niente mando errore
    if(storedUser == null) {
      return {
        "message": "An error has occoured!"
      };
    }

    //? Ottengo il model dell'utente
    User user = User.fromJson(jsonDecode(storedUser));

    //? Ottengo il token di autenticazione
    String? token = user.accessToken;

    //? Se non trovo il token mando errore
    if(token == null) {
      return {
        "message": "Authentication error, please log back in!"
      };
    }

    //? Endpoint di check token
    String endpoint = "/auth/check-token";

    //? Faccio la chiamata api
    Map<String, dynamic>? response = await _makeApiCall.makeGetRequest(endpoint, token);

    //? Se ottengo una risposta ed è true allora ritorno null altrimenti ritorno messaggio di errore
    if(response?["valid"] != null && response?["valid"] == true) {
      return null;
    }

    return {
      "message": "Session expired, please log back in!"
    };

  }

  //? Funzione che ritorna il token memorizzato nella storage
  Future<Map<String, dynamic>?> getUserToken() async {

    //? Ottengo l'utente loggato dalla storage
    String? storedUser = await storage.read(key: userStorageKey);

    if(storedUser == null) {
      return null;
    }

    //? Ottengo il model dell'utente
    User user = User.fromJson(jsonDecode(storedUser));

    //? Ottengo il token di autenticazione
    String? token = user.accessToken;

    //? Se non trovo il token mando errore
    if(token == null) {
      return null;
    }

    return {
      "token": token
    };

  }

}