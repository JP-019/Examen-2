import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('usuarios');

  // Registro con correo y contraseña
  Future<User?> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      // Añadir usuario a Firestore
      await userCollection.doc(user!.uid).set({
        'email': email,
        'createdAt': Timestamp.now(),
      });

      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Inicio de sesión con correo y contraseña
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Restablecer la contraseña
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  // Obtener perfil de usuario
  Future<DocumentSnapshot> getUserProfile(String uid) async {
    try {
      return await userCollection.doc(uid).get();
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
