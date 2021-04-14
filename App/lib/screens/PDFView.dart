import 'dart:io';

import 'package:flutter/material.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
class Pdf extends StatefulWidget {
  Pdf(this.url,this.descrition);
  String url="https://firebasestorage.googleapis.com/v0/b/polaroid-c6420.appspot.com/o/fpdf%2Fresume.pdf?alt=media&token=b20b9c3b-7c69-4483-9d83-59735122af08";
  String descrition="data";
  @override
  _PdfState createState() => _PdfState(url);
}

class _PdfState extends State<Pdf> {
  String url;
  _PdfState(this.url);
  bool _isLoading = true;
  PDFDocument document;

  @override
  void initState() {
    super.initState();
    changePDF(2,url);
  }



  changePDF(value,data) async {
    setState(() => _isLoading = true);
    if (value == 2) {
      document = await PDFDocument.fromURL("https://firebasestorage.googleapis.com/v0/b/polaroid-c6420.appspot.com/o/fpdf%2Fresume.pdf?alt=media&token=b20b9c3b-7c69-4483-9d83-59735122af08");
    }
    setState(() => _isLoading = false);
  }


  Future<String> get _localPath async {
    Future<Directory> _getDownloadsPath =
        DownloadsPathProvider.downloadsDirectory;
    final downloadsDir = await _getDownloadsPath;

    return downloadsDir.path;
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(

      appBar: AppBar(
        title:Text(widget.descrition),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.download_sharp),
            color:Colors.white,
            onPressed: () async{
              final file = await _localPath;
              String localPath = (await _localPath) + Platform.pathSeparator + "drop";
              print(localPath);
              final savedDir = Directory(localPath);
              bool hasExisted = await savedDir.exists();
              if (!hasExisted) {
                savedDir.create();
              }
              var status = await Permission.storage.status;
              if(status.isDenied || status.isUndetermined){
                if(await Permission.storage.isPermanentlyDenied){
                  openAppSettings();

                }else{
                  var status1 = await Permission.storage.request();
                  if(status1.isGranted){
                    try{

                      final taskId = await FlutterDownloader.enqueue(
                        url:"https://firebasestorage.googleapis.com/v0/b/polaroid-c6420.appspot.com/o/fpdf%2Fresume.pdf?alt=media&token=b20b9c3b-7c69-4483-9d83-59735122af08",
                        savedDir:file,
                        showNotification: false,
                        openFileFromNotification: false,
                      );
                      print("sucess");
                    }
                    catch(e){
                      print(e);
                    }

                  }
                }

              }else{

                try{

                  final taskId = await FlutterDownloader.enqueue(
                    url:"https://firebasestorage.googleapis.com/v0/b/polaroid-c6420.appspot.com/o/fpdf%2Fresume.pdf?alt=media&token=b20b9c3b-7c69-4483-9d83-59735122af08",
                    savedDir:file,
                    showNotification: false,
                    openFileFromNotification: false,
                  );
                  print("sucess");
                }
                catch(e){
                  print(e);
                }
              }



            },
          ),
        ],

        backgroundColor: Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),elevation: 0, //TODO bg color
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
