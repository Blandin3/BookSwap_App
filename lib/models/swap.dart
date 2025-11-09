import 'package:cloud_firestore/cloud_firestore.dart';

enum SwapStatus {
  pending('Pending'),
  accepted('Accepted'),
  rejected('Rejected'),
  completed('Completed');

  const SwapStatus(this.displayName);
  final String displayName;

  static SwapStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return SwapStatus.pending;
      case 'accepted':
        return SwapStatus.accepted;
      case 'rejected':
        return SwapStatus.rejected;
      case 'completed':
        return SwapStatus.completed;
      default:
        return SwapStatus.pending;
    }
  }
}

class Swap {
  final String id;
  final String bookId;
  final String senderId;
  final String receiverId;
  final SwapStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? completedAt;

  Swap({
    required this.id,
    required this.bookId,
    required this.senderId,
    required this.receiverId,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.completedAt,
  });

  factory Swap.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Swap(
      id: doc.id,
      bookId: data['bookId'] ?? '',
      senderId: data['senderId'] ?? '',
      receiverId: data['receiverId'] ?? '',
      status: SwapStatus.fromString(data['status'] ?? 'pending'),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      completedAt: (data['completedAt'] as Timestamp?)?.toDate(),
    );
  }
}