import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social_app_bloc/data/models/user.dart';
import 'package:social_app_bloc/data/repositories/authentication_repository.dart';
import 'package:social_app_bloc/data/repositories/user_repository.dart';
import 'package:rxdart/rxdart.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository = UserRepository();
  final AuthenticationRepository _authenticationRepository =
      AuthenticationRepository();

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }

  UserBloc() : super(UserInitial()) {
    on<UserEvent>((event, emit) {});

    //? Cerca tutti gli utenti con una pattern specifica
    on<UserSearch>((event, emit) async {
      try {
        //? Mostro caricamento
        emit(UserLoading());

        if (event.searchPattern.isEmpty) {
          return emit(UserEmptyString());
        }

        //? Ottengo il token
        Map<String, dynamic>? token =
            await _authenticationRepository.getUserToken();

        //? Verifico che il token non sia nullo e in caso emitto stato di errore
        if (token == null) {
          emit(const UserTokenError(message: "An error has occoured!"));
        } else {
          List<User>? response = await _userRepository.searchUser(
              token["token"], event.searchPattern);

          if (response == null) {
            emit(const UserError(message: "User not found"));
          } else {
            //? Mostro la lista
            emit(UserLoadedList(userList: response));
          }
        }
      } catch (e) {
        emit(UserError(message: e.toString()));
      }
    },

        //? Aggiungo del delay per evitare di fare troppe chiamate al server
        transformer: debounce(const Duration(milliseconds: 300)));

    //? Crea una chat con l'utente scelto
    on<UserCreateChat>(
      (event, emit) async {

        try {
          
          //? Mostro caricamento
          emit(UserLoading());

          //? Ottengo il token
          Map<String, dynamic>? token =
              await _authenticationRepository.getUserToken();

          //? Controllo se il token é nullo
          if(token == null) {
            emit(const UserTokenError(message: "An error has occoured"));
          } else {

            //? Faccio la chiamata api
            Map<String, dynamic>? response = await _userRepository.createChatWithUser(token["token"], event.username);

            //? Se la chiamata ritorna nullo in questo caso significa che é andata a buon fine
            if (response == null) {
              emit(const UserNotificationSuccess(message: "Chat created successfully!"));
            } else {
              emit(UserNotificationError(message: response["message"]));
            }

            emit(UserInitial());
          }

        } catch (e) {
          emit(UserError(message: e.toString()));
        }

      },
    );

    //? Ottieni tutte le info dell'utente loggato 
    on<UserGetInfo>((event, emit) async {

      try {
        
        User? user = await _userRepository.getInfo();

        if(user == null) {
          emit(const UserError(message: "An error has occoured!"));
        } else {
          emit(UserProfileLoaded(user: user));
        }

      } catch (e) {
        emit(UserError(message: e.toString()));
      }

    });
  }
}
