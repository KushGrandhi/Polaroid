
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_compress/video_compress.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String _counter = 'Compress State';
  var tempFile;
  File finalfile;
  String description;
  String urlLink;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Text('Polaroid'),
        backgroundColor: Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
        elevation: 0,
      ),
      body: Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Please Upload Your Video',
                        style: GoogleFonts.quicksand(
                            fontSize: 24, fontWeight: FontWeight.bold))),
                SizedBox(
                  height: 18,
                ),
                InkWell(
                  onTap: () async {
                    tempFile = await ImagePicker().getVideo(
                      source: ImageSource.gallery,
                    );
                    await VideoCompress.setLogLevel(0);
                    final info = await VideoCompress.compressVideo(
                      tempFile.path,
                      quality: VideoQuality.LowQuality,
                      deleteOrigin: false,
                      includeAudio: true,
                    );
                    if (info != null) {
                      setState(() {
                        _counter = "Successfully Compressed";
                        finalfile = File(info.path);
                        print(info.filesize);
                        print(finalfile.path);
                      });

                        TaskSnapshot snapshot =await FirebaseStorage.instance.ref().child(
                            'Videos').
                        child(auth.currentUser.uid).putFile(finalfile,
                            SettableMetadata(contentType: 'video/mp4'));
                        print("done");
                        if(snapshot != null) {
                          urlLink = await snapshot.ref.getDownloadURL();
                          print(urlLink);
                        }
                      }
                      if(urlLink!=null) {
                        try {
                          //TODO
                          String url = "https://56100edbbacd.ngrok.io/test";
                          Map<String, String> headers = {
                            "Content-type": "application/json"
                          };
                          String json = '{"uid":"${auth.currentUser.uid}","FileName":"$description","url":"$urlLink"}';
                          Response response = await post(
                              url, headers: headers, body: json);
                          int statusCode = response.statusCode;
                          String body = response.body;
                          print(body);
                          print(statusCode);
                          print(response.body);
                          print("API done");
                          urlLink=null;
                        }
                        catch (e) {
                          print(e);
                        }
                    } else
                      print('Url empty');
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                          Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        stops: [0, 1],
                      ),
                    ),
                    child: Center(
                        child: Text(
                          "Select from gallery",
                          style: GoogleFonts.quicksand(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )),
                  ),
                ),


                SizedBox(
                  height: 18,
                ),
                tempFile != null
                    ? Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: Color(0xffebebeb),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        finalfile != null
                            ? Text("Uploading your video...")
                            : Text("Processing your video...")
                      ],
                    ),
                  ),
                )
                    : Container(),
                SizedBox(
                  height: 15,
                ),
                tempFile != null
                    ? InkWell(
                    onTap: () {
                      tempFile = null;
                      VideoCompress.cancelCompression();
                      setState(() {});
                    },
                    child: Container(
                        height: 50,
                        width: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Color.fromRGBO(255, 188, 117, 1),
                        ),
                        child: Center(child: Text('Cancel'))))
                    : Container(),
                SizedBox(
                  height: 15,
                ),
                Text('$_counter'),
                SizedBox(
                  height: 15,
                ),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'File name',
                  ),
                  onChanged: (value) {
                    description = value;
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
