part of 'chat_message_bloc.dart';

abstract class ChatMessageState extends Equatable {
  const ChatMessageState();
  
  @override
  List<Object> get props => [];
}

//? Stato iniziale
class ChatMessageInitial extends ChatMessageState {}

//? Stato di caricamento
class ChatMessageLoading extends ChatMessageState {}

//? Stato di caricamento completato
class ChatMessageLoaded extends ChatMessageState {

  final List<Message> chatList;

  const ChatMessageLoaded({required this.chatList});

  @override
  List<Object> get props => [chatList];

}

//? Stato di errore token
class ChatMessageTokenError extends ChatMessageState {

  final String message;

  const ChatMessageTokenError({required this.message});

}

//? Stato di errore generico
class ChatMessageError extends ChatMessageState {

  final String message;

  const ChatMessageError({required this.message});

}

//? Stato triggerato quando la chat è vuota
class ChatMessageEmpty extends ChatMessageState {

  final String message;

  const ChatMessageEmpty({required this.message});

}