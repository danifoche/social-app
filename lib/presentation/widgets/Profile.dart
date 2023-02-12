import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_bloc/logic/bloc/user_bloc.dart';
import 'package:social_app_bloc/logic/cubit/authentication_cubit.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            padding: const EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
            width: double.infinity,
            height: 210,
            child: SafeArea(
              child: BlocConsumer<UserBloc, UserState>(
                listener: (context, state) {},
                builder: (context, state) {
                  if (state is UserInitial) {
                    BlocProvider.of<UserBloc>(context).add(UserGetInfo());
                  } else if (state is UserLoading) {
                    return const Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (state is UserProfileLoaded) {
                    return Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.topCenter,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            //? Widget usato solamente per alineare correttamente i bottoni
                            Visibility(
                              maintainState: true,
                              maintainAnimation: true,
                              maintainSize: true,
                              visible: false,
                              child: IconButton(
                                icon: const Icon(Icons.logout),
                                color: Colors.white,
                                iconSize: 30,
                                onPressed: () {
                                  null;
                                },
                              ),
                            ),
                            Text(
                              'Profile',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .fontSize,
                                fontWeight: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .fontWeight,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.logout),
                              color: Colors.white,
                              iconSize: 30,
                              onPressed: () => BlocProvider.of<AuthenticationCubit>(context).logout(),
                            ),
                          ],
                        ),
                        Positioned(
                          top: 60,
                          child: SizedBox(
                            width: 150,
                            height: 150,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(100)),
                                color: const Color(0xFFEEEEEE),
                                border: Border.all(
                                    color: const Color(0xFFEEEEEE), width: 4.0),
                                image: DecorationImage(
                                  fit: BoxFit.contain,
                                  image: MemoryImage(
                                      base64Decode(state.user.image ?? "")),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 220,
                          child: Column(
                            children: <Widget>[
                              Text(
                                state.user.username ?? "",
                                style: Theme.of(context).textTheme.labelLarge,
                              )
                            ],
                          ),
                        )
                      ],
                    );
                  } else if (state is UserError) {
                    return Scaffold(
                      body: Center(
                        child: Text(
                          state.message,
                          style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .fontSize,
                              fontWeight: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .fontWeight,
                              color: Theme.of(context).errorColor),
                        ),
                      ),
                    );
                  }

                  return const Scaffold(
                    body: Center(
                      child: Text("An error has occoured!"),
                    ),
                  );
                },
              ),
            ))
      ],
    );
  }
}
