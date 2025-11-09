
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'providers/book_provider.dart';
import 'providers/chat_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/swap_provider.dart';
import 'widgets/notification_badge.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/auth/verify_email_screen.dart';

import 'screens/home/browse_listings.dart';
import 'screens/home/my_listings.dart';
import 'screens/chat/threads_screen.dart';
import 'screens/settings/settings_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const BookSwapApp());
}

class BookSwapApp extends StatelessWidget {
  const BookSwapApp({super.key});

  // Blue Color Scheme
  static const _navy = Color(0xFF1A237E);        // Deep Navy
  static const _skyBlue = Color(0xFF42A5F5);     // Sky Blue  
  static const _mutedTeal = Color(0xFF26A69A);   // Muted Teal
  static const _lightBlue = Color(0xFFE3F2FD);   // Light Blue Background

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => BookProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => SwapProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BookSwap',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: _skyBlue,
            primary: _skyBlue,
            secondary: _mutedTeal,
            surface: _lightBlue,
          ),
          scaffoldBackgroundColor: _lightBlue,
          appBarTheme: const AppBarTheme(
            backgroundColor: _navy,
            foregroundColor: Colors.white,
            elevation: 2,
            shadowColor: Colors.black26,
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: _navy,
            selectedItemColor: _skyBlue,
            unselectedItemColor: Colors.white60,
            type: BottomNavigationBarType.fixed,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: _skyBlue,
              foregroundColor: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),

          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _skyBlue.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _skyBlue, width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        home: const _AuthGate(),
        routes: {
          LoginScreen.route: (_) => const LoginScreen(),
          SignupScreen.route: (_) => const SignupScreen(),
        },
      ),
    );
  }
}

class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthService>();
    return StreamBuilder(
      stream: auth.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (!snapshot.hasData) return const LoginScreen();
        // Temporarily skip email verification
        return const MainNav();
      },
    );
  }
}

class MainNav extends StatefulWidget {
  const MainNav({super.key});

  @override
  State<MainNav> createState() => _MainNavState();
}

class _MainNavState extends State<MainNav> {
  int idx = 0;
  final pages = const [BrowseListings(), MyListings(), ThreadsScreen(), SettingsScreen()];

  @override
  Widget build(BuildContext context) {
    final notifications = context.watch<NotificationProvider>();
    
    return Scaffold(
      body: pages[idx],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: idx,
        onTap: (i) {
          setState(() => idx = i);
          if (i == 1) {
            notifications.markIncomingAsRead();
            notifications.markMyOffersAsRead();
          }
        },
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: NotificationBadge(
              count: notifications.totalUnread,
              child: const Icon(Icons.library_books),
            ),
            label: 'My Listings',
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: 'Chats'),
          const BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
