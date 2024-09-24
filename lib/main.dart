import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_note_app_hive/Features/Authentication/Screens/login.dart';
import 'package:flutter_note_app_hive/Features/Home/Screens/note_list_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:hive_flutter/adapters.dart';

import 'Core/app_export.dart';
import 'Models/note_model.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();

  // Register the adapter
  Hive.registerAdapter(NoteAdapter());

  await Hive.openBox<Note>('notes');
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Keep Note',
        theme:
            ThemeData(primarySwatch: Colors.blue, brightness: Brightness.dark),
        // home: NoteListScreen(),
        home: LoginScreen(),
      );
    });
  }
}
