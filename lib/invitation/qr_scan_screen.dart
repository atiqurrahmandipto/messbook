import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../home/home.dart';

class QRScannerWidget extends StatefulWidget {
  const QRScannerWidget({Key? key}) : super(key: key);

  @override
  State<QRScannerWidget> createState() => _QRScannerWidgetState();
}

class _QRScannerWidgetState extends State<QRScannerWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEAF2FF),
      appBar: AppBar(
        title: Text(""),
        backgroundColor: Color(0xffEAF2FF),
        elevation: 0,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => HomePage()));
            },
            child: SizedBox(
              height: 40,
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Skip',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      decoration: TextDecoration.underline),
                ),
              )),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 32,
            ),
            Text(
              "Scan QR Code",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              "Scan the QR code from the mess manager's phone to join the mess",
              style: TextStyle(fontSize: 16, color: Color(0xff434A54)),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width - 48,
              height: MediaQuery.of(context).size.width - 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: MobileScanner(
                  allowDuplicates: false,
                  onDetect: (barcode, args) {
                    if (barcode.rawValue == null ||
                        barcode.rawValue == "ERROR") {
                      debugPrint('Failed to scan Barcode');
                    } else {
                      final String code = barcode.rawValue!;
                      debugPrint('Barcode found! $code');
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
