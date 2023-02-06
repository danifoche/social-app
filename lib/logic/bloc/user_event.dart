part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

//? Evento triggerato per creare una nuova chat con un utente
class UserAdd extends UserEvent {}

//? Evento triggerato per mostrare la lista di utenti
class UserSearch extends UserEvent {

  //? La stringa utilizzata per cercare tutti gli utenti
  final String searchPattern;

  const UserSearch({required this.searchPattern});
}

class UserCreateChat extends UserEvent {

  //? Username dell'utente con cui creare una nuova conversazione
  final String username;

  const UserCreateChat({required this.username});

}