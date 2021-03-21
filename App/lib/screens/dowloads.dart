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
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Text('Download Screen'),backgroundColor: Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),elevation: 0,),
      body: Center(
        child: Container(
            padding: const EdgeInsets.all(20.0),
            child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection(auth.currentUser.uid).snapshots(),
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(document['description']),
                                SizedBox(width: 20,),

                                ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(255, 188, 117, 1),) ),

                                    onPressed: (){
                                      print(document['pdf url1']);
                                      setState(() {
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Pdf(document['pdf url1'],document['description'])));
                                      });}, child: Text('Pdf 1')),

                                SizedBox(width: 5),

                                ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(255, 188, 117, 1),) ),
                                    onPressed: (){print(document['pdf url2']);setState(() {
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Pdf(document['pdf url2'],document['description'])));
                                      });}, child: Text('Pdf 2')),



                              ],
                            ),
                          ),
                        );
                      }).toList(),
                  );
                }
            ),),
      ),
    );
  }
}


