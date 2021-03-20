import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_compress/video_compress.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'dart:convert';
class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String _counter='Compress State';
  File finalfile;
  String description;
  String urlLink;

  @override
  Widget build(BuildContext context) {


    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Input Video File'),
            ElevatedButton(
                onPressed: () async {

                  final file =
                  await ImagePicker().getVideo(source: ImageSource.gallery,);
                  await VideoCompress.setLogLevel(0);
                  final info = await VideoCompress.compressVideo(
                    file.path,
                    quality: VideoQuality.LowQuality,
                    deleteOrigin: false,
                    includeAudio: true,
                  );
                  if (info != null){

                    setState(() {
                      _counter = "Successfully Compressed";
                      finalfile=File(info.path);
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
                      String url = "https://e4d283293d9e.ngrok.io/test";
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
                    }
                    catch (e) {
                      print(e);
                    }
                  }
                  else
                    print('Url empty');
                },
                child: Text('Select From Gallery') ),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(onPressed: (){ VideoCompress.cancelCompression();}, child: Text('Cancel')),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: EdgeInsets.all(30),
              child: TextField(
                maxLength: 15,
                onChanged: (value){
                  description=value;

                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

