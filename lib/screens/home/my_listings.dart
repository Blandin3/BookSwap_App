import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/book_provider.dart';
import '../../providers/swap_provider.dart';
import '../../providers/notification_provider.dart';
import '../../models/book.dart';
import '../../models/swap.dart';
import '../../widgets/book_card.dart';
import '../../widgets/notification_badge.dart';
import 'post_book_screen.dart';

class MyListings extends StatelessWidget {
  const MyListings({super.key});

  void _confirmDelete(BuildContext context, BookProvider prov, Book book) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning, color: Color(0xFF607D8B)),
            SizedBox(width: 8),
            Text('Delete Book'),
          ],
        ),
        content: Text(
          'Are you sure you want to delete "${book.title}"? This action cannot be undone.',
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF42A5F5)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              prov.delete(book.id);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Book deleted successfully'),
                  backgroundColor: Color(0xFF607D8B),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF607D8B),
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notifications = context.watch<NotificationProvider>();
    
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Listings'),
          bottom: TabBar(
            tabs: [
              const Tab(text: 'My Books'),
              Tab(
                child: NotificationBadge(
                  count: notifications.unreadMyOffers,
                  child: const Text('My Offers'),
                ),
              ),
              Tab(
                child: NotificationBadge(
                  count: notifications.unreadIncomingOffers,
                  child: const Text('Incoming'),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildMyBooks(context),
            _buildMyOffers(context),
            _buildIncomingOffers(context),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PostBookScreen())),
          label: const Text('Post'),
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildMyBooks(BuildContext context) {
    final prov = context.watch<BookProvider>();
    return prov.mine.isEmpty
        ? const Center(child: Text('You have not posted any books yet'))
        : ListView.builder(
            itemCount: prov.mine.length,
            itemBuilder: (c, i) {
              final b = prov.mine[i];
              return BookCard(
                book: b,
                ownerActions: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Color(0xFF42A5F5)),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => PostBookScreen(editing: b)),
                      ),
                      tooltip: 'Edit Book',
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Color(0xFF607D8B)),
                      onPressed: () => _confirmDelete(context, prov, b),
                      tooltip: 'Delete Book',
                    ),
                  ],
                ),
              );
            },
          );
  }

  Widget _buildMyOffers(BuildContext context) {
    final swapProvider = context.watch<SwapProvider>();
    final offers = swapProvider.myOffers;
    
    if (offers.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.send, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No offers sent yet', style: TextStyle(fontSize: 18, color: Colors.grey)),
          ],
        ),
      );
    }
    
    return ListView.builder(
      itemCount: offers.length,
      itemBuilder: (context, i) {
        final swap = offers[i];
        return _buildSwapCard(context, swap, false);
      },
    );
  }

  Widget _buildIncomingOffers(BuildContext context) {
    final swapProvider = context.watch<SwapProvider>();
    final offers = swapProvider.incomingOffers;
    
    if (offers.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.swap_horiz, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No incoming offers', style: TextStyle(fontSize: 18, color: Colors.grey)),
          ],
        ),
      );
    }
    
    return ListView.builder(
      itemCount: offers.length,
      itemBuilder: (context, i) {
        final swap = offers[i];
        return _buildSwapCard(context, swap, true);
      },
    );
  }

  Widget _buildSwapCard(BuildContext context, Swap swap, bool isIncoming) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getSwapStatusColor(swap.status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    swap.status.displayName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  _formatDate(swap.createdAt),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              isIncoming ? 'Someone wants to swap with your book' : 'You requested to swap this book',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Book ID: ${swap.bookId}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            if (swap.status == SwapStatus.pending && isIncoming) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _acceptSwap(context, swap),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF26A69A),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Accept'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _rejectSwap(context, swap),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF607D8B),
                      ),
                      child: const Text('Reject'),
                    ),
                  ),
                ],
              ),
            ],
            if (swap.status == SwapStatus.accepted) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _completeSwap(context, swap),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF42A5F5),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Mark as Completed'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _acceptSwap(BuildContext context, Swap swap) async {
    try {
      await context.read<SwapProvider>().acceptSwap(swap.id, swap.bookId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Swap accepted successfully!'),
            backgroundColor: Color(0xFF26A69A),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _rejectSwap(BuildContext context, Swap swap) async {
    try {
      await context.read<SwapProvider>().rejectSwap(swap.id, swap.bookId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Swap rejected'),
            backgroundColor: Color(0xFF607D8B),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _completeSwap(BuildContext context, Swap swap) async {
    try {
      await context.read<SwapProvider>().completeSwap(swap.id, swap.bookId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Swap completed successfully!'),
            backgroundColor: Color(0xFF42A5F5),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }



  Color _getSwapStatusColor(SwapStatus status) {
    switch (status) {
      case SwapStatus.pending:
        return const Color(0xFFFF9800);
      case SwapStatus.accepted:
        return const Color(0xFF26A69A);
      case SwapStatus.rejected:
        return const Color(0xFF607D8B);
      case SwapStatus.completed:
        return const Color(0xFF42A5F5);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}