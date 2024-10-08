import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final authProvider = Provider((ref) => FirebaseAuth.instance);
final googleSigninProvider = Provider((ref) => GoogleSignIn());
