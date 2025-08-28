import 'package:flutter/material.dart';
import 'dart:async';

class EggTimerMain extends StatefulWidget {
  const EggTimerMain({super.key});

  @override
  State<EggTimerMain> createState() => _EggTimerMainState();
}

class _EggTimerMainState extends State<EggTimerMain> {
  int _selectedHardness = 0;
  //final is the same as const but is set once it is initialized rather than on compilation like const
  final List<String> _hardness = ["Soft", "Medium", "Hard"];
  static const List<int> _boilTimes = [360, 480, 720];
  int _boilTime = _boilTimes[0];
  bool _isRunning = false;
  int _seconds = 360;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  //using this to get the colour of the timer and buttons
  Color _getProgressColor() {
    switch (_selectedHardness) {
      case 0:
        return const Color.fromRGBO(255, 152, 0, 1); // Soft
      case 1:
        return const Color.fromRGBO(255, 235, 59, 1); // Medium
      case 2:
        return const Color.fromRGBO(255, 248, 225, 1); // Hard
      default:
        return Colors.orange; // Fallback
    }
  }

  //method called to start the timer
  void _startTimer() {
    if (_timer != null && _timer!.isActive) return; // Prevent multiple timers
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        if (_seconds > 0) {
          //making sure we cant start the timer with no time remaining
          _seconds--;
        } else {
          _stopTimer(); // Stop when it reaches 0
        }
      });
    });
  }

  ///formats the timer to mm:ss format
  String _formatTimer(int time) {
    final minutes = time ~/ 60; //truncated integer division
    final seconds = time % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  //method called to stop the timer
  void _stopTimer() {
    _timer?.cancel();
  }

  void _resetTimer() {
    _timer?.cancel();
    _seconds = _boilTimes[_selectedHardness];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //the entire page
      appBar: AppBar(
        //bar at top of the page, automatically has a callback to the previous page
        title: const Text("Emma's Eggs"),
        backgroundColor: Colors.amber,
      ),
      backgroundColor: Color.fromARGB(255, 255, 243, 190),
      body: Column(
        //a vertical container - use a ListView if there is not enough room for vertical content
        children: [
          Padding(
              //like a 'gap' in powerapps, pads around all sides of the children
              padding: const EdgeInsets.all(8.0),
              child: _buildHardnessSelector()),
          Expanded(child: _buildEggTimer()),
        ],
      ),
    );
  }

  Widget _buildHardnessSelector() {
    return Wrap(
      spacing: 10,
      alignment: WrapAlignment.center,
      children: List.generate(_hardness.length, (index) {
        //generate one item for each hardness option
        return ChoiceChip(
          label: Text(_hardness[index]),
          selected: _selectedHardness == index,
          selectedColor: _getProgressColor(),
          onSelected: (bool selected) {
            setState(() {
              if (selected == true) {
                _selectedHardness = index;
                _boilTime = _boilTimes[_selectedHardness];
                _seconds = _boilTime;
              }
            });
          },
        );
      }),
    );
  }

  Widget _buildEggTimer() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(fit: StackFit.loose, alignment: Alignment.center, children: [
            SizedBox(
              width: 150,
              height: 200, //make it egg shaped
              //because we are using a stack, we are able to see the progress indicator around the timer value
              child: CircularProgressIndicator(
                value: _boilTime > 0
                    ? _seconds / _boilTime
                    : 0, //the rate that the indicator is decremented, set _boilTime to 0 if null
                strokeWidth: 20,
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(_getProgressColor()),
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, anim) =>
                  ScaleTransition(scale: anim, child: child),
              child: Text(
                //the actual timer value displayed through text
                _formatTimer(_seconds),
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ]),
          const SizedBox(
            height: 80,
          ),
          ElevatedButton(
            //Start button that turns into a pause button
            onPressed: () {
              setState(() {
                if (_isRunning) {
                  _resetTimer();
                } else {
                  _startTimer();
                }
                _isRunning = !_isRunning;
              });
            },
            child: Text(
              _isRunning ? 'Stop' : 'Boil Em!',
              style: const TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}