import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_bloc/logic/bloc/chat_list_view_bloc.dart';
import 'package:social_app_bloc/presentation/widgets/ChatListViewItem.dart';
import 'package:social_app_bloc/utils/custom_snackbar.dart';
import 'package:social_app_bloc/settings/app_settings.dart';

class ChatListView extends StatefulWidget {
  const ChatListView({super.key});

  @override
  State<ChatListView> createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {
  //? Istanza classe per mostrare le notifiche
  final ShowSnackBar _customSnackbar = ShowSnackBar();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
        child: Column(
          children: [
            Center(
              child: Text(
                'HomePage',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
              child: TextField(
                controller: null,
                onChanged: (value) {
                  BlocProvider.of<ChatListViewBloc>(context).add(ChatListFilter(chatName: value));
                },
                cursorColor: const Color(0xFF757575),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                  border: Theme.of(context).inputDecorationTheme.border,
                  hintText: 'Search',
                  hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
                  enabledBorder:
                      Theme.of(context).inputDecorationTheme.enabledBorder,
                  focusedBorder:
                      Theme.of(context).inputDecorationTheme.focusedBorder,
                ),
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
            BlocConsumer<ChatListViewBloc, ChatListViewState>(
              listener: (context, state) {
                if (state is ChatListViewTokenError) {
                  //? Mostra snackbar di errore
                  _customSnackbar.error(context, state.message);

                  //? Porta l'utente a loggarsi nuovamente
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      appRoutes["login"] ?? "/error", (route) => false);
                }
              },
              builder: (context, state) {
                print(state);
                if (state is ChatListViewInitial) {
                  BlocProvider.of<ChatListViewBloc>(context)
                      .add(ChatListViewLoadList());
                  return const Expanded(
                      child: Center(child: CircularProgressIndicator()));
                } else if (state is ChatListViewLoading) {
                  return const Expanded(
                      child: Center(child: CircularProgressIndicator()));
                } else if (state is ChatListViewLoaded) {
                  return Flexible(
                    flex: 1,
                    child: RefreshIndicator(
                      backgroundColor: Theme.of(context).primaryColor,
                      color: Colors.white,
                      displacement: 20.0,
                      onRefresh: () async {
                        BlocProvider.of<ChatListViewBloc>(context)
                            .add(ChatListViewLoadList());
                      },
                      child: ListView.builder(
                          itemCount: state.chatList.length,
                          itemBuilder: (context, index) {
                            return ChatListViewItem(
                              id: state.chatList[index].id ?? 0,
                              name: state.chatList[index].name ?? "",
                              websocketId:
                                  state.chatList[index].websocketId ?? "",
                              members: state.chatList[index].members ?? [],
                              lastMessage:
                                  state.chatList[index].lastMessage ?? "",
                              newMessage:
                                  state.chatList[index].newMessage ?? false,
                              image: state.chatList[index].image ?? "",
                            );
                          }),
                    ),
                  );
                } else if (state is ChatListViewEmpty) {
                  return Flexible(
                    flex: 1,
                    child: RefreshIndicator(
                      backgroundColor: Theme.of(context).primaryColor,
                      color: Colors.white,
                      displacement: 20.0,
                      onRefresh: () async {
                        BlocProvider.of<ChatListViewBloc>(context)
                            .add(ChatListViewLoadList());
                      },
                      child: LayoutBuilder(
                        builder: (context, constraints) => ListView(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20.0),
                              constraints: BoxConstraints(
                                minHeight: constraints.maxHeight,
                              ),
                              child: Center(
                                child: Text(
                                  state.message,
                                  style: Theme.of(context).textTheme.labelMedium,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else if (state is ChatListViewError) {
                  return Flexible(
                    flex: 1,
                    child: RefreshIndicator(
                      backgroundColor: Theme.of(context).primaryColor,
                      color: Colors.white,
                      displacement: 20.0,
                      onRefresh: () async {
                        BlocProvider.of<ChatListViewBloc>(context)
                            .add(ChatListViewLoadList());
                      },
                      child: LayoutBuilder(
                        builder: (context, constraints) => ListView(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20.0),
                              constraints: BoxConstraints(
                                minHeight: constraints.maxHeight,
                              ),
                              child: Center(
                                child: Text(
                                  state.message,
                                  style: TextStyle(
                                    fontSize: Theme.of(context).textTheme.labelMedium!.fontSize,
                                    fontWeight: Theme.of(context).textTheme.labelMedium!.fontWeight,
                                    color: Theme.of(context).errorColor
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return const Expanded(
                      child: Center(child: Text("An error has occoured!")));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
