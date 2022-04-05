import 'package:firebase_auth/firebase_auth.dart';

class _AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signInWithEmailAndPassword({required String email,required String password}) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<String> createUserWithEmailAndPassword({required String email,required String password}) async {
    UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    return credential.user!.uid;
  }

  Stream<User?> authStatusChanges() {
    return _auth.authStateChanges();
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}

_AuthService authService = _AuthService();
