import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class PdfPage extends StatelessWidget {
  const PdfPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pdfController = PdfController(
  document: PdfDocument.openAsset('assets/rsa.pdf'),
);
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: PdfView(controller: pdfController),
      ),
    );
  }
}