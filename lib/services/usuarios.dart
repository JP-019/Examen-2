import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference usuarios =
      FirebaseFirestore.instance.collection('usuario');

  // Registro con correo y contraseña
  Future<User?> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      // Crear documento del usuario en Firestore
      await usuarios.doc(user!.uid).set({
        'email': email,
        'createdAt': Timestamp.now(),
        'password': password,
      });

      return user;
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'email-already-in-use') {
          throw 'El correo electrónico ya está en uso. Por favor, usa otro correo.';
        } else if (e.code == 'invalid-email') {
          throw 'El correo electrónico no es válido.';
        } else if (e.code == 'weak-password') {
          throw 'La contraseña es demasiado débil.';
        }
      }
      print('Error en registro: ${e.toString()}');
      return null;
    }
  }

  // Inicio de sesión con correo y contraseña
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      return user;
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          throw 'No hay usuario con ese correo electrónico.';
        } else if (e.code == 'wrong-password') {
          throw 'Contraseña incorrecta.';
        } else if (e.code == 'invalid-email') {
          throw 'El correo electrónico no es válido.';
        }
      }
      print('Error en inicio de sesión: ${e.toString()}');
      return null;
    }
  }

  // Restablecer la contraseña
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(
          'Error al enviar email de restablecimiento de contraseña: ${e.toString()}');
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print('Error al cerrar sesión: ${e.toString()}');
    }
  }
}
