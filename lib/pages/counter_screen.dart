import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  late int customNumber = 0;
  int? newNumber;

  @override
  void initState() {
    super.initState();
    getNumber();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          countChanger();
        },
        child: const Icon(Icons.add_circle),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Unsaved Value"),
            SizedBox(
              width: double.infinity,
              child: Center(
                child: Text(
                  customNumber.toString(),
                  style: const TextStyle(fontSize: 50),
                ),
              ),
            ),
            const Text("Saved Value On SharedPrefrences"),
            SizedBox(
              width: double.infinity,
              child: Center(
                child: Text(
                  (newNumber ??= 0).toString(),
                  style: const TextStyle(fontSize: 50),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                resetNumber();
              },
              child: const Text("Reset"),
            )
          ],
        ),
      ),
    );
  }

  void countChanger() {
    setState(() {
      customNumber++;
    });
    setNumber();
  }

  Future<void> setNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? storedValue;

    if (newNumber == null) {
      storedValue = customNumber;
    } else {
      storedValue = newNumber! + 1;
    }

    await prefs.setInt("numb", storedValue);
    getNumber();
  }

  Future<void> resetNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("numb");
    setState(() {
      customNumber = 0;
      newNumber = 0;
    });
  }

  Future<int> getNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      newNumber = prefs.getInt("numb")!;
    });

    return newNumber!;
  }
}
