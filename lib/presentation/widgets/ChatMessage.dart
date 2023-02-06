import 'package:flutter/material.dart';

class ChatMessage extends StatefulWidget {

  //? Messaggio
  final String message;

  //? Variabile che mi permette di sapere se sono io ad inviare il messaggio o meno
  final bool isMe;

  const ChatMessage({super.key, required this.message, required this.isMe});

  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
            top: 5.0,
            bottom: 5.0,
            left: widget.isMe ? 50.0 : 0,
            right: !widget.isMe ? 50.0 : 0),
        padding: const EdgeInsets.only(
            left: 20.0, top: 10.0, right: 20.0, bottom: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(10),
              topRight: const Radius.circular(10),
              bottomLeft: !widget.isMe
                  ? const Radius.circular(0)
                  : const Radius.circular(10),
              bottomRight: widget.isMe
                  ? const Radius.circular(0)
                  : const Radius.circular(10)),
          color: widget.isMe
              ? Theme.of(context).primaryColor
              : const Color(0xFFD6D6D6),
        ),
        child: Text(
          widget.message,
          style: TextStyle(
              color: widget.isMe ? Colors.white : Colors.black, fontSize: 18.0),
          overflow: TextOverflow.clip,
        ),
      ),
    );
  }
}
