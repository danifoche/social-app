part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();
  
  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

//? Stato di caricamento
class UserLoading extends UserState {}

//? Stato di lista caricata 
class UserLoadedList extends UserState {

  final List<User>? userList;

  const UserLoadedList({required this.userList});

}

//? Stato di errore generico
class UserError extends UserState {

  final String message;

  const UserError({required this.message});

}

//? Stato di errore generico per notifiche
class UserNotificationError extends UserState {

  final String message;

  const UserNotificationError({required this.message});

}

//? Stato di successo generico per notifiche
class UserNotificationSuccess extends UserState {

  final String message;

  const UserNotificationSuccess({required this.message});

}

//? Stato di errore token
class UserTokenError extends UserState {

  final String message;

  const UserTokenError({required this.message});

}

//? Stato triggerato quando la pattern e vuota quindi quando l'input è vuoto
//? Serve per non buildare troppe volte il bloc
class UserEmptyString extends UserState {}
