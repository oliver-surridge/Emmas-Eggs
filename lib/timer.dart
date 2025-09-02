import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';

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
        return const Color.fromARGB(255, 255, 223, 118); // Hard
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

  ///formats to mm:ss format
  String _formatTimer(int time) {
    final minutes = time ~/ 60; //truncated integer division
    final seconds = time % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  ///stop the timer
  void _stopTimer() {
    _timer?.cancel();
  }

  ///reset timer
  void _resetTimer() {
    _stopTimer();
    _seconds = _boilTimes[_selectedHardness];
  }

  ///check timer status
  bool _isTimerActive() {
    return _timer?.isActive ?? false; //if null, false
  }

  @override
  Widget build(BuildContext context) {
    final _screenWidth = MediaQuery.sizeOf(context)
        .width; //sizeOf instead of 'of' as 'of has extra data
    final _screenHeight = MediaQuery.sizeOf(context).height;
    final _orientation = MediaQuery.orientationOf(context);
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
            padding: EdgeInsets.all(_screenWidth / 50),
            child: _buildHardnessSelector(_screenWidth, _screenHeight),
          ),
          Expanded(
              child: _buildEggTimer(_screenWidth, _screenHeight, _orientation)),
        ],
      ),
    );
  }

  Widget _buildHardnessSelector(double screenWidth, double screenHeight) {
    return Wrap(
      spacing: screenWidth / 20,
      alignment: WrapAlignment.center,
      children: List.generate(_hardness.length, (index) {
        final double chipHeight = screenHeight * 0.05;
        //generate one item for each hardness option
        return SizedBox(
          height: chipHeight,
          child: ChoiceChip(
            label: Text(_hardness[index]),
            selected: _selectedHardness == index,
            selectedColor: _getProgressColor(),
            onSelected: (bool selected) {
              setState(() {
                if (selected == true) {
                  if (_isTimerActive()) {
                    _resetTimer();
                  }
                  _selectedHardness = index;
                  _boilTime = _boilTimes[_selectedHardness];
                  _seconds = _boilTime;
                }
              });
            },
          ),
        );
      }),
    );
  }

  Widget _buildEggTimer(
      double screenWidth, double screenHeight, Orientation orientation) {
    final double eggWidth;
    final double eggHeight;

    if (orientation == Orientation.portrait) {
      eggWidth = screenWidth * 0.5;
      eggHeight = screenHeight * 0.35;
    } else {
      eggWidth = screenWidth * 0.15;
      eggHeight = eggWidth * 1.5;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(fit: StackFit.loose, alignment: Alignment.center, children: [
            SizedBox(
              width: eggWidth,
              height: eggHeight, //make it egg shaped
              //because we are using a stack, we are able to see the progress indicator around the timer value
              child: CircularProgressIndicator(
                value: _boilTime > 0
                    ? _seconds / _boilTime
                    : 0, //the rate that the indicator is decremented, set _boilTime to 0 if null
                strokeWidth: eggWidth / 15,
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(_getProgressColor()),
              ),
            ),
            Text(
              //the actual timer value displayed through text
              _formatTimer(_seconds),
              style: TextStyle(
                fontSize: eggHeight / 6,
                fontWeight: FontWeight.bold,
              ),
            ),
          ]),
          SizedBox(
            height: eggHeight / 2,
          ),
          ElevatedButton(
            //Start button that turns into a pause button
            onPressed: () {
              setState(() {
                if (_isTimerActive()) {
                  _resetTimer();
                } else {
                  _startTimer();
                }
              });
            },
            child: Text(
              _isTimerActive() ? 'Stop' : 'Boil Em!',
              style: TextStyle(
                fontSize: screenHeight / 25,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
