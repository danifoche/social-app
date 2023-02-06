import 'package:social_app_bloc/data/models/message.dart';
import 'package:social_app_bloc/data/providers/chat_message_api.dart';

class ChatMessageRepository {

  ChatMessageApi _chatMessageApi = ChatMessageApi();

  //? Ottengo tutti i messaggi di una chat specifica
  Future<List<Message>?> getAll(String token, int chatId) async => await _chatMessageApi.getAll(token, chatId);

  //? Aggiunge un nuovo messaggio ad una chat specifica
  Future<bool> addMessage(String token, int chatId, String message) async => await _chatMessageApi.addMessage(token, chatId, message);

  //? Ottengo tutti i messaggi dalla storage di una chat specifica
  Future<List<Message>> getAllFromStorage(int chatId) async => await _chatMessageApi.getAllFromStorage(chatId);

}