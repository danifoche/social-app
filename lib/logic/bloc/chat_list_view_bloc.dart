import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social_app_bloc/data/models/chatlist.dart';
import 'package:social_app_bloc/data/repositories/authentication_repository.dart';
import 'package:social_app_bloc/data/repositories/chat_list_view_repository.dart';
import 'package:social_app_bloc/logic/cubit/authentication_cubit.dart';

part 'chat_list_view_event.dart';
part 'chat_list_view_state.dart';

class ChatListViewBloc extends Bloc<ChatListViewEvent, ChatListViewState> {

  //? Repository per autenticazione
  final AuthenticationRepository _authenticationRepository = AuthenticationRepository();

  //? Repository per la lista delle chat
  final ChatListViewRepository _chatListViewRepository = ChatListViewRepository();

  ChatListViewBloc() : super(ChatListViewInitial()) {

    //? Evento generale 
    // TODO: cancellare?
    on<ChatListViewEvent>((event, emit) {
      
    });

    //? Carica la lista delle chat
    on<ChatListViewLoadList>((event, emit) async {

      //? Emitto caricamento
      emit(ChatListViewLoading());

      //? Ottengo il token
      Map<String, dynamic>? token = await _authenticationRepository.getUserToken();

      //? Verifico che il token non sia nullo e in caso emitto stato di errore
      if(token == null) {
        emit(const ChatListViewTokenError(message: "An error has occoured!"));
      } else {

        try {
          
          //? Faccio la chiamata api
          List<ChatList>? chatList = await _chatListViewRepository.loadList(token["token"]);

          //? Se la risposta e diversa da null allora ho ottenuto dei risultati altrimenti mostro messaggio di lista vuota
          if(chatList != null) {
            emit(ChatListViewLoaded(chatList: chatList));
          } else {
            emit(const ChatListViewEmpty(message: "No chats found!"));
          }

        } catch (e) {
          emit(ChatListViewError(message: e.toString()));
        }
        
      }
    
    });

    //? Cancella una chat specifica
    on<ChatListViewDelete>((event, emit) async {

      //? Emitto caricamento
      emit(ChatListViewLoading());

      //? Id della chat
      int chatId = event.chatId;

      //? Ottengo il token
      Map<String, dynamic>? token = await _authenticationRepository.getUserToken();

      //? Verifico che il token non sia nullo e in caso emitto stato di errore
      if(token == null) {
        emit(const ChatListViewTokenError(message: "An error has occoured!"));
      } else {

        try {
          
          //? Faccio la chiamata api
          Map<String, dynamic>? response = await _chatListViewRepository.deleteChat(token["token"], chatId);

          //? Controllo se la chiamata e andata a buon fine
          if(response != null) {
            emit(ChatListViewError(message: response["message"]));
          }

          //? Faccio ricaricare la lista
          add(ChatListViewLoadList());

        } catch (e) {
          emit(ChatListViewError(message: e.toString()));
        }

      }

    });

    //? Filtra la lista di chat in base al nome inserito
    on<ChatListFilter>((event, emit) async {

      try {
        
        //? Mostro caricamento
        emit(ChatListViewLoading());

        //? Chiedo la lista filtrata delle chat in base al nome fornito
        List<ChatList>? response = await _chatListViewRepository.filterList(event.chatName);

        if(response == null) {
          emit(const ChatListViewEmpty(message: "Chat not found!"));
        } else {
          emit(ChatListViewLoaded(chatList: response));
        }

      } catch (e) {
        emit(ChatListViewError(message: e.toString()));
      }

    });
  }
}
