import 'package:social_app_bloc/data/models/chatlist.dart';
import 'package:social_app_bloc/data/providers/chat_list_view_api.dart';

class ChatListViewRepository {

  final ChatListViewApi _chatListViewApi = ChatListViewApi();
  
  //? Carica la lista
  Future<List<ChatList>?> loadList(String token) async => await _chatListViewApi.loadList(token);

  //? Cancella una chat specifica
  Future<Map<String, dynamic>?> deleteChat(String token, int id) async => await _chatListViewApi.deleteChat(token, id);

  //? Filtra la lista
  Future<List<ChatList>?> filterList(String chatName) async => await _chatListViewApi.filterList(chatName);

}