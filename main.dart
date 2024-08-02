import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'admin_page.dart';
import 'category.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Love Messages',
      theme: _isDarkMode ? _darkTheme : _lightTheme,
      home: MyHomePage(
        toggleTheme: _toggleTheme,
        isDarkMode: _isDarkMode,
      ),
    );
  }

  ThemeData get _lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: Colors.pink,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.pink,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.pink,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, backgroundColor: Colors.pink,
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.black),
        bodyMedium: TextStyle(color: Colors.black),
      ),
    );
  }

  ThemeData get _darkTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.pink,
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: Colors.pink,
      scaffoldBackgroundColor: const Color(0xFF2C3E50),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF2C3E50),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF2C3E50),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, backgroundColor: Colors.pink,
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white70),
        bodyMedium: TextStyle(color: Colors.white),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.toggleTheme, required this.isDarkMode});

  final VoidCallback toggleTheme;
  final bool isDarkMode;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _tapCount = 0;
  DateTime? _lastTapTime;

  void _handleTap() {
    final now = DateTime.now();
    if (_lastTapTime == null || now.difference(_lastTapTime!) > const Duration(seconds: 1)) {
      _tapCount = 0; // Reset tap count if too much time has passed
    }

    _tapCount++;
    _lastTapTime = now;

    if (_tapCount >= 3) {
      _showCodeDialog(context);
      _tapCount = 0; // Reset tap count after successful admin access
    }
  }

  Future<void> _showCodeDialog(BuildContext context) async {
    final code = await _showCodeInputDialog(context);

    if (code == 'gx000') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AdminPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid code')),
      );
    }
  }

  Future<String?> _showCodeInputDialog(BuildContext context) {
    final TextEditingController _codeController = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Admin Code'),
          content: TextField(
            controller: _codeController,
            decoration: const InputDecoration(
              labelText: 'Code',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.text,
            obscureText: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(_codeController.text);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Love Messages', style: TextStyle(color: Colors.white70)),
          actions: [
            IconButton(
              icon: Icon(widget.isDarkMode ? Icons.brightness_7 : Icons.brightness_6),
              onPressed: widget.toggleTheme,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            children: const [
              CategoryCard(title: 'good-morning', imagePath: 'assets/images/good_morning.png'),
              CategoryCard(title: 'good-night', imagePath: 'assets/images/good_night.png'),
              CategoryCard(title: 'break-up', imagePath: 'assets/images/break_up.png'),
              CategoryCard(title: 'sad', imagePath: 'assets/images/sad.png'),
              CategoryCard(title: 'sorry', imagePath: 'assets/images/sorry.png'),
              CategoryCard(title: 'birthday', imagePath: 'assets/images/birthday.png'),
              CategoryCard(title: 'for-him', imagePath: 'assets/images/for_him.png'),
              CategoryCard(title: 'for-her', imagePath: 'assets/images/for_her.png'),
              CategoryCard(title: 'love', imagePath: 'assets/images/love.png'),
              CategoryCard(title: 'friendship', imagePath: 'assets/images/friendship.png'),
              CategoryCard(title: 'happiness', imagePath: 'assets/images/happiness.png'),
              CategoryCard(title: 'life', imagePath: 'assets/images/life.png'),
            ],
          ),
        ),
      ),
    );
  }
}
