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

//? Evento triggerato per segnalare eventi se necessario
class ChatMessageSetPusherStatus extends ChatMessageEvent {

  //? Variabile che determina se ci sono degli errori di connessione
  final bool connected;

  //? Messaggio di errore
  final String message;

  const ChatMessageSetPusherStatus({required this.connected, required this.message});
}

//? Subscribe to a channel
class ChatMessageSubscribeChannel extends ChatMessageEvent {

  //? Id del websocket a cui connettersi
  final String websocketId;

  const ChatMessageSubscribeChannel({required this.websocketId});

}

//? Evento triggerato per aggiungere un messaggio arrivato da websocket
class ChatMessageAdd extends ChatMessageEvent {

  //? Messaggio da inviare
  final String message;

  //? Id dell'utente che ha inviato il messaggio
  final int userId;

  //? Id della chat dove e stato aggiunto un nuovo messaggio
  final int chatId;

  const ChatMessageAdd({required this.message, required this.userId, required this.chatId});

}