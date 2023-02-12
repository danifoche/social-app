import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:social_app_bloc/data/repositories/authentication_repository.dart';
import 'package:social_app_bloc/data/repositories/pusher_repository.dart';
import 'package:social_app_bloc/settings/app_settings.dart';

part 'pusher_event.dart';
part 'pusher_state.dart';

class PusherBloc extends Bloc<PusherEvent, PusherState> {

  final PusherChannelsFlutter _pusher = PusherChannelsFlutter();
  final PusherRepository _pusherRepository = PusherRepository();
  final AuthenticationRepository _authenticationRepository =
      AuthenticationRepository();

  String? socketId;

  final StreamController _eventController = StreamController();
  late StreamSubscription _eventSubscription;
  

  PusherBloc() : super(PusherInitial()) {
    
    handleEvents();

    on<PusherInit>((event, emit) async {
      try {
        await _pusher.init(
          apiKey: pusherSettings["apiKey"],
          cluster: pusherSettings["cluster"],
          onAuthorizer: (channelName, socketId, options) async => await _pusherRepository.init(socketId, channelName, event.token),
          onError: (message, code, error) => throw Exception(error),
          onSubscriptionError: (message, error) => throw Exception(error),
        );

        await _pusher.connect();

        emit(PusherConnected());
      } catch (e) {
        emit(PusherError(message: e.toString()));
      }
    });

    on<PusherSubscribeChannel>((event, emit) async {

      try {
        
        //? Mi iscrivo al canale
        PusherChannel channel = await _pusher.subscribe(channelName: event.channel);

        //? Memorizzo il socketId
        channel.onSubscriptionSucceeded = (_) => socketId = channel.me?.userInfo?["socket_id"];

        //? Ascolto gli eventi
        channel.onEvent = (event) => _eventController.add(event);

      } catch (e) {
        emit(PusherError(message: e.toString()));
      }

    });

    //? Imposta un nuovo evento
    on<PusherSetNewEvent>((event, emit) => emit(PusherNewEvent(data: event.data)));
  }

  //? Funzione che mi permette di gestire gli eventi di pusher con uno stream
  StreamSubscription handleEvents() {
    return _eventSubscription = _eventController.stream.listen((event) {

      //? Dati che mi arrivano dal websocket
      Map<String, dynamic> payload = jsonDecode(event.data);
      
      if(event.eventName == "new-message") {
        add(PusherSetNewEvent(data: payload));
      }

    });
  }
}
