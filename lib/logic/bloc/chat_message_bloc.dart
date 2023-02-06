import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social_app_bloc/data/models/message.dart';
import 'package:social_app_bloc/data/repositories/authentication_repository.dart';
import 'package:social_app_bloc/data/repositories/chat_message_repository.dart';

part 'chat_message_event.dart';
part 'chat_message_state.dart';

class ChatMessageBloc extends Bloc<ChatMessageEvent, ChatMessageState> {

  final ChatMessageRepository _chatMessageRepository = ChatMessageRepository();
  final AuthenticationRepository _authenticationRepository = AuthenticationRepository();
  
  ChatMessageBloc() : super(ChatMessageInitial()) {
    on<ChatMessageEvent>((event, emit) {
      // TODO: implement event handler
    });

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
  }
}
