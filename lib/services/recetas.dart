import 'package:cloud_firestore/cloud_firestore.dart';

class ServiciosRecetas {
  //---------------- get ------------------
  final CollectionReference recetas =
      FirebaseFirestore.instance.collection('receta');

  //---------------- create ----------------
  Future<void> addReceta(String titulo, String descripcion, bool importante) {
    return recetas.add({
      'titulo': titulo,
      'descripcion': descripcion,
      'importante': importante,
      'timestamp': Timestamp.now(),
    });
  }

  //---------------- read ------------------
  Stream<QuerySnapshot> getRecetasStream() {
    return recetas.orderBy('timestamp', descending: true).snapshots();
  }

  //---------------- update ----------------
  Future<void> updateReceta(
      String docID, String newDescripcion, String titulo) {
    return recetas.doc(docID).update({
      'titulo': titulo,
      'descripcion': newDescripcion,
      'timestamp': Timestamp.now(),
    });
  }

  //---------------- delete-----------------
  Future<void> deleteReceta(String docID) {
    return recetas.doc(docID).delete();
  }
}
