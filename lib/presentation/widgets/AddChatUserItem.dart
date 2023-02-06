import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_bloc/logic/bloc/user_bloc.dart';

class AddChatUserItem extends StatefulWidget {
  //? Informazioni dell'utente
  //? Nome
  final String username;

  //? Id
  final int userId;

  //? Immagine profilo
  final String image;

  //? Callback per sbiancare il campo ricerca
  final VoidCallback clearSearchInputCallBack;

  const AddChatUserItem({
    super.key,
    required this.username,
    required this.userId,
    required this.image,
    required this.clearSearchInputCallBack,
  });

  @override
  State<AddChatUserItem> createState() => _AddChatUserItemState();
}

class _AddChatUserItemState extends State<AddChatUserItem> {

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFF9E9E9E),
      ),
      onPressed: () {
        BlocProvider.of<UserBloc>(context).add(UserCreateChat(username: widget.username));
        widget.clearSearchInputCallBack();
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0, bottom: 16.0, right: 16.0),
        child: Row(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: SizedBox(
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
                    Text(
                      widget.username,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
