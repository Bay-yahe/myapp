import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PinCodeScreen(),
    );
  }
}

class PinCodeScreen extends StatefulWidget {
  const PinCodeScreen({super.key});

  @override
  _PinCodeScreenState createState() => _PinCodeScreenState();
}

class _PinCodeScreenState extends State<PinCodeScreen> {
  List<int> enteredPin = [];
  bool showPin = false;
  int currentFocusIndex = 0;

  void updatePin(List<int> newPin) {
    setState(() {
      enteredPin = newPin;
      currentFocusIndex = 0;
    });
  }

  void toggleShowPin() {
    setState(() {
      showPin = !showPin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF33c072),
        title: const Text(
          'PIN Code Setup',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Enter a new PIN',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            const Text(
              'Your PIN cannot have repeating numbers (e.g., 11111) or consecutive numbers (e.g., 12345).',
              style: TextStyle(fontSize: 14, color: Colors.red),
            ),
            const SizedBox(height: 20),
            PinCodeInput(
              length: 6,
              onChanged: (newPin) => updatePin(newPin),
              showPin: showPin,
              currentFocusIndex: currentFocusIndex,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: toggleShowPin,
              child: Text(showPin ? 'Hide Pin Code' : 'Show Pin Code'),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                if (enteredPin.length == 6) {
                  // Handle saving the PIN here
                } else {
                  // Show an error message to fill all circles.
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: const Text(
                            'Please fill all circles before saving.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              icon: const Icon(Icons.save),
              label: const Text('Save PIN'),
            ),
          ],
        ),
      ),
    );
  }
}

class PinCodeInput extends StatefulWidget {
  final int length;
  final Function(List<int>) onChanged;
  final bool showPin;
  final int currentFocusIndex;

  const PinCodeInput({super.key, 
    required this.length,
    required this.onChanged,
    required this.showPin,
    required this.currentFocusIndex,
  });

  @override
  _PinCodeInputState createState() => _PinCodeInputState();
}

class _PinCodeInputState extends State<PinCodeInput> {
  List<int> pin = [];
  List<FocusNode> focusNodes = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.length; i++) {
      pin.add(-1);
      focusNodes.add(FocusNode());
    }
    focusNodes[0].requestFocus();
  }

  @override
  void dispose() {
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.length, (index) {
        return GestureDetector(
          onTap: () {
            if (index <= widget.currentFocusIndex) {
              FocusScope.of(context).requestFocus(focusNodes[index]);
            }
          },
          child: Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(width: 2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                widget.showPin
                    ? (pin[index] != -1 ? pin[index].toString() : '')
                    : '*',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        );
      }),
    );
  }
}
