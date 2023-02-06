part of 'chat_message_bloc.dart';

abstract class ChatMessageEvent extends Equatable {
  const ChatMessageEvent();

  @override
  List<Object> get props => [];
}


//? Evento triggerato per ottenere tutti i messaggi di una chat
class ChatMessageGetAll extends ChatMessageEvent {

  //? Id della chat
  final int chatId;

  const ChatMessageGetAll({required this.chatId});

}

//? Evento triggerato per aggiunger un nuovo messaggio ad una chat specifica
class ChatMessageNew extends ChatMessageEvent {

  final String message;
  final int chatId;

  const ChatMessageNew({required this.message, required this.chatId});

}

//? Evento triggerato per ottenere tutti i messaggi di una chat dalla storage
class ChatMessageGetAllFromStorage extends ChatMessageEvent {

  //? Id della chat
  final int chatId;

  const ChatMessageGetAllFromStorage({required this.chatId});

}