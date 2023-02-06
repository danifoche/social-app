import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:social_app_bloc/logic/bloc/chat_list_view_bloc.dart';
import 'package:social_app_bloc/logic/bloc/user_bloc.dart';
import 'package:social_app_bloc/logic/cubit/authentication_cubit.dart';
import 'package:social_app_bloc/presentation/widgets/AddChat.dart';
import 'package:social_app_bloc/presentation/widgets/ChatListView.dart';
import 'package:social_app_bloc/presentation/widgets/SplashScreen.dart';
import 'package:social_app_bloc/utils/custom_snackbar.dart';
import 'package:social_app_bloc/settings/app_settings.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //? Index che serve per mostrare il tipo di schermata
  int index = 0;

  //? Istanza classe per mostrare le notifiche
  final ShowSnackBar _customSnackbar = ShowSnackBar();

  //? Funzione utilizzata per cambiare la pagina se necessario
  void changeScreen(dynamic newindex) {
    setState(() {
      index = newindex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if (state is CheckTokenError) {
          //? Mostra snackbar di errore
          _customSnackbar.error(context, state.message);

          //? Porta l'utente a loggarsi nuovamente
          Navigator.of(context).pushNamedAndRemoveUntil(
              appRoutes["login"] ?? "/error", (route) => false);
        }
      },
      builder: (context, state) {
        if (state is AuthenticationInitial) {
          BlocProvider.of<AuthenticationCubit>(context).checkUserToken();
          return const SplashScreen();
        } else {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: IndexedStack(
              index: index,
              children: [
                BlocProvider(
                  create: (context) => ChatListViewBloc(),
                  child: const ChatListView(),
                ),
                BlocProvider(
                  create: (context) => UserBloc(),
                  child: AddChat(
                    changeScreen: changeScreen,
                  ),
                ),
                const Text("ciao3"),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              iconSize: 35.0,
              showSelectedLabels:
                  Theme.of(context).bottomNavigationBarTheme.showSelectedLabels,
              showUnselectedLabels: Theme.of(context)
                  .bottomNavigationBarTheme
                  .showUnselectedLabels,
              currentIndex: index,
              onTap: (int newIndex) {
                setState(() {
                  index = newIndex;
                });
              },
              selectedItemColor: Theme.of(context)
                  .bottomNavigationBarTheme
                  .selectedIconTheme!
                  .color,
              backgroundColor:
                  Theme.of(context).bottomNavigationBarTheme.backgroundColor,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.chat),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.add_circle),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle),
                  label: '',
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
