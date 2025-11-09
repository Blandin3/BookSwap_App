import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/book.dart';
import '../screens/chat/simple_chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback? onSwap;
  final Widget? ownerActions;
  final String? subtitle2;

  const BookCard({
    super.key,
    required this.book,
    this.onSwap,
    this.ownerActions,
    this.subtitle2,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book Cover
            Container(
              width: 80,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: book.coverImageUrl.isNotEmpty
                    ? _buildImage(book.coverImageUrl)
                    : Container(
                        width: 80,
                        height: 120,
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.menu_book,
                          size: 40,
                          color: Colors.amber,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 12),
            // Book Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'by ${book.author}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getConditionColor(book.condition),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      book.condition,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Posted ${DateFormat.yMMMd().format(DateTime.now())}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                  if (book.swapFor.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Swap for: ${book.swapFor}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: book.isAvailable ? const Color(0xFF26A69A) : const Color(0xFF607D8B),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        book.status,
                        style: TextStyle(
                          fontSize: 12,
                          color: book.isAvailable ? const Color(0xFF26A69A) : const Color(0xFF607D8B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Action Button
            if (ownerActions != null)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ownerActions!,
                ],
              )
            else if (onSwap != null)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: book.isAvailable ? onSwap : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      backgroundColor: book.isAvailable ? const Color(0xFF42A5F5) : const Color(0xFF607D8B),
                      foregroundColor: Colors.white,
                    ),
                    child: Text(book.isAvailable ? 'Request Swap' : book.status),
                  ),
                  const SizedBox(height: 4),
                  TextButton(
                    onPressed: () => _openChat(context, book),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF26A69A),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    ),
                    child: const Text('Chat', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String imageUrl) {
    return Image.network(
      imageUrl,
      width: 80,
      height: 120,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          width: 80,
          height: 120,
          color: Colors.grey[200],
          child: const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 80,
      height: 120,
      color: Colors.grey[300],
      child: const Icon(
        Icons.menu_book,
        size: 40,
        color: Color(0xFF42A5F5), // Sky Blue
      ),
    );
  }

  void _openChat(BuildContext context, Book book) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || currentUser.uid == book.ownerId) return;
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SimpleChatScreen(
          otherUserId: book.ownerId,
          otherUserEmail: book.ownerEmail,
        ),
      ),
    );
  }

  Color _getConditionColor(String condition) {
    switch (condition.toLowerCase()) {
      case 'new':
        return const Color(0xFF26A69A); // Muted Teal
      case 'like new':
        return const Color(0xFF42A5F5); // Sky Blue
      case 'good':
        return const Color(0xFF1A237E); // Navy
      case 'used':
        return const Color(0xFF607D8B); // Blue Grey
      default:
        return Colors.grey;
    }
  }
}