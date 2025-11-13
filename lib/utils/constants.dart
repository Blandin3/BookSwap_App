import 'package:flutter/material.dart';

class AppConstants {
  // App Colors
  static const Color navy = Color(0xFF0A0A23);
  static const Color amber = Color(0xFFFFC107);
  
  // App Strings
  static const String appName = 'BookSwap';
  static const String appTagline = 'Swap Your Books With Other Students';
  
  // Validation Messages
  static const String emailRequired = 'Email is required';
  static const String passwordRequired = 'Password is required';
  static const String passwordTooShort = 'Password must be at least 6 characters';
  static const String passwordsDoNotMatch = 'Passwords do not match';
  
  // Success Messages
  static const String accountCreated = 'Account created! Please check your email to verify your account.';
  static const String emailVerified = 'Email verified successfully! Welcome to BookSwap!';
  static const String bookPosted = 'Book posted successfully!';
  static const String bookUpdated = 'Book updated successfully!';
  static const String bookDeleted = 'Book deleted successfully';
  
  // Error Messages
  static const String networkError = 'Network error. Check your internet connection.';
  static const String genericError = 'Something went wrong. Please try again.';
  static const String imageUploadFailed = 'Image upload failed';
  
  // Book Conditions
  static const List<String> bookConditions = [
    'New',
    'Like New', 
    'Good',
    'Used'
  ];
  
  // Swap Statuses
  static const String statusAvailable = 'Available';
  static const String statusPending = 'Pending';
  static const String statusAccepted = 'Accepted';
  static const String statusRejected = 'Rejected';
  static const String statusCompleted = 'Completed';
  static const String statusSwapped = 'Swapped';
}