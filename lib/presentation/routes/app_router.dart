import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_bloc/logic/bloc/chat_list_view_bloc.dart';
import 'package:social_app_bloc/logic/bloc/chat_message_bloc.dart';
import 'package:social_app_bloc/logic/cubit/authentication_cubit.dart';
import 'package:social_app_bloc/presentation/pages/Chat.dart';
import 'package:social_app_bloc/presentation/pages/Home.dart';
import 'package:social_app_bloc/presentation/pages/Login.dart';
import 'package:social_app_bloc/presentation/pages/Signup.dart';
import 'package:social_app_bloc/settings/app_settings.dart';

//? Funzione chiamata per generare una nuova rotta
Route? onGenerateRoute(RouteSettings routeSettings) {
  //? Argomenti passati con la rotta
  Map? arguments = routeSettings.arguments as Map?;

  switch (routeSettings.name) {

    //? Pagina di login
    case '/login':
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (_) => AuthenticationCubit(),
          child: const Login(),
        ),
      );

    case '/home':
      return MaterialPageRoute(
        builder: (context) => BlocProvider<AuthenticationCubit>(
          //? Controllo se provengo da una delle due rotte di autenticazione e nel caso
          //? non faccio il check del token perche mi è appena stato dato quindi
          //? sarà valido
          create: (_) => (arguments?["from_route"] != null &&
                  authenticationRoutes.contains(arguments?["from_route"])
              ? AuthenticationCubit(CheckTokenSuccess())
              : AuthenticationCubit()),
          child: const Home(),
        ),
      );

    case '/signup':
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (_) => AuthenticationCubit(),
          child: const Signup(),
        ),
      );

    case '/chat':
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => ChatMessageBloc(),
          child: Chat(
            chatId: arguments?["chatId"] ?? 0,
            chatName: arguments?["chatName"] ?? "",
            websocketId: arguments?["websocketId"] ?? "",
            members: arguments?["members"] ?? [],
            image: arguments?["image"] ?? "",
          ),
        ),
      );

    //? Nel caso non ci fosse la rotta ritorno null
    default:
      return null;
  }
}

// TODO: implementare rotta /error in caso di errori generici
