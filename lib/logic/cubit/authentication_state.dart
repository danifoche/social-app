part of 'authentication_cubit.dart';

@immutable
abstract class AuthenticationState extends Equatable {}

class AuthenticationInitial extends AuthenticationState {

  @override
  List<Object?> get props => [];
}

class LoginError extends AuthenticationState {
  final String message;

  LoginError({required this.message});
  
  @override
  List<Object?> get props => [];
}

// ignore: must_be_immutable
class LoginSuccess extends AuthenticationState {

  String logInSuccess = 'Logged in successfully';

  @override
  List<Object?> get props => [];
}

class AuthenticationLoading extends AuthenticationState {

  @override
  List<Object?> get props => [];
}

class RegistrationError extends AuthenticationState {
  final dynamic message;

  RegistrationError({required this.message});
  
  @override
  List<Object?> get props => [];
}

// ignore: must_be_immutable
class RegistrationSuccess extends AuthenticationState {

  String logInSuccess = 'Registered successfully';

  @override
  List<Object?> get props => [];
}

class CheckTokenError extends AuthenticationState {

  final String message;

  CheckTokenError({required this.message});

  @override
  List<Object?> get props => [];
}

class CheckTokenSuccess extends AuthenticationState {

  @override
  List<Object?> get props => [];
}

class AuthenticationToken extends AuthenticationState {

  final String token;

  AuthenticationToken({required this.token});

  @override
  List<Object?> get props => [];
}

class GetTokenError extends AuthenticationState {

  final String message;

  GetTokenError({required this.message});

  @override
  List<Object?> get props => [];
}