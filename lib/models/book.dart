import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  final String id;
  final String bookId; // Unique book identifier
  final String title;
  final String author;
  final String condition;
  final String swapFor;
  final String coverImageUrl; // Firebase Storage URL
  final String ownerId;
  final String ownerEmail;
  final String status;
  final bool isAvailable; // Whether book can be swapped
  final DateTime? createdAt;

  Book({
    required this.id,
    required this.bookId,
    required this.title,
    required this.author,
    required this.condition,
    required this.swapFor,
    required this.coverImageUrl,
    required this.ownerId,
    required this.ownerEmail,
    required this.status,
    required this.isAvailable,
    this.createdAt,
  });

  factory Book.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return Book(
      id: doc.id,
      bookId: d['bookId'] ?? doc.id, // Use doc.id as fallback
      title: d['title'] ?? '',
      author: d['author'] ?? '',
      condition: d['condition'] ?? 'New',
      swapFor: d['swapFor'] ?? '',
      coverImageUrl: d['coverImageUrl'] ?? d['imageBase64'] ?? '', // Support both old and new
      ownerId: d['ownerId'] ?? '',
      ownerEmail: d['ownerEmail'] ?? '',
      status: d['status'] ?? 'Available', // Default to Available
      isAvailable: d['isAvailable'] ?? true, // Default to available
      createdAt: d['createdAt']?.toDate(),
    );
  }
}