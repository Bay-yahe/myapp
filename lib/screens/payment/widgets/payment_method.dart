import 'package:flutter/material.dart';
import 'package:bay_yahe_app/screens/payment/E-Payment/gcash_screen.dart';
import 'package:bay_yahe_app/screens/payment/E-Payment/paymaya_screen.dart';
import 'package:bay_yahe_app/screens/payment/widgets/cash_payment.dart';

class PaymentMethods extends StatelessWidget {
  const PaymentMethods({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text(
              'Payment Methods',
              style: TextStyle(color: Colors.black),
            ),
          ),
          backgroundColor: const Color(0xFF33c072),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // Implement navigation to go back to the previous screen
              Navigator.pop(context);
            },
          ),
        ),
        body: const PaymentMethodsScreen(),
      ),
    );
  }
}

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  _PaymentMethodsScreenState createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  int selectedPaymentMethod = 0; // Default selection is Cash

  // Define the list of payment methods here
  List<Map<String, dynamic>> paymentMethods = [
    {'text': 'Cash', 'asset': 'assets/logo/cash.png'},
    {'text': 'G-cash', 'asset': 'assets/logo/g-cash.png'},
    {'text': 'PayMaya', 'asset': 'assets/logo/paymaya.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            itemCount: paymentMethods.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Radio(
                  value: index,
                  groupValue: selectedPaymentMethod,
                  onChanged: (int? value) {
                    setState(() {
                      selectedPaymentMethod = value!;
                    });
                  },
                ),
                title: Text(paymentMethods[index]['text']),
                trailing: Image.asset(
                  paymentMethods[index]['asset'],
                  width: 24,
                  height: 24,
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              // Determine which payment screen to navigate to based on the selection.
              if (selectedPaymentMethod == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CashPaymentScreen(),
                  ),
                );
              } else if (selectedPaymentMethod == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GcashPaymentScreen(),
                  ),
                );
              } else if (selectedPaymentMethod == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PayMayaPaymentScreen(),
                  ),
                );
              }
            },
            child: const Text('Confirm'),
          ),
        ),
      ],
    );
  }
}
