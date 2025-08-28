import 'package:flutter/material.dart';
import 'timer.dart';

///Splash Screen
class EggTimerStart extends StatelessWidget {
  
  const EggTimerStart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background.jpg'),
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
              MaterialPageRoute(builder: (_) => const EggTimerMain()),
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
            'Emm-ter',
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