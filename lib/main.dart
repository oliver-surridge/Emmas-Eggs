import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MaterialApp(home: EggTimerStart()));
}

class EggTimerStart extends StatelessWidget {
  const EggTimerStart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background.jpg'), // Path to your image
          fit: BoxFit.cover, // Covers the entire screen
        ),
      ),
      child: Center(
        child: ElevatedButton(
          //Egg button that bounces around the screen - nav on click
          onPressed: () {
            Navigator.push(
              //Nav to next screen
              context,
              MaterialPageRoute(builder: (_) => EggTimerMain()),
            );
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 30),
            shape: const OvalBorder(), // Makes it egg-shaped
            backgroundColor:
                const Color.fromARGB(225, 225, 159, 107), // Egg color
            overlayColor: Color.fromARGB(255, 255, 213, 0),
            side: BorderSide(
              width: 1.0,
              color: Colors.black,
            ),
          ),
          child: Text(
            'Eggter',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.yellow,
            ),
          ),
        ),
      ),
    ));
  }
}

class EggTimerMain extends StatefulWidget {
  const EggTimerMain({super.key});

  @override
  State<EggTimerMain> createState() => _EggTimerMainState();
}

class _EggTimerMainState extends State<EggTimerMain> {
  int _selectedHardness = 0;
  //final is the same as const but is set once it is initialized rather than on compilation like const
  final List<String> _hardness = ["Soft", "Medium", "Hard"];
  bool _start = false;
  int _seconds = 360;
  int _boilTime = 360;
  Timer? _timer;
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
  void startTimer() {
    if (_timer != null && _timer!.isActive) return; // Prevent multiple timers
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        if (_seconds > 0) {
          //making sure we cant start the timer with no time remaining
          _seconds--;
        } else {
          stopTimer(); // Stop when it reaches 0
        }
      });
    });
  }

  //method called to stop the timer
  void stopTimer() {
    _timer?.cancel();
  }

  void resetTimer() {
    _timer?.cancel();
    _seconds = _boilTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //the entire page
      appBar: AppBar(
        //bar at top of the page, automatically has a callback to the previous page
        title: Text("Emma's Eggs"),
        backgroundColor: Colors.yellow,
      ),
      body: Column(
        //a vertical container - use a ListView if there is not enough room for vertical content
        children: [
          Padding(
            //like a 'gap' in powerapps, pads around all sides of the children
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 10,
              alignment: WrapAlignment.center,
              children: List.generate(_hardness.length, (eggdex) {
                //we can generate one item for each hardness option - eggdex is what I called the index
                return ChoiceChip(
                  label: Text(_hardness[eggdex]),
                  selected: _selectedHardness == eggdex,
                  selectedColor: _getProgressColor(),
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected == true) {
                        _selectedHardness = eggdex;
                        _boilTime = [360, 480, 720][_selectedHardness];
                        _seconds = _boilTime;
                      } else {
                        _selectedHardness = _selectedHardness;
                      }
                    });
                  },
                );
              }),
            ),
          ),
          Expanded(
              child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                    fit: StackFit.loose,
                    alignment: Alignment.center,
                    children: [
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
                          valueColor: AlwaysStoppedAnimation<Color>(
                              _getProgressColor()),
                        ),
                      ),
                      Text(
                        //the actual timer value displayed through text
                        '$_seconds',
                        style: TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ]),
                SizedBox(height: 80),
                ElevatedButton(
                  //Start button that turns into a pause button
                  onPressed: () {
                    setState(() {
                      if (_start) {
                        resetTimer();
                      } else {
                        startTimer();
                      }
                      _start = !_start;
                    });
                  },
                  child: Text(
                    _start ? 'Stop' : 'Boil Em!',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromRGBO(0, 0, 0, 1),
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
      backgroundColor: Color.fromARGB(225, 225, 159, 107),
    );
  }
}
