part of 'pusher_bloc.dart';

abstract class PusherState extends Equatable {
  const PusherState();
  
  @override
  List<Object> get props => [];
}

class PusherInitial extends PusherState {}

//? Stato di errore generico
class PusherError extends PusherState {

  final String message;

  const PusherError({required this.message});

}

//? Stato di errore token
class PusherTokenError extends PusherState {

  final String message;

  const PusherTokenError({required this.message});

}

//? Stato di connessione effettuata con successo
class PusherConnected extends PusherState {}

//? Stato triggerato quando ce un nuovo evento da websocket
class PusherNewEvent extends PusherState {

  final Map<String, dynamic> data;

  const PusherNewEvent({required this.data});
}