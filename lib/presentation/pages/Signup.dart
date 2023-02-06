import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_bloc/logic/cubit/authentication_cubit.dart';
import 'package:social_app_bloc/utils/custom_snackbar.dart';
import 'package:social_app_bloc/settings/app_settings.dart';
import 'package:social_app_bloc/settings/app_utils.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  //? Key del form
  final _formKey = GlobalKey<FormState>();

  //? Campo username
  String? username;

  //? Campo email
  String? email;

  //? Campo password
  String? password;

  //? Controller campo password
  TextEditingController passwordController = TextEditingController();

  //? Campo conferma password
  String? confirmPassword;

  //? Controller campo conferma password
  TextEditingController confirmPasswordController = TextEditingController();

  //? Istanza classe per mostrare le notifiche
  final ShowSnackBar _customSnackbar = ShowSnackBar();

  //? Messaggio di errore da mostrare in caso le password non fossero uguali
  String isPasswordValidErrorMessage = "Passwords doesn't match!";

  //? Funzione che valida il campo username
  String? validateUsernameField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the username';
    }

    return null;
  }

  //? Funzione che valida il campo username
  String? validateEmailField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the email';
    } else if (!isValidEmail(value)) {
      return 'The email address is not valid';
    }

    return null;
  }

  //? Funzione che valida il campo password
  String? validatePasswordField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the password';
    }

    return null;
  }

  //? Funzione che valida il campo conferma password
  String? validateConfirmPasswordField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the confirm password';
    }

    return null;
  }

  //? Funzione che controlla se le password sono uguali
  bool isPasswordValid() {
    if (passwordController.value != confirmPasswordController.value) {
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if (state is RegistrationError) {

          //? Se ho una map come risposta significa che ho piu messaggi di errore
          if(state.message is Map) {

            //? Ciclo ogni messaggio di errore e lo mostro all'utente tramite snackbars
            state.message.forEach((key, value) {
              _customSnackbar.error(context, value[0]);
            });

          } else {
            //? Mostra snackbar di errore
            _customSnackbar.error(context, state.message);
          }

        } else if (state is RegistrationSuccess) {
          //? Mostra snackbar di successo
          _customSnackbar.success(context, state.logInSuccess);

          Navigator.of(context).pushNamedAndRemoveUntil(
              appRoutes["home"] ?? "/error", (route) => false, arguments: {
                "from_route": appRoutes["signup"]
              });
        }
      },
      builder: (context, state) {

        if (state is AuthenticationInitial ||
            state is AuthenticationLoading ||
            state is RegistrationSuccess ||
            state is RegistrationError) {
          return Scaffold(
            body: SafeArea(
                child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Visibility(
                    visible: state is AuthenticationLoading ? true : false,
                    child: const CircularProgressIndicator()),
                Opacity(
                  opacity: state is AuthenticationLoading ? 0.5 : 1,
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Text(
                              'Sign Up',
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                          ),
                        ],
                      ),
                      Form(
                        key: _formKey,
                        child: Expanded(
                          child: ListView(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            children: <Widget>[
                              //? Campo username
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: TextFormField(
                                  validator: validateUsernameField,
                                  onSaved: (newValue) => username = newValue,
                                  cursorColor: Theme.of(context)
                                      .textSelectionTheme
                                      .cursorColor,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Theme.of(context)
                                        .inputDecorationTheme
                                        .fillColor,
                                    border: Theme.of(context)
                                        .inputDecorationTheme
                                        .border,
                                    hintText: 'Username',
                                    hintStyle: Theme.of(context)
                                        .inputDecorationTheme
                                        .hintStyle,
                                    enabledBorder: Theme.of(context)
                                        .inputDecorationTheme
                                        .enabledBorder,
                                    focusedBorder: Theme.of(context)
                                        .inputDecorationTheme
                                        .focusedBorder,
                                  ),
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ),
                              ),
                              //? Campo email
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: TextFormField(
                                  validator: validateEmailField,
                                  onSaved: (newValue) => email = newValue,
                                  cursorColor: Theme.of(context)
                                      .textSelectionTheme
                                      .cursorColor,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Theme.of(context)
                                        .inputDecorationTheme
                                        .fillColor,
                                    border: Theme.of(context)
                                        .inputDecorationTheme
                                        .border,
                                    hintText: 'Email',
                                    hintStyle: Theme.of(context)
                                        .inputDecorationTheme
                                        .hintStyle,
                                    enabledBorder: Theme.of(context)
                                        .inputDecorationTheme
                                        .enabledBorder,
                                    focusedBorder: Theme.of(context)
                                        .inputDecorationTheme
                                        .focusedBorder,
                                  ),
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ),
                              ),
                              //? Campo password
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: TextFormField(
                                  controller: passwordController,
                                  validator: validatePasswordField,
                                  onSaved: (newValue) => password = newValue,
                                  cursorColor: Theme.of(context)
                                      .textSelectionTheme
                                      .cursorColor,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Theme.of(context)
                                        .inputDecorationTheme
                                        .fillColor,
                                    border: Theme.of(context)
                                        .inputDecorationTheme
                                        .border,
                                    hintText: 'Password',
                                    hintStyle: Theme.of(context)
                                        .inputDecorationTheme
                                        .hintStyle,
                                    enabledBorder: Theme.of(context)
                                        .inputDecorationTheme
                                        .enabledBorder,
                                    focusedBorder: Theme.of(context)
                                        .inputDecorationTheme
                                        .focusedBorder,
                                  ),
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ),
                              ),
                              //? Campo conferma password
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: TextFormField(
                                  controller: confirmPasswordController,
                                  validator: validateConfirmPasswordField,
                                  onSaved: (newValue) =>
                                      confirmPassword = newValue,
                                  cursorColor: Theme.of(context)
                                      .textSelectionTheme
                                      .cursorColor,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Theme.of(context)
                                        .inputDecorationTheme
                                        .fillColor,
                                    border: Theme.of(context)
                                        .inputDecorationTheme
                                        .border,
                                    hintText: 'Confirm password',
                                    hintStyle: Theme.of(context)
                                        .inputDecorationTheme
                                        .hintStyle,
                                    enabledBorder: Theme.of(context)
                                        .inputDecorationTheme
                                        .enabledBorder,
                                    focusedBorder: Theme.of(context)
                                        .inputDecorationTheme
                                        .focusedBorder,
                                  ),
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ),
                              ),

                              //? Bottone di registrazione
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    textStyle:
                                        Theme.of(context).textTheme.labelMedium,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0),
                                  ),
                                  onPressed: () {
                                    //? Se tutti i campi del form sono validi
                                    if (_formKey.currentState!.validate()) {
                                      //? Se la password non e valida mostro messaggio di errore
                                      if (!isPasswordValid()) {
                                        //? Mostro messaggio di errore
                                        _customSnackbar.error(context,
                                            isPasswordValidErrorMessage);

                                        return;
                                      }

                                      //? Salvo tutti i campi del form
                                      _formKey.currentState!.save();

                                      //? Chiudo la tastiera
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();

                                      //? Registro l'utente
                                      BlocProvider.of<AuthenticationCubit>(
                                              context)
                                          .register({
                                        "username": username,
                                        "password": password,
                                        "email": email,
                                      });
                                    }
                                  },
                                  child: const Text('Sign Up'),
                                ),
                              ),
                              //? Link per andare alla pagina di registrazione
                              Center(
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                            appRoutes["login"] ?? "/error",
                                            (route) => false);
                                  },
                                  child: Text(
                                    style: TextStyle(
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .labelSmall!
                                          .fontSize,
                                      fontWeight: Theme.of(context)
                                          .textTheme
                                          .labelSmall!
                                          .fontWeight,
                                      color: const Color(0xFF5DB075),
                                    ),
                                    'Already registered? Log In!',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
          );
        } else {
          return const Text("An error has occoured!");
        }
      },
    );
  }
}
