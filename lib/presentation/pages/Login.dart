import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_bloc/logic/cubit/authentication_cubit.dart';
import 'package:social_app_bloc/utils/custom_snackbar.dart';
import 'package:social_app_bloc/settings/app_settings.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //? Key del form
  final _formKey = GlobalKey<FormState>();

  //? Mostra o meno la password
  bool _hidePassword = true;

  //? Campo username
  String? username;

  //? Campo password
  String? password;

  //? Istanza classe per mostrare le notifiche
  final ShowSnackBar _customSnackbar = ShowSnackBar();

  //? Funzione che valida il campo username
  String? validateUsernameField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the username';
    }

    return null;
  }

  //? Funzione che valida il campo password
  String? validatePasswordField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the password';
    } else if (value.length < 8) {
      return 'Please enter at least 8 characters';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if (state is LoginError) {
          //? Mostra snackbar di errore
          _customSnackbar.error(context, state.message);
        } else if (state is LoginSuccess) {
          //? Mostra snackbar di successo
          _customSnackbar.success(context, state.logInSuccess);

          Navigator.of(context).pushNamedAndRemoveUntil(
              appRoutes["home"] ?? "/error", (route) => false, arguments: {
                "from_route": appRoutes["login"]
              });
        }
      },
      builder: (context, state) {
        if (state is AuthenticationInitial ||
            state is AuthenticationLoading ||
            state is LoginSuccess ||
            state is LoginError) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: Text(
                                'Log In',
                                style:
                                    Theme.of(context).textTheme.headlineLarge,
                              ),
                            ),
                          ],
                        ),
                        Form(
                          key: _formKey,
                          child: Expanded(
                            child: ListView(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              children: [
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

                                //? Campo password
                                Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: TextFormField(
                                    validator: validatePasswordField,
                                    onSaved: (newValue) => password = newValue,
                                    obscureText: _hidePassword,
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
                                      suffixIcon: TextButton(
                                        style: TextButton.styleFrom(
                                          foregroundColor: const Color.fromARGB(
                                              255, 0, 0, 0),
                                        ),
                                        onPressed: () {
                                          //? Mostra o meno la password
                                          setState(() {
                                            _hidePassword = !_hidePassword;
                                          });
                                        },
                                        child: Icon(
                                          Icons.remove_red_eye_outlined,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      focusedBorder: Theme.of(context)
                                          .inputDecorationTheme
                                          .focusedBorder,
                                    ),
                                    style:
                                        Theme.of(context).textTheme.labelMedium,
                                  ),
                                ),

                                //? Bottone di Log In
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .labelMedium,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16.0),
                                    ),
                                    onPressed: () {
                                      //? Se tutti i campi del form sono validi
                                      if (_formKey.currentState!.validate()) {
                                        //? Salvo tutti i campi del form
                                        _formKey.currentState!.save();

                                        //? Chiudo la tastiera
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();

                                        //? Faccio il login
                                        BlocProvider.of<AuthenticationCubit>(
                                                context)
                                            .logIn({
                                          "username": username,
                                          "password": password
                                        });
                                      }
                                    },
                                    child: const Text('Log In'),
                                  ),
                                ),

                                //? Link per recupero password
                                Center(
                                  child: TextButton(
                                    onPressed: null,
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
                                        'Forgot your password?'),
                                  ),
                                ),

                                //? Link per andare alla pagina di registrazione
                                Center(
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushNamedAndRemoveUntil(
                                              appRoutes["signup"] ?? "/error",
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
                                      'Register now?',
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
              ),
            ),
          );
        } else {
          return const Text("An error has occoured!");
        }
      },
    );
  }
}
