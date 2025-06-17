import 'package:cloud_firestore/cloud_firestore.dart';

class Entry {
  final String id;
  final String userId;
  final String title;
  final String content;
  final String entryType;
  final String prompt;
  final String mood;
  final String pokemon;
  final bool isPublic;
  final String imageUrl;
  final DateTime? scheduledDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  Entry({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.entryType,
    this.prompt = '',
    this.mood = '',
    this.pokemon = '',
    this.isPublic = false,
    this.imageUrl = '',
    this.scheduledDate,
    required this.createdAt,
    required this.updatedAt,
  });

  // Crear desde un documento de Firestore
  factory Entry.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    return Entry(
      id: doc.id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      entryType: data['entryType'] ?? '',
      prompt: data['prompt'] ?? '',
      mood: data['mood'] ?? '',
      pokemon: data['pokemon'] ?? '',
      isPublic: data['isPublic'] ?? false,
      imageUrl: data['imageUrl'] ?? '',
      scheduledDate: data['scheduledDate'] != null 
          ? (data['scheduledDate'] as Timestamp).toDate() 
          : null,
      createdAt: data['createdAt'] != null 
          ? (data['createdAt'] as Timestamp).toDate() 
          : DateTime.now(),
      updatedAt: data['updatedAt'] != null 
          ? (data['updatedAt'] as Timestamp).toDate() 
          : DateTime.now(),
    );
  }

  // Convertir a mapa para Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'content': content,
      'entryType': entryType,
      'prompt': prompt,
      'mood': mood,
      'pokemon': pokemon,
      'isPublic': isPublic,
      'imageUrl': imageUrl,
      'scheduledDate': scheduledDate,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}