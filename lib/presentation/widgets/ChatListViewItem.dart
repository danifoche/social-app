import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:social_app_bloc/logic/bloc/chat_list_view_bloc.dart';
import 'package:social_app_bloc/settings/app_settings.dart';
import 'package:social_app_bloc/utils/custom_dialog.dart';

class ChatListViewItem extends StatefulWidget {
  final int id;
  final String name;
  final String websocketId;
  final List members;
  final String lastMessage;
  final bool newMessage;
  final String image;
  // final AsyncValueSetter getChats;

  const ChatListViewItem({
    super.key,
    required this.id,
    required this.name,
    required this.websocketId,
    required this.members,
    required this.lastMessage,
    required this.newMessage,
    required this.image,
    // required this.getChats
  });

  @override
  State<ChatListViewItem> createState() => _ChatListViewItemState();
}

class _ChatListViewItemState extends State<ChatListViewItem> {
  final CustomDialog _customDialog = CustomDialog();

  //? Cancella la chat selezionata
  void _handleDeleteChat(int id) {
    _customDialog.showYesNoDialog(
      context,
      const Text("Warning"),
      const Text("Are you sure to delete this chat?"),
      () {
        BlocProvider.of<ChatListViewBloc>(context)
            .add(ChatListViewDelete(chatId: id));
        Navigator.of(context).pop();
      },
      () => Navigator.of(context).pop(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(widget.id),
      endActionPane:
          ActionPane(motion: const DrawerMotion(), children: <Widget>[
        SlidableAction(
          onPressed: (_) => _handleDeleteChat(widget.id),
          backgroundColor: Theme.of(context).errorColor,
          foregroundColor: Colors.white,
          icon: Icons.delete,
          label: 'Delete',
        ),
      ]),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF9E9E9E),
        ),
        onPressed: () {
          Navigator.of(context)
              .pushNamed(appRoutes["chat"] ?? "/error", arguments: {
            "chatId": widget.id,
            "chatName": widget.name,
            "websocketId": widget.websocketId,
            "members": widget.members,
            "image": widget.image
          });
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 16.0, right: 16.0),
          child: Row(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(right: 16.0),
                child: widget.image.isEmpty
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
              ),
              Flexible(
                fit: FlexFit.tight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            widget.name,
                            style: Theme.of(context).textTheme.labelMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Visibility(
                          visible: widget.newMessage,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: SizedBox(
                              width: 10,
                              height: 10,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(100)),
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      widget.lastMessage,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: widget.newMessage
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: widget.newMessage
                            ? Colors.black
                            : const Color.fromRGBO(128, 128, 128, 1),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
