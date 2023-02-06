import 'package:flutter/material.dart';

class ShowSnackBar {

  //? Mostra uno snackbar di successo
  dynamic success(BuildContext context, String message) {
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            fontSize: Theme.of(context).textTheme.labelMedium!.fontSize,
            fontWeight: Theme.of(context).textTheme.labelMedium!.fontWeight,      
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  //? Mostra uno snackbar di errore
  dynamic error(BuildContext context, String message) {
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            fontSize: Theme.of(context).textTheme.labelMedium!.fontSize,
            fontWeight: Theme.of(context).textTheme.labelMedium!.fontWeight,      
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Theme.of(context).errorColor,
      ),
    );
  }
}