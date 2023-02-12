import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:social_app_bloc/data/models/message.dart';
import 'package:social_app_bloc/settings/app_settings.dart';
import 'package:social_app_bloc/settings/make_api_call.dart';

class ChatMessageApi {

  final MakeApiCall _makeApiCall = MakeApiCall();
  final storage = const FlutterSecureStorage();
  final _animatedListKey = GlobalKey<AnimatedListState>();

  Future<List<Message>?> getAll(String token, int chatId) async {
    //? Endpoint per ottenere la lista di chat
    String endpoint = "/group/message";

    //? Dati che servono alla request
    Map<String, dynamic> requestData = {"id": chatId};

    Map<String, dynamic>? response = await _makeApiCall.makePostRequest(
        jsonEncode(requestData), endpoint, token);

    //? Controllo se la risposta non è andata a buon fine
    if (response == null || response["success"] == false) {
      return null;
    }

    //? Salvo la response nella storage
    await storage.write(key: chatMessageStorageKey, value: jsonEncode({
      "$chatId": response["data"],
    }));

    return (response["data"] as List<dynamic>)
        .map((message) => Message.fromJson(message))
        .toList();
  }

  //? Aggiunge un nuovo messaggio alla chat
  Future<bool> addMessage(String token, int chatId, String message) async {

    //? Endpoint per ottenere la inserire un nuovo messaggio
    String endpoint = "/group/message/add";

    //? Dati che servono alla request
    Map<String, dynamic> requestData = {
      "group_id": chatId,
      "message": message
    };

    Map<String, dynamic>? response = await _makeApiCall.makePostRequest(
        jsonEncode(requestData), endpoint, token);

    //? Controllo se la risposta non è andata a buon fine
    if (response == null || response["success"] == false) {
      return false;
    }

    String? messagesListStorage = await storage.read(key: chatMessageStorageKey);

    Map<String, dynamic> messageList = {};

    //? Ottengo la lista di messaggi se presente
    if(messagesListStorage != null) {
      messageList = jsonDecode(messagesListStorage);
    }

    messageList["$chatId"].insert(0, {
      "message": message,
      "isMe": true
    });

    //? Salvo tutta la chat
    await storage.write(key: chatMessageStorageKey, value: jsonEncode(messageList));

    return true;
  }

  //? Get all messages saved on storage
  Future<List<Message>> getAllFromStorage(int chatId) async {

    //? Salvo la response nella storage
    String? messageList = await storage.read(key: chatMessageStorageKey);

    if(messageList != null) {
      return (jsonDecode(messageList)["$chatId"] as List<dynamic>)
        .map((message) => Message.fromJson(message))
        .toList();
    }

    return [];
  }
}
