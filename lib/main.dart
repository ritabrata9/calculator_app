import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_expressions/math_expressions.dart';
import 'dart:async';

void main() async {
  //Declared async to allow await for asynchronous operations.
  WidgetsFlutterBinding.ensureInitialized(); //Initializes Flutter engine binding before using any native platform channel calls.
  await SystemChrome.setPreferredOrientations([
    // locks orientation
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MaterialApp(home: Calculator()));
}

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String input = '';
  String output = '';
  bool _showCursor = true; // controls whether cursor is visible or not
  Timer? _cursorTimer; // toggles showcursor over 600 ms

  List<String> operations = ['+', '-', '×', '÷', '^', '%', '.'];

  int flag = 0;
  int flag2 = 0;

  @override
  void initState() {
    // Initializes the timer as soon as the widget is created
    super.initState();
    _cursorTimer = Timer.periodic(Duration(milliseconds: 600), (timer) {
      // creates a periodic timer that triggers every 600 milliseconds.
      setState(() {
        _showCursor = !_showCursor; // if true, it becomes false i.e. toggling
      });
    });
  }

  @override
  void dispose() {
    // without this timer keeps running even if the user leaves the screen
    _cursorTimer?.cancel();
    super.dispose();
  }

  void getInput(String value) {
    setState(() {
      if (value == 'AC') {
        clear();
      } else if (value == '=') {
        getResult();
      } else {
        if (operations.contains(value)) {
          if (input.isEmpty) return; // Don't allow operator at start
          String lastChar = input[input.length - 1];
          if (operations.contains(lastChar)) return; // Prevent double operators
        }
        input += value;
      }
    });
  }

  void getResult() {
    final expression = input.replaceAll('×', '*').replaceAll('÷', '/');

    // ignore: deprecated_member_use
    final exp = Parser().parse(
      expression,
    ); // converts string into math expression usib library

    // ignore: deprecated_member_use
    final result = exp.evaluate(EvaluationType.REAL, ContextModel());

    setState(() {
      output = result.toString();
    });
  }

  void clear() {
    setState(() {
      output = '';
      input = '';
      flag = 0;
      flag2 = 0;
    });
  }

  void trimInput() {
    setState(() {
      if (input.isNotEmpty) {
        input = input.substring(0, input.length - 1);
      }
    });
  }

  Widget numberButton(String label) {
    return SizedBox(
      width: 100,
      height: 100,
      child: FloatingActionButton(
        onPressed: () {
          getInput(label);
        },
        backgroundColor: const Color.fromARGB(255, 128, 59, 80),
        shape: CircleBorder(),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget opButton(String label) {
    return SizedBox(
      width: 100,
      height: 100,
      child: FloatingActionButton(
        onPressed: () {
          getInput(label);
        },
        backgroundColor: const Color.fromARGB(255, 244, 184, 205),
        shape: CircleBorder(),

        child: Text(
          label,
          style: TextStyle(
            color: const Color.fromARGB(255, 0, 0, 0),
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Container(
                width: MediaQuery.of(context).size.width * 1,

                margin: const EdgeInsets.only(
                  bottom: 10,
                ), // Adds spacing between display and buttons

                padding: const EdgeInsets.symmetric(
                  // dist btwn edge of screen and input
                  horizontal: 20,
                  vertical: 80,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(
                    255,
                    58,
                    58,
                    58,
                  ), // Dark grey to contrast against black background

                  borderRadius: BorderRadius.circular(
                    35,
                  ), // Rounds all 4 corners
                ),

                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        reverse: true,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              input.isEmpty ? ' ' : input,
                              style: const TextStyle(
                                fontSize: 32,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.visible,
                              softWrap: false,
                            ),
                            AnimatedOpacity(
                              opacity: _showCursor ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 300),
                              child: Container(
                                width: 2,
                                height: 60,
                                color: Colors.white,
                                margin: const EdgeInsets.only(left: 2),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),
                      Text(
                        output,
                        style: const TextStyle(
                          fontSize: 41,
                          color: Color.fromARGB(255, 7, 249, 24),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  // AC Button
                  width: 100,
                  height: 100,
                  child: FloatingActionButton(
                    onPressed: () {
                      clear();
                    },
                    backgroundColor: const Color.fromARGB(255, 248, 236, 107),
                    shape: const CircleBorder(),
                    child: Text(
                      'AC',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                opButton('^'),
                opButton('÷'),
                opButton('×'),
              ],
            ),
            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                numberButton('7'),
                numberButton('8'),
                numberButton('9'),
                opButton('+'),
              ],
            ),
            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                numberButton('4'),
                numberButton('5'),
                numberButton('6'),
                opButton('-'),
              ],
            ),
            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                numberButton('1'),
                numberButton('2'),
                numberButton('3'),
                opButton('%'),
              ],
            ),
            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                numberButton('0'),
                numberButton('.'),
                SizedBox(
                  // BACKSPACE
                  width: 100,
                  height: 100,
                  child: FloatingActionButton(
                    onPressed: () {
                      trimInput();
                    },
                    backgroundColor: const Color.fromARGB(255, 128, 59, 80),
                    shape: CircleBorder(),
                    child: Icon(
                      Icons.backspace, // or any other icon of your choice
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                SizedBox(
                  // EQUALS TO BUTTON
                  width: 100,
                  height: 100,
                  child: FloatingActionButton(
                    onPressed: () {
                      getResult();
                    },
                    backgroundColor: const Color.fromARGB(255, 236, 21, 107),
                    shape: const CircleBorder(),
                    child: Text(
                      '=',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
