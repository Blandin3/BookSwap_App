import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firestore_service.dart';
import '../models/swap.dart';

class SwapProvider with ChangeNotifier {
  final _svc = FirestoreService.instance;
  final _auth = FirebaseAuth.instance;

  List<Swap> _myOffers = [];
  List<Swap> _incomingOffers = [];

  List<Swap> get myOffers => _myOffers;
  List<Swap> get incomingOffers => _incomingOffers;

  StreamSubscription? _myOffersSub;
  StreamSubscription? _incomingSub;

  SwapProvider() {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        _startListening();
      } else {
        _stopListening();
        _myOffers = [];
        _incomingOffers = [];
        notifyListeners();
      }
    });
  }

  void _startListening() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    _stopListening();

    // Listen to my swap offers (I sent)
    _myOffersSub = _svc.myOffers(uid).listen((snapshot) {
      _myOffers = snapshot.docs.map((doc) => Swap.fromDoc(doc)).toList();
      _myOffers.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      notifyListeners();
    });

    // Listen to incoming offers (sent to me)
    _incomingSub = _svc.incomingOffers(uid).listen((snapshot) {
      _incomingOffers = snapshot.docs.map((doc) => Swap.fromDoc(doc)).toList();
      _incomingOffers.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      notifyListeners();
    });
  }

  void _stopListening() {
    _myOffersSub?.cancel();
    _incomingSub?.cancel();
  }

  // Swap Actions
  Future<void> acceptSwap(String swapId, String bookId) async {
    await _svc.acceptSwap(swapId, bookId);
  }

  Future<void> rejectSwap(String swapId, String bookId) async {
    await _svc.rejectSwap(swapId, bookId);
  }

  Future<void> completeSwap(String swapId, String bookId) async {
    await _svc.completeSwap(swapId, bookId);
  }

  // Get swap by ID
  Swap? getSwapById(String swapId) {
    try {
      return [..._myOffers, ..._incomingOffers].firstWhere((swap) => swap.id == swapId);
    } catch (e) {
      return null;
    }
  }

  // Get swaps for a specific book
  List<Swap> getSwapsForBook(String bookId) {
    return [..._myOffers, ..._incomingOffers].where((swap) => swap.bookId == bookId).toList();
  }

  @override
  void dispose() {
    _stopListening();
    super.dispose();
  }
}