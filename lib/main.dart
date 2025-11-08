import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const ShakeQuoteApp());

class ShakeQuoteApp extends StatefulWidget {
  const ShakeQuoteApp({super.key});

  @override
  State<ShakeQuoteApp> createState() => _ShakeQuoteAppState();
}

class _ShakeQuoteAppState extends State<ShakeQuoteApp>
    with SingleTickerProviderStateMixin {
  static const EventChannel _shakeChannel =
      EventChannel('com.example.yourapp/shakeStream');

  String _quote = "Shake your phone for motivation 💪";
  late AnimationController _controller;
  late Animation<double> _animation;

  final List<String> _quotes = [
    "Believe you can and you’re halfway there.",
    "Don’t watch the clock; do what it does. Keep going.",
    "Success doesn’t just find you. You have to go out and get it.",
    "Dream big. Work hard. Stay humble.",
    "Push yourself, because no one else is going to do it for you.",
  ];

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _listenToShakeEvents();
  }

  void _listenToShakeEvents() {
    _shakeChannel.receiveBroadcastStream().listen((event) {
      if (event == "onShakeDetected") {
        _showNewQuote();
      }
    });
  }

  void _showNewQuote() {
    setState(() {
      _quote = _quotes[Random().nextInt(_quotes.length)];
    });
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.deepPurple.shade100,
        body: Center(
          child: FadeTransition(
            opacity: _animation,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                _quote,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
