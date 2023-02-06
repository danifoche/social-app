part of 'chat_list_view_bloc.dart';

abstract class ChatListViewState extends Equatable {
  const ChatListViewState();
  
  @override
  List<Object> get props => [];
}

//? Initial bloc state
class ChatListViewInitial extends ChatListViewState {}

//? Loading state
class ChatListViewLoading extends ChatListViewState {}

//? Loaded state with data
class ChatListViewLoaded extends ChatListViewState {

  final List<ChatList> chatList;

  const ChatListViewLoaded({required this.chatList});

}

//? Stato con errore token
class ChatListViewTokenError extends ChatListViewState {

  final String message;

  const ChatListViewTokenError({required this.message});

}

//? Stato con errore caricamento lista
class ChatListViewError extends ChatListViewState {

  final String message;

  const ChatListViewError({required this.message});

}

//? Stato con lista vuota
class ChatListViewEmpty extends ChatListViewState {

  final String message;

  const ChatListViewEmpty({required this.message});

}