import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:social_app_bloc/data/models/chatlist.dart';
import 'package:social_app_bloc/settings/app_settings.dart';
import 'package:social_app_bloc/settings/make_api_call.dart';

class ChatListViewApi {
  final MakeApiCall _makeApiCall = MakeApiCall();
  final storage = const FlutterSecureStorage();

  //? Funzione che fa chiamata api per ottenere la lista delle chat
  Future<List<ChatList>?> loadList(String token) async {
    //? Endpoint per ottenere la lista di chat
    String endpoint = "/group";

    Map<String, dynamic>? response =
        await _makeApiCall.makeGetRequest(endpoint, token);

    //? Se la chiamata è andata a buon fine allora resituisco la lista di chat
    if (response != null && response["success"] == true) {
      //? Salvo il risultato nella storage
      storage.write(
          key: chatListStorageKey, value: jsonEncode(response["data"]));

      return (response["data"] as List<dynamic>)
          .map((chat) => ChatList.fromJson(chat))
          .toList();
    }

    //? Ritorno null nel caso ci fossero errori
    return null;
  }

  //? Cancella una chat dall'id
  Future<Map<String, dynamic>?> deleteChat(String token, int id) async {
    //? Endpoint per ottenere la lista di chat
    String endpoint = "/group";

    //? Dati che servono alla request
    Map<String, dynamic> requestData = {"id": id};

    Map<String, dynamic>? response = await _makeApiCall.makeDeleteRequest(
        jsonEncode(requestData), endpoint, token);

    //? Controllo se la risposta è andata a buon fine
    if (response == null || response["success"] == false) {
      return {"message": response?["message"] ?? "An error occoured!"};
    }

    return null;
  }

  //? Filtro la lista di chat in base ad una stringa specifica
  Future<List<ChatList>?> filterList(String chatName) async {
    //? Ottengo la lista memorizzata nella storage
    String? list = await storage.read(key: chatListStorageKey);

    if (list == null) {
      return null;
    }

    return (jsonDecode(list) as List<dynamic>)
        .where((chat) => chat["name"]
            .toString()
            .toLowerCase()
            .contains(chatName.toLowerCase()))
        .map((chat) => ChatList.fromJson(chat))
        .toList();
  }
}
