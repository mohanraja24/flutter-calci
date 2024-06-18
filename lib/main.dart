import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Age Calculator',
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String myAge = '';
  String liveTime = '';
  bool hasCalculatedAge = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    // Initialize the live time
    updateLiveTime();
    // Update the live time every second
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => updateLiveTime());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void updateLiveTime() {
    setState(() {
      liveTime = DateFormat('hh:mm:ss a').format(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Age Calculator"),
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).primaryColorDark),
      ),
      body: Container(
        color: Colors.orange[100], // Set background color
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Current Time',
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'Roboto', // Change font
                  color: Colors.deepOrange, // Change font color
                ),
              ),
              Text(
                liveTime,
                style: const TextStyle(
                  fontSize: 25,
                  fontFamily: 'Roboto',
                  color: Colors.deepOrange,
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Your age is',
                style: TextStyle(
                  fontSize: 40,
                  fontFamily: 'Roboto', // Change font
                  color: Colors.deepOrange, // Change font color
                ),
              ),
              const SizedBox(height: 10),
              Text(
                myAge,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                  color: Colors.deepOrange,
                ),
              ),
              const SizedBox(height: 60),
              ElevatedButton(
                onPressed: () => pickDob(context),
                child: const Text('Pick Date of Birth'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange, // Button background color
                  foregroundColor: Colors.white, // Button text color
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
              if (hasCalculatedAge)
                ElevatedButton(
                  onPressed: clearAge,
                  child: const Text('Clear Age'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void pickDob(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      ).then((pickedTime) {
        if (pickedTime != null) {
          DateTime finalPickedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          if (finalPickedDateTime.isAfter(DateTime.now())) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Invalid Date'),
                content: const Text('The selected date is in the future. Please choose a valid date.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          } else {
            calculateAge(finalPickedDateTime);
          }
        }
      });
    }
  }

  void calculateAge(DateTime birth) {
    DateTime now = DateTime.now();
    Duration age = now.difference(birth);

    int years = age.inDays ~/ 365;
    int months = (age.inDays % 365) ~/ 30;
    int days = ((age.inDays % 365) % 30);
    int hours = age.inHours % 24;
    int minutes = age.inMinutes % 60;
    int seconds = age.inSeconds % 60;

    setState(() {
      myAge = '$years years, $months months, $days days, $hours hours, $minutes minutes, and $seconds seconds';
      hasCalculatedAge = true;
    });
  }

  void clearAge() {
    setState(() {
      myAge = '';
      hasCalculatedAge = false;
    });
  }
}
