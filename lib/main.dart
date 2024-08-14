import 'package:flutter/material.dart';
import 'package:pvcombank_kyc/pvcombank_kyc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final pvcomBankKyc = PVComBankKyc();
  String urlConfirm = "";
  String kycStatus = "Idle";

  @override
  void initState() {
    super.initState();
    _setupEventListener();
  }

  void _setupEventListener() {
    pvcomBankKyc.eventStream.listen(
      (event) {
        print('Received event: $event');
        if (event is Map<String, dynamic>) {
          setState(() {
            if (event['type'] == 'success') {
              kycStatus = "Success: ${event['message']}";
            } else if (event['type'] == 'screen') {
              kycStatus = "Screen changed: ${event['tag']}";
            }
          });
        }
      },
      onError: (error) {
        print('Error: $error');
        setState(() {
          kycStatus = "Error: $error";
        });
      },
    );
  }

  Future<void> _startKyc() async {
    setState(() {
      kycStatus = "Starting KYC...";
    });
    try {
      await pvcomBankKyc.start(
        true,
        "VIETPAY",
        "VIETPAY",
        "",
        "",
        "",
        "0389494502",
        true,
        "",
        false,
      );
    } catch (e) {
      setState(() {
        kycStatus = "Error starting KYC: $e";
      });
    }
  }

  Future<void> _trustData() async {
    setState(() {
      kycStatus = "Starting KYC Liveness...";
    });
    try {
      await pvcomBankKyc.trustData(
        true,
        "VIETPAY",
        "VIETPAY",
        "",
        "",
        "partner.id",
        urlConfirm,
      );
    } catch (e) {
      setState(() {
        kycStatus = "Error starting KYC Liveness: $e";
      });
    }
  }

  Future<void> _trustDataV2() async {
    setState(() {
      kycStatus = "Starting KYC by Data...";
    });
    try {
      await pvcomBankKyc.trustDataV2(
        true,
        "VIETPAY",
        "VIETPAY",
        "",
        "",
        "partnerid",
        "hungtm5@pvcombank.com.vn",
        "0777692834",
      );
    } catch (e) {
      setState(() {
        kycStatus = "Error starting KYC by Data: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('PVComBank KYC Example'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'KYC Status: $kycStatus',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _startKyc,
                  child: const Text("Start KYC"),
                ),
                const SizedBox(height: 20),
                TextField(
                  onChanged: (text) {
                    urlConfirm = text;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Enter URL confirm',
                    border: OutlineInputBorder(),
                    helperText: "URL is only used for liveness feature",
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _trustData,
                  child: const Text("Start KYC Liveness"),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _trustDataV2,
                  child: const Text("Start KYC by Data"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
