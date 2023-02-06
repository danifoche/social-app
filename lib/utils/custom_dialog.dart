import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';

class CustomDialog {
  //? Mostra un dialog con bottone si e no
  Future<dynamic> showYesNoDialog(BuildContext context, Widget title,
      Widget content, VoidCallback onPressedYes, VoidCallback onPressedNo) {
    return showPlatformDialog(
      context: context,
      builder: (_) => BasicDialogAlert(
        title: title,
        content: content,
        actions: <Widget>[
          BasicDialogAction(
            title: const Text("No"),
            onPressed: onPressedNo,
          ),
          BasicDialogAction(
            title: const Text("Yes"),
            onPressed: onPressedYes,
          ),
        ],
      ),
    );
  }
}
