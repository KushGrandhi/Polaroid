import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:polaroid/screens/PDFView.dart';
class Downloads extends StatefulWidget {
  @override
  _DownloadsState createState() => _DownloadsState();
}

class _DownloadsState extends State<Downloads> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          padding: const EdgeInsets.all(20.0),
          child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('3').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                if(!snapshot.hasData){
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView(
                    children: snapshot.data.docs.map((document) {
                      return Container(
                        height: 100,
                        child: Card(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(document['description']),
                              Container(
                                child: Row(
                                  children: [
                                    ElevatedButton(onPressed: (){print(document['pdf url1']);setState(() {
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Pdf(document['pdf url1'],document['description'])));
                                    });}, child: Icon(Icons.download_rounded)),
                                    ElevatedButton(onPressed: (){print(document['pdf url2']);setState(() {
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Pdf(document['pdf url2'],document['description'])));
                                    });}, child: Icon(Icons.download_rounded)),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                );
              }
          ),),
    );
  }
}


