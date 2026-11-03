import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupRepo {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = userCredential.user;

    if (user == null) {
      throw Exception('Firebase did not return a user.');
    }

    await _firestore.collection('users').doc(user.uid).set({
      'username': username,
      'email': email,
      'balance': 0.0,
      'currency': 'JOD',
      'createdAt': FieldValue.serverTimestamp(),
    });

    await _auth.signOut();
  }
}