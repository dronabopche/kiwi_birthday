import 'dart:async';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';
import 'package:flutter/services.dart';

void main() {
  runApp(const BirthdayApp());
}

class BirthdayApp extends StatelessWidget {
  const BirthdayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'For kiwi bacha',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.brown,
        fontFamily: 'DancingScript',
      ),
      home: const BirthdayPage(),
    );
  }
}

class BirthdayPage extends StatefulWidget {
  const BirthdayPage({super.key});

  @override
  State<BirthdayPage> createState() => _BirthdayPageState();
}

class _BirthdayPageState extends State<BirthdayPage>
    with SingleTickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  final DateTime _birthdayDate = DateTime(DateTime.now().year, 4, 26);
  late Timer _countdownTimer;

  // Memory game variables
  List<String> _cardValues = ['❤️', 'meow', '🎁', '🌸', '💌', '🎀', '💍', '🍫'];
  List<String> _gameCards = [];
  List<bool> _cardFlips = [];
  int? _selectedIndex;
  int _matchedPairs = 0;
  bool _gameWon = false;

  @override
  void initState() {
    super.initState();
    _updateCountdown();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 5));
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Initialize the game
    _initializeGame();

    // Update every second
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateCountdown();
    });
  }

  void _updateCountdown() {
    if (mounted) {
      setState(() {});
    }
  }

  void _initializeGame() {
    setState(() {
      _gameCards = [..._cardValues, ..._cardValues]..shuffle();
      _cardFlips = List<bool>.filled(_gameCards.length, false);
      _matchedPairs = 0;
      _gameWon = false;
      _selectedIndex = null;
    });
  }

  void _handleCardClick(int index) {
    if (_cardFlips[index] ||
        _gameWon ||
        (_selectedIndex != null && _selectedIndex == index)) return;

    setState(() {
      _cardFlips[index] = true;

      if (_selectedIndex == null) {
        _selectedIndex = index;
      } else {
        if (_gameCards[_selectedIndex!] == _gameCards[index]) {
          // Match found
          _matchedPairs++;
          if (_matchedPairs == _cardValues.length) {
            _gameWon = true;
            _confettiController.play();
          }
          _selectedIndex = null;
        } else {
          // No match
          Future.delayed(const Duration(milliseconds: 800), () {
            if (mounted) {
              setState(() {
                _cardFlips[_selectedIndex!] = false;
                _cardFlips[index] = false;
                _selectedIndex = null;
              });
            }
          });
        }
      }
    });
  }

  String _getCountdown() {
    final now = DateTime.now();
    final difference = _birthdayDate.difference(now);

    if (difference.isNegative) {
      return "It's your special day! 🎉";
    }

    return '${difference.inDays}d ${difference.inHours.remainder(24)}h ${difference.inMinutes.remainder(60)}m ${difference.inSeconds.remainder(60)}s';
  }

  void _celebrate() {
    _confettiController.play();
    _animationController.reset();
    _animationController.forward();

    // Vibrate if on mobile
    HapticFeedback.vibrate();

    // Show a dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.pink[50],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Happy Birthday Vaishanvii!',
            style: TextStyle(fontFamily: 'DancingScript', fontSize: 28)),
        content: const Text(
            'You are the most amazing person in my life. I love you endlessly!',
            style: TextStyle(fontFamily: 'DancingScript', fontSize: 20)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close',
                style: TextStyle(fontFamily: 'DancingScript', fontSize: 18)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _animationController.dispose();
    _countdownTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: SweepGradient(
            center: Alignment.center,
            colors: [
              Colors.pink.shade100,
              Colors.orange.shade100,
              Colors.yellow.shade100,
              Color(0xFFE1BEE7), // Equivalent to Colors.purple.shade100
              Color(0xFFBBDEFB), // Equivalent to Colors.blue[100]
            ],
            stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
            transform: GradientRotation(pi / 4),
          ),
        ),
        child: Stack(
          children: [
            // Background elements
            Positioned(
              top: 50,
              right: 30,
              child: Transform.rotate(
                angle: -0.2,
                child: const Icon(Icons.favorite, size: 60, color: Colors.pink),
              ),
            ),
            Positioned(
              bottom: 80,
              left: 40,
              child: Transform.rotate(
                angle: 0.3,
                child:
                    Icon(Icons.cake, size: 70, color: Colors.purple.shade100),
              ),
            ),
            Positioned(
              top: 120,
              left: 20,
              child: Transform.rotate(
                angle: 0.1,
                child: const Icon(Icons.star, size: 50, color: Colors.amber),
              ),
            ),

            // Confetti
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirection: pi / 2,
                maxBlastForce: 5,
                minBlastForce: 2,
                emissionFrequency: 0.05,
                numberOfParticles: 20,
                gravity: 0.2,
                colors: const [
                  Color.fromARGB(255, 177, 84, 50),
                  Color(0xFFE1BEE7),
                  Color(0xFFBBDEFB),
                  Colors.amber,
                ],
              ),
            ),

            SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),

                  // Title
                  const Text(
                    'For My Beautiful Vaishnaviii',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 177, 84, 50),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Countdown
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 0, 0, 0)
                              .withOpacity(0.2),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Countdown to Your Birthday Day',
                          style: TextStyle(fontSize: 20),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _getCountdown(),
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 79, 14, 90),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Memory Game
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 88, 53, 19)
                              .withOpacity(0.2),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Memory Game - Find All Pairs',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 5),
                        if (_gameWon)
                          Column(
                            children: [
                              const Text(
                                'You Won! Now u can kiss Cherry 🎉',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Color.fromARGB(255, 177, 84, 50),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: _initializeGame,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.brown,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: const Text('Play Again'),
                              ),
                            ],
                          )
                        else
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 1,
                            ),
                            itemCount: _gameCards.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () => _handleCardClick(index),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                  decoration: BoxDecoration(
                                    color: _cardFlips[index]
                                        ? Colors.white
                                        : const Color.fromARGB(
                                            255, 202, 133, 93),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color.fromARGB(
                                                255, 128, 79, 16)
                                            .withOpacity(0.3),
                                        blurRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: _cardFlips[index]
                                        ? Text(
                                            _gameCards[index],
                                            style:
                                                const TextStyle(fontSize: 40),
                                          )
                                        : const Icon(Icons.cake,
                                            size: 24, color: Colors.white),
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Celebrate Button
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: ElevatedButton(
                      onPressed: _celebrate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5,
                      ),
                      child: const Text(
                        'Click me mommy!',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Romantic Message
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(184, 226, 223, 217),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Column(
                      children: [
                        Text(
                          'To The Love of My Life',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 85, 11, 114),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Every moment with you Vaishnavii is special. On your birthday, '
                          'I want you to know how much you mean to me. You make '
                          'my cutest bf obv i am cute, Ur daddy '
                          'beautiful bacha. Happy Birthday my bacha!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
