import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Colecciones
  final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference _entriesCollection = FirebaseFirestore.instance.collection('entries');
  
  // Obtener usuario actual
  User? get currentUser => _auth.currentUser;
  
  // Crear o actualizar perfil de usuario
  Future<void> updateUserProfile({
    required String displayName,
    String? bio,
    String? profileImageUrl,
  }) async {
    if (currentUser == null) return;
    
    await _usersCollection.doc(currentUser!.uid).set({
      'uid': currentUser!.uid,
      'email': currentUser!.email,
      'displayName': displayName,
      'bio': bio ?? '',
      'profileImageUrl': profileImageUrl ?? '',
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    
    // Actualizar también el displayName en Auth
    await currentUser!.updateDisplayName(displayName);
  }
  
  // Obtener perfil de usuario
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    DocumentSnapshot doc = await _usersCollection.doc(userId).get();
    if (doc.exists) {
      return doc.data() as Map<String, dynamic>;
    }
    return null;
  }
  
  // Guardar una entrada (carta, diario, etc.)
  Future<String> saveEntry({
    required String title,
    required String content,
    required String entryType,
    String? prompt,
    String? mood,
    String? pokemon,
    bool isPublic = false,
    String? imageUrl,
    DateTime? scheduledDate,
  }) async {
    if (currentUser == null) throw Exception('Usuario no autenticado');
    
    // Generar ID único para la entrada
    String entryId = const Uuid().v4();
    
    await _entriesCollection.doc(entryId).set({
      'id': entryId,
      'userId': currentUser!.uid,
      'title': title,
      'content': content,
      'entryType': entryType,
      'prompt': prompt ?? '',
      'mood': mood ?? '',
      'pokemon': pokemon ?? '',
      'isPublic': isPublic,
      'imageUrl': imageUrl ?? '',
      'scheduledDate': scheduledDate,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    
    return entryId;
  }
  
  // Obtener entradas del usuario actual
  Stream<QuerySnapshot> getUserEntries() {
    if (currentUser == null) throw Exception('Usuario no autenticado');
    
    return _entriesCollection
        .where('userId', isEqualTo: currentUser!.uid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
  
  // Obtener entradas públicas
  Stream<QuerySnapshot> getPublicEntries() {
    return _entriesCollection
        .where('isPublic', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
  
  // Obtener una entrada específica
  Future<Map<String, dynamic>?> getEntry(String entryId) async {
    DocumentSnapshot doc = await _entriesCollection.doc(entryId).get();
    if (doc.exists) {
      return doc.data() as Map<String, dynamic>;
    }
    return null;
  }
  
  // Subir imagen y obtener URL
  Future<String> uploadImage(File imageFile, String folder) async {
    if (currentUser == null) throw Exception('Usuario no autenticado');
    
    String fileName = '${currentUser!.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';
    Reference ref = _storage.ref().child('$folder/$fileName');
    
    UploadTask uploadTask = ref.putFile(imageFile);
    TaskSnapshot taskSnapshot = await uploadTask;
    
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }
  
  // Eliminar una entrada
  Future<void> deleteEntry(String entryId) async {
    if (currentUser == null) throw Exception('Usuario no autenticado');
    
    // Verificar que la entrada pertenezca al usuario actual
    DocumentSnapshot doc = await _entriesCollection.doc(entryId).get();
    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      if (data['userId'] == currentUser!.uid) {
        await _entriesCollection.doc(entryId).delete();
      } else {
        throw Exception('No tienes permiso para eliminar esta entrada');
      }
    }
  }
}