import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../Core/Utils/failure.dart';
import '../../../Core/Utils/firebase_providers.dart';
import '../../../Core/Utils/type_def.dart';

final authRepository = Provider((ref) => AuthRepository(
    googleSignIn: ref.read(googleSigninProvider),
    auth: ref.read(authProvider)));

class AuthRepository {
  // final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;
  final FirebaseAuth _auth;
  AuthRepository({
    required GoogleSignIn googleSignIn,
    required FirebaseAuth auth,
  })  : _googleSignIn = googleSignIn,
        _auth = auth;

  // CollectionReference get _users => _firestore.collection("user");

  FutureEither<String> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser?.authentication;
      final Credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
      UserCredential userCredential =
          await _auth.signInWithCredential(Credential);
      if (kDebugMode) {
        print(userCredential.user?.email ?? "");
        print(userCredential.user?.phoneNumber ?? "");
        print(userCredential.user?.displayName ?? "");
      }

      return right("Success");
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
