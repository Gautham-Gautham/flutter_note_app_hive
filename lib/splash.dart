import 'package:flutter/material.dart';
import 'package:flutter_note_app_hive/Features/Authentication/Screens/login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Features/Home/Screens/note_list_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  static const img = "asset/ic_launcher.png";

  Future<void> keepLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final ligin = prefs.getString("uid") ?? "";
    if (ligin != "") {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const NoteListScreen()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 2),
      () {
        keepLogin();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(img),
      ),
    );
  }
}
