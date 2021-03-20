import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
class PDFView extends StatefulWidget
{
  String url;
  PDFView(this.url)
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PDFViewState(url);
  }

}

class PDFViewState extends State<PDFView> {
  String url;
  PDFViewState(this.url);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Scaffold(

      body: Container(),
    );
  }
}
