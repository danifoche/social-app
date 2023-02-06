import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_bloc/logic/bloc/chat_message_bloc.dart';
import 'package:social_app_bloc/presentation/widgets/ChatMessage.dart';
import 'package:social_app_bloc/settings/app_settings.dart';
import 'package:social_app_bloc/utils/custom_snackbar.dart';

class Chat extends StatefulWidget {
  final String chatName;
  final int chatId;
  final String websocketId;
  final List members;
  final String image;

  const Chat({
    super.key,
    required this.chatId,
    required this.chatName,
    required this.websocketId,
    required this.members,
    required this.image,
  });

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  //? AnimatedList key
  final GlobalKey<AnimatedListState> _animatedListKey =
      GlobalKey<AnimatedListState>();

  //? Istanza classe per mostrare le notifiche
  final ShowSnackBar _customSnackbar = ShowSnackBar();

  final TextEditingController messageInputController = TextEditingController();

  Widget header() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        widget.image.isEmpty
            ? const SizedBox(
                width: 50,
                height: 50,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Color(0xFFEEEEEE),
                  ),
                ),
              )
            : SizedBox(
                width: 50,
                height: 50,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(100),
                    ),
                    color: const Color(0xFFEEEEEE),
                    border: Border.all(
                      color: const Color(0xFFEEEEEE),
                      width: 4.0,
                    ),
                    image: DecorationImage(
                      filterQuality: FilterQuality.medium,
                      fit: BoxFit.contain,
                      image: MemoryImage(
                        base64Decode(widget.image),
                      ),
                    ),
                  ),
                ),
              ),
        Flexible(
          child: Container(
            padding: const EdgeInsets.only(left: 10.00, right: 40.00),
            child: Text(
              widget.chatName,
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget chatBody() {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Expanded(
            child: BlocConsumer<ChatMessageBloc, ChatMessageState>(
                listener: (context, state) {
              if (state is ChatMessageTokenError) {
                //? Mostra snackbar di errore
                _customSnackbar.error(context, state.message);

                //? Porta l'utente a loggarsi nuovamente
                Navigator.of(context).pushNamedAndRemoveUntil(
                    appRoutes["login"] ?? "/error", (route) => false);
              }
            }, builder: (context, state) {
              if (state is ChatMessageInitial) {
                BlocProvider.of<ChatMessageBloc>(context)
                    .add(ChatMessageGetAll(chatId: widget.chatId));
              } else if (state is ChatMessageLoaded) {

                //? Animazione per l'arrivo di un messaggio
                _animatedListKey.currentState?.insertItem(0);

                return AnimatedList(
                  key: _animatedListKey,
                  reverse: true,
                  controller: null,
                  padding: const EdgeInsets.all(15),
                  initialItemCount: state.chatList.length,
                  itemBuilder: ((context, index, animation) {
                    return SizeTransition(
                      sizeFactor: CurvedAnimation(
                        parent: animation,
                        curve: Curves.decelerate,
                      ),
                      child: ChatMessage(
                        message: state.chatList[index].message ?? "",
                        isMe: state.chatList[index].isMe ?? true,
                      ),
                    );
                  }),
                );
              } else if (state is ChatMessageEmpty) {
                return Center(
                  child: Text(
                    state.message,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                );
              } else if (state is ChatMessageError) {
                return Center(
                  child: Text(
                    state.message,
                    style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.labelMedium!.fontSize,
                      fontWeight:
                          Theme.of(context).textTheme.labelMedium!.fontWeight,
                      color: Theme.of(context).errorColor,
                    ),
                  ),
                );
              } else if (state is ChatMessageLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return Center(
                child: Text(
                  "An error has occoured",
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.labelMedium!.fontSize,
                    fontWeight:
                        Theme.of(context).textTheme.labelMedium!.fontWeight,
                    color: Theme.of(context).errorColor,
                  ),
                ),
              );
            }),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, top: 16.0, right: 16.0, bottom: 16.0),
                  child: TextField(
                    controller: messageInputController,
                    cursorColor:
                        Theme.of(context).textSelectionTheme.cursorColor,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor:
                          Theme.of(context).inputDecorationTheme.fillColor,
                      border: Theme.of(context).inputDecorationTheme.border,
                      hintText: 'Message',
                      hintStyle:
                          Theme.of(context).inputDecorationTheme.hintStyle,
                      enabledBorder:
                          Theme.of(context).inputDecorationTheme.enabledBorder,
                      focusedBorder:
                          Theme.of(context).inputDecorationTheme.focusedBorder,
                    ),
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 16.0, right: 8.0, bottom: 16.0),
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(20),
                    shape: const CircleBorder(),
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () {
                    BlocProvider.of<ChatMessageBloc>(context).add(
                      ChatMessageNew(
                        message: messageInputController.text,
                        chatId: widget.chatId,
                      ),
                    );  

                    //? Pulisco l'input
                    messageInputController.text = '';
                  },
                  child: Icon(
                    Icons.send,
                    color: Theme.of(context).primaryColor,
                    size: 25,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: BackButton(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
        title: header(),
      ),
      body: chatBody(),
    );
  }
}
