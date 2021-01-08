import 'dart:io' as io;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _key = GlobalKey<FormState>();
  String workshopName = '';
  String ownerName = '';
  String contactNo = '';
  String address = '';
  String gst = '';
  io.File sampleImage;
  bool loading = false;
  String url;
  bool uploaded = false;
  Future getImage() async {
    // ignore: deprecated_member_use
    var tempImage = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      sampleImage = tempImage;
    });
  }

  bool validateandsave() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else
      return false;
  }

  String _validateGst(String value) {
    if (value.isEmpty) {
      return "Enter GSTIN number";
    }
    Pattern pattern =
        "^[0-9]{2}[a-zA-Z]{5}[0-9]{4}[a-zA-Z]{1}[1-9a-zA-Z]{1}Z[0-9a-zA-Z]{1}";
    RegExp regex = new RegExp(pattern);

    if (regex.hasMatch(value)) {
      return null;
    }
    return "GSTIN not valid";
  }

  uploadform() async {
    if (validateandsave()) {
      var timekey = DateTime.now();
      FirebaseStorage firebaseStorage = FirebaseStorage.instance;
      Reference reference = firebaseStorage
          .ref()
          .child('workshops')
          .child(timekey.toString() + '.jpg');
      await reference.putFile(sampleImage);
      String imageUrl = await reference.getDownloadURL();
      saveToDatabse(imageUrl);
    }
    setState(() {
      loading = false;
      uploaded = true;
    });
  }

  saveToDatabse(String url) {
    DatabaseReference dbreference = FirebaseDatabase.instance.reference();
    var data = {
      "image": url,
      "workshopname": workshopName,
      "ownername": ownerName,
      "contactNo": contactNo,
      "address": address,
      "gst IN": gst
    };
    dbreference.child("workshops").push().set(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Panel"),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
          key: _key,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    textAlign: TextAlign.justify,
                    decoration: InputDecoration(
                      labelText: "Workshop Name",
                      labelStyle: TextStyle(
                          fontFamily: 'Comfortaa',
                          fontSize: 15.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.0),
                      ),
                    ),
                    validator: (val) => val.isEmpty ? 'Entry Missing' : null,
                    onChanged: (val) {
                      setState(() {
                        workshopName = val;
                      });
                    }),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    textAlign: TextAlign.justify,
                    decoration: InputDecoration(
                      labelText: "Owner Name",
                      labelStyle: TextStyle(
                          fontFamily: 'Comfortaa',
                          fontSize: 15.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.0),
                      ),
                    ),
                    validator: (val) => val.isEmpty ? 'Entry Missing' : null,
                    onChanged: (val) {
                      setState(() {
                        ownerName = val;
                      });
                    }),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    textAlign: TextAlign.justify,
                    decoration: InputDecoration(
                      labelText: "Contact no.",
                      labelStyle: TextStyle(
                          fontFamily: 'Comfortaa',
                          fontSize: 15.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.0),
                      ),
                    ),
                    validator: (val) => val.isEmpty ? 'Entry Missing' : null,
                    onChanged: (val) {
                      setState(() {
                        contactNo = val;
                      });
                    }),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    textAlign: TextAlign.justify,
                    decoration: InputDecoration(
                      labelText: "Address",
                      labelStyle: TextStyle(
                          fontFamily: 'Comfortaa',
                          fontSize: 15.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.0),
                      ),
                    ),
                    validator: (val) => val.isEmpty ? 'Entry Missing' : null,
                    onChanged: (val) {
                      setState(() {
                        address = val;
                      });
                    }),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    textAlign: TextAlign.justify,
                    decoration: InputDecoration(
                      labelText: "GST IN",
                      labelStyle: TextStyle(
                          fontFamily: 'Comfortaa',
                          fontSize: 15.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.0),
                      ),
                    ),
                  //  validator: _validateGst,
                    onChanged: (val) {
                      setState(() {
                        gst = val;
                      });
                    }),
              ),
              SizedBox(
                height: 20.0,
              ),
              if (sampleImage == null) ...[
                FlatButton(
                  child: Text("take photo"),
                  onPressed: getImage,
                ),
              ] else ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(Icons.done_outlined), Text("Photo Taken")],
                )
              ],

              // FlatButton(
              //   child: Text("take photo"),
              //   onPressed: getImage,
              // ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: RaisedButton(
                  child: Container(
                    width: 110.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (loading == true) ...[
                          Container(
                              width: 15.0,
                              height: 15.0,
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.black,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ))
                        ],
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          'Submit',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                  textColor: Colors.grey[50],
                  onPressed: () {
                    uploadform();
                    setState(() {
                      loading = true;
                    });
                  },
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0)),
                  color: Colors.green,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),

              if (uploaded == true) ...[
                Text("Upload Completed"),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
