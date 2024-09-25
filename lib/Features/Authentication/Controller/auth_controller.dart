import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_note_app_hive/Core/Utils/snackbar_dialogs.dart';
import 'package:flutter_note_app_hive/Features/Home/Screens/note_list_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Repository/auth_repository.dart';

final authControllerProvider = NotifierProvider<AuthController, bool>(() {
  return AuthController();
});

class AuthController extends Notifier<bool> {
  AuthRepository _repository() {
    return ref.read(authRepository);
  }

  @override
  bool build() {
    // TODO: implement build
    return false;
  }

  signInWithGoogle({required BuildContext context}) async {
    state = true;
    var res = await _repository().signInWithGoogle();
    state = false;
    res.fold(
      (l) {
        print(
            "eeeeeeeeeeeeeeerrrrrrrrrrrrrrrrrroooooooooooooorrrrrrrreeeeeeeeeeeee");
        print(
            "eeeeeeeeeeeeeeerrrrrrrrrrrrrrrrrroooooooooooooorrrrrrrreeeeeeeeeeeee");
        print(
            "eeeeeeeeeeeeeeerrrrrrrrrrrrrrrrrroooooooooooooorrrrrrrreeeeeeeeeeeee");
        print(
            "eeeeeeeeeeeeeeerrrrrrrrrrrrrrrrrroooooooooooooorrrrrrrreeeeeeeeeeeee");
        print(
            "eeeeeeeeeeeeeeerrrrrrrrrrrrrrrrrroooooooooooooorrrrrrrreeeeeeeeeeeee");
        print(
            "eeeeeeeeeeeeeeerrrrrrrrrrrrrrrrrroooooooooooooorrrrrrrreeeeeeeeeeeee");
        print(
            "eeeeeeeeeeeeeeerrrrrrrrrrrrrrrrrroooooooooooooorrrrrrrreeeeeeeeeeeee");
        print(
            "eeeeeeeeeeeeeeerrrrrrrrrrrrrrrrrroooooooooooooorrrrrrrreeeeeeeeeeeee");
        print(l.message);
        showSnackBarDialogue(
            context: context, message: "Something Went Wrong", isError: true);
      },
      (r) async {
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString('uid', "loggedIn");

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const NoteListScreen(),
            ),
            (route) => false);
      },
    );
  }
}
