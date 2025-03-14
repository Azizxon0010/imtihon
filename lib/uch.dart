import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:imtihon/birinchi.dart';
import 'package:intl/intl.dart';
import 'dart:async';

void main() {
  runApp(uch());
}

class uch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SuccessScreen(fullName: 'Ism Familiya'),
    );
  }
}

class SuccessScreen extends StatefulWidget {
  final String fullName;
  SuccessScreen({required this.fullName});

  @override
  _SuccessScreenState createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  List currencies = [];
  bool isLoading = true;
  String _currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    fetchCurrencies();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        _currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
      });
    });
  }

  Future<void> fetchCurrencies() async {
    final response =
        await http.get(Uri.parse('https://cbu.uz/uz/arkhiv-kursov-valyut/json/'));
    if (response.statusCode == 200) {
      setState(() {
        currencies = json.decode(response.body);
        isLoading = false;
      });
    }
  }

  void showCurrencyDialog(Map currency) {
    TextEditingController amountController = TextEditingController();
    bool isConvertingToSum = true;
    double result = 0.0;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text('${currency['CcyNm_UZ']} maʼlumotlari'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Qiymati: ${currency['Rate']}'),
                  Text('Valyuta: ${currency['Ccy']}'),
                  Text('Nomi: ${currency['CcyNm_UZ']}'),
                  SizedBox(height: 10),
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Miqdor kiriting',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      double amount = double.tryParse(amountController.text) ?? 0;
                      if (amount > 0) {
                        setState(() {
                          result = isConvertingToSum
                              ? amount * double.parse(currency['Rate'])
                              : amount / double.parse(currency['Rate']);
                        });
                      }
                    },
                    child: Text('Hisoblash'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    isConvertingToSum
                        ? 'Soʻm: ${result.toStringAsFixed(2)}'
                        : '${currency['Ccy']}: ${result.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isConvertingToSum = !isConvertingToSum;
                          });
                        },
                        child: Text(isConvertingToSum ? currency['CcyNm_UZ'] : 'Soʻm'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Qaytish'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Color getChangeColor(String diff) {
    double change = double.tryParse(diff) ?? 0;
    if (change > 0) {
      return Colors.green;
    } else if (change < 0) {
      return Colors.red;
    } else {
      return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp(),));}, icon: Icon(Icons.exit_to_app))],
        backgroundColor: Colors.blue,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.fullName),
            Text(_currentTime),
          ],
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: currencies.length,
              itemBuilder: (context, index) {
                final currency = currencies[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Yagilangan kun  ${currency['Date']}",
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      SizedBox(height: 5),
                      GestureDetector(
                        onTap: () => showCurrencyDialog(currency),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${currency['CcyNm_UZ']} (${currency['Ccy']})",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Text(
                                    "1 ${currency['Ccy']}",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Spacer(),
                                  Text(
                                    currency['Rate'],
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Text(
                                currency['Diff'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: getChangeColor(currency['Diff']),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
