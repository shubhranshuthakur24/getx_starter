import 'package:firebase_auth/firebase_auth.dart';

class AuthRemoteDataSource{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Login

  Future<UserCredential> login(String email, String password) async{
    return await _auth.signInWithEmailAndPassword(
      email:email,
      password: password,
    );
  }

  // Register

  Future<UserCredential> register(String email, String password) async{
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Current User
  User ? get currentUser => _auth.currentUser;
}




