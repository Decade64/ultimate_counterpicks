import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:stagelistgg/main.dart';
import 'package:stagelistgg/rulesets/classes/ruleset.dart';

class QrReader extends StatefulWidget{
  const QrReader({Key? key}) : super(key: key);

  @override
  State<QrReader> createState() => _QrReaderState();
}

class _QrReaderState extends State<QrReader> {
  final qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  Barcode? barcode;
  AppBar appBar = AppBar(title: const Text("Scan a code"),);

  @override void dispose() {
    // controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    void goback(){
      Navigator.of(context).pop();
    }

    void onQRViewCreated(QRViewController controller){
      setState(() => this.controller = controller);
      controller.scannedDataStream
        .listen((barcode){
        setState(() {
          appBar = AppBar(
            title: const Text("Loading"),
            automaticallyImplyLeading: false,
          );
        });
          controller.stopCamera();
            String jsonString = barcode.code!;
            Map<String,dynamic> json = jsonDecode(jsonString);
            Ruleset ruleset = Ruleset.fromJson(json);
            ruleset.manualWriteRuleset(ruleset);
            ruleset.renameRulesets;
            rulesetListFuture = ruleset.rulesetList;
          Future.delayed(const Duration(seconds: 1),(){
            goback();
          });
        });
    }

    return Scaffold(
      appBar: appBar,
      body: Stack(
        children: [
          const Center(child: CircularProgressIndicator()),
          QRView(
            key: qrKey,
            onQRViewCreated: onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.white,
              borderWidth: 7,
              cutOutSize: MediaQuery.of(context).size.width * 0.8,
            ),
          ),
        ],
      )
    );
  }
}