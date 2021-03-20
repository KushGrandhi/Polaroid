import 'package:flutter/material.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';



class Pdf extends StatefulWidget {
  Pdf(this.url);
  String url;
  @override
  _PdfState createState() => _PdfState();
}

class _PdfState extends State<Pdf> {

  bool _isLoading = true;
  PDFDocument document;

  @override
  void initState() {
    super.initState();
    changePDF(2,widget.url);
  }



  changePDF(value,data) async {
    setState(() => _isLoading = true);
    if (value == 2) {
      document = await PDFDocument.fromURL(data.toString());
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text('FlutterPluginPDFViewer'),
      ),
      body: Center(
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : PDFViewer(
          document: document,
          zoomSteps: 1,

        ),
      ),
    );
  }
}
