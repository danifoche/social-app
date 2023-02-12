import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:social_app_bloc/data/models/message.dart';
import 'package:social_app_bloc/data/repositories/authentication_repository.dart';
import 'package:social_app_bloc/data/repositories/chat_message_repository.dart';
import 'package:social_app_bloc/logic/bloc/pusher_bloc.dart';

part 'chat_message_event.dart';
part 'chat_message_state.dart';

class ChatMessageBloc extends Bloc<ChatMessageEvent, ChatMessageState> {

  final ChatMessageRepository _chatMessageRepository = ChatMessageRepository();
  final AuthenticationRepository _authenticationRepository = AuthenticationRepository();

  final PusherBloc _pusherBloc = PusherBloc();
  // ignore: unused_field
  late StreamSubscription _pusherSubscription;
  
  ChatMessageBloc() : super(ChatMessageInitial()) {

    initPusher();

    //? Ottieni tutti messaggi di una determinata chat
    on<ChatMessageGetAll>((event, emit) async {
      
      try {
        
        //? Mostro caricamento
        emit(ChatMessageLoading());

        //? Ottengo il token
        Map<String, dynamic>? token = await _authenticationRepository.getUserToken();

        //? Verifico che il token non sia nullo e in caso emitto stato di errore
        if(token == null) {
          emit(const ChatMessageTokenError(message: "An error has occoured!"));
        } else {

          //? Mi connetto al websocket
          _pusherBloc.add(PusherInit(token: token["token"]));

          List<Message>? response = await _chatMessageRepository.getAll(token["token"], event.chatId);

          if(response == null) {
            emit(const ChatMessageError(message: "An error has occoured!"));
          } else if(response.isEmpty) {
            emit(const ChatMessageEmpty(message: "Send a message!"));
          } else {
            emit(ChatMessageLoaded(chatList: response));
          }
        }

      } catch (e) {
        emit(ChatMessageError(message: e.toString()));
      }

    });

    //? Aggiunge un nuovo messaggio
    on<ChatMessageNew>((event, emit) async {
      
      try {
        
        //? Ottengo il token
        Map<String, dynamic>? token = await _authenticationRepository.getUserToken();

        //? Verifico che il token non sia nullo e in caso emitto stato di errore
        if(token == null) {
          emit(const ChatMessageTokenError(message: "An error has occoured!"));
        } else {

          bool result = await _chatMessageRepository.addMessage(token["token"], event.chatId, event.message);

          if(result) {
            add(ChatMessageGetAllFromStorage(chatId: event.chatId));
          } else {
            emit(const ChatMessageError(message: "An error has occoured!"));
          }

        }

      } catch (e) {
        emit(ChatMessageError(message: e.toString()));
      }

    });

    //? Ottengo tutti i messaggi dalla storage per una chat specifica
    on<ChatMessageGetAllFromStorage>((event, emit) async {

      try {
        
        List<Message> response = await _chatMessageRepository.getAllFromStorage(event.chatId);
        emit(ChatMessageLoaded(chatList: response));

      } catch (e) {
        emit(ChatMessageError(message: e.toString()));
      }
      
    });

    //? Controllo lo stato di pusher
    on<ChatMessageSetPusherStatus>((event, emit) => 
      emit(ChatMessagePusherStatus(connected: event.connected, message: event.message)));

    on<ChatMessageSubscribeChannel>((event, emit) => _pusherBloc.add(PusherSubscribeChannel(channel: "presence-chat-${event.websocketId}")));

    on<ChatMessageAdd>((event, emit) async {

      try {

        Map<String, dynamic>? loggedUserId = await _authenticationRepository.getUserId();

        if(loggedUserId == null) {
          throw Exception("An error has occoured!");
        }

        //? Mi costruisco il nuovo messaggio dal modello
        Message newMessage = Message(
          message: event.message,
          isMe: loggedUserId["id"] == event.userId
        );
        
        //? Ottengo tutta la chat dalla storage
        List<Message> response = await _chatMessageRepository.getAllFromStorage(event.chatId);

        //? Inserisco il nuovo messaggio
        response.insert(0, newMessage);

        emit(ChatMessageLoaded(chatList: response));

      } catch (e) {
        emit(ChatMessageError(message: e.toString()));
      }

    });
  }

  StreamSubscription<PusherState> initPusher() {
    return _pusherSubscription = _pusherBloc.stream.listen((state) {
      if(state is PusherError) {
        add(ChatMessageSetPusherStatus(connected: false, message: state.message));
      } else if(state is PusherConnected) {
        add(const ChatMessageSetPusherStatus(connected: true, message: ""));
      } else if(state is PusherNewEvent) {

        String payload = state.data["message"];
        int userId = state.data["user"];
        int chatId = state.data["chatId"];

        add(ChatMessageAdd(message: payload, userId: userId, chatId: chatId));
      }
    });
  }

  @override
  Future<void> close() {
    _pusherSubscription.cancel();
    return super.close();
  }
}
