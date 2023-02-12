part of 'pusher_bloc.dart';

abstract class PusherEvent extends Equatable {
  const PusherEvent();

  @override
  List<Object> get props => [];
}

//? Evento che inizializza il pusher
class PusherInit extends PusherEvent {

  //? Token dell'utente corrente
  final String token;

  const PusherInit({required this.token});

}

//? Evento usato per iscriversi ad un canale
class PusherSubscribeChannel extends PusherEvent {

  //? Id del websocket a cui iscriversi
  final String channel;

  const PusherSubscribeChannel({required this.channel});
}

//? Evento usato per impostare un nuovo evento da websocket
class PusherSetNewEvent extends PusherEvent {

  final Map<String, dynamic> data;

  const PusherSetNewEvent({required this.data});

}
