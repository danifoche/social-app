part of 'chat_list_view_bloc.dart';

abstract class ChatListViewEvent extends Equatable {
  const ChatListViewEvent();

  @override
  List<Object> get props => [];
}

//? Evento triggerato per caricare la lista di chat da api
class ChatListViewLoadList extends ChatListViewEvent {}

//? Evento triggerato quando viene richiesta cancellazione di una chat
class ChatListViewDelete extends ChatListViewEvent {
  
  //? Id della chat da eliminare
  final int chatId;

  const ChatListViewDelete({required this.chatId});
}

//? Evento triggerato quando si cerca una chat dall'input
class ChatListFilter extends ChatListViewEvent {

  final String chatName;

  const ChatListFilter({required this.chatName});

}