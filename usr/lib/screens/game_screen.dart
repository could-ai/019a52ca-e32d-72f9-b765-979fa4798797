import 'package:flutter/material.dart';
import 'package:couldai_user_app/data/landmarks.dart';
import 'package:couldai_user_app/models/landmark.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int _currentIndex = 0;
  int _score = 0;
  final TextEditingController _controller = TextEditingController();
  String _feedback = '';
  List<Landmark> _gameLandmarks = [];

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  void _startGame() {
    setState(() {
      _gameLandmarks = List.from(landmarks)..shuffle();
      _currentIndex = 0;
      _score = 0;
      _feedback = '';
      _controller.clear();
    });
  }

  void _checkAnswer() {
    final userAnswer = _controller.text.trim();
    if (userAnswer.toLowerCase() == _gameLandmarks[_currentIndex].name.toLowerCase()) {
      setState(() {
        _score++;
        _feedback = 'Correct!';
      });
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          if (_currentIndex < _gameLandmarks.length - 1) {
            _currentIndex++;
            _controller.clear();
            _feedback = '';
          } else {
            Navigator.pushReplacementNamed(context, '/win', arguments: _score);
          }
        });
      });
    } else {
      setState(() {
        _feedback = 'Wrong! Try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_gameLandmarks.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final currentLandmark = _gameLandmarks[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Landmark ${_currentIndex + 1} of ${_gameLandmarks.length}'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text('Score: $_score', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 20),
              Image.asset(
                currentLandmark.imagePath,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error, size: 100);
                },
              ),
              const SizedBox(height: 20),
              Text(
                currentLandmark.question,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Your Answer',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _checkAnswer,
                child: const Text('Submit'),
              ),
              const SizedBox(height: 20),
              Text(_feedback, style: const TextStyle(color: Colors.red, fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
