import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_bloc/logic/bloc/user_bloc.dart';
import 'package:social_app_bloc/presentation/widgets/AddChatUserItem.dart';
import 'package:social_app_bloc/utils/custom_snackbar.dart';

class AddChat extends StatefulWidget {

  final ValueSetter changeScreen;

  const AddChat({super.key, required this.changeScreen});

  @override
  State<AddChat> createState() => _AddChatState();
}

class _AddChatState extends State<AddChat> {

  final ShowSnackBar _customSnackbar = ShowSnackBar();
  final TextEditingController _searchController = TextEditingController();

  //? Funzione utilizzata per sbiancare il campo per cercare gli utenti
  void clearSearchInput() {
    _searchController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
          padding: const EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
          child: Column(
            children: <Widget>[
              Center(
                child: Text(
                  'Add user',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    BlocProvider.of<UserBloc>(context)
                        .add(UserSearch(searchPattern: value));
                  },
                  cursorColor: const Color(0xFF757575),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                    border: Theme.of(context).inputDecorationTheme.border,
                    hintText: 'Search user...',
                    hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
                    enabledBorder:
                        Theme.of(context).inputDecorationTheme.enabledBorder,
                    focusedBorder:
                        Theme.of(context).inputDecorationTheme.focusedBorder,
                  ),
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
              BlocConsumer<UserBloc, UserState>(
                listener: (context, state) {
                  if(state is UserNotificationSuccess) {
                    _customSnackbar.success(context, state.message);

                    //? Torno nella pagina delle chat
                    widget.changeScreen(0);

                  } else if(state is UserNotificationError) {
                    _customSnackbar.error(context, state.message);
                  }
                },
                builder: (context, state) {
                  if (state is UserInitial || state is UserEmptyString) {
                    return Expanded(
                      child: Center(
                        child: Text(
                          "Search a user to start a new chat",
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                    );
                  } else if (state is UserError) {
                    return Expanded(
                      child: Center(
                        child: Text(
                          state.message,
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                    );
                  } else if (state is UserLoadedList) {
                    return Flexible(
                      flex: 1,
                      child: ListView.builder(
                          itemCount: state.userList?.length ?? 0,
                          itemBuilder: (context, index) {
                            return AddChatUserItem(
                              username: state.userList?[index].username ?? "",
                              userId: state.userList?[index].userId ?? 0,
                              image: state.userList?[index].image ?? "",
                              clearSearchInputCallBack: clearSearchInput,
                            );
                          }),
                    );
                  } else if (state is UserLoading) {
                    return const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  return const Text("An error has occoured");
                },
              )
            ],
          )),
    );
  }
}
