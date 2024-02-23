import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_application/Util/utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FilePickScreen extends StatefulWidget {
  const FilePickScreen({super.key});

  @override
  State<FilePickScreen> createState() => _FilePickScreenState();
}

class _FilePickScreenState extends State<FilePickScreen> {
  bool isLoading = false;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final databaseRef = FirebaseDatabase.instance.ref('Posts');

  File? _image;
  final picker = ImagePicker();
  Future GetImage() async {
    final pickfile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    if (pickfile != null) {
      _image = File(pickfile.path);
    } else {
      print("No Image has been picked ");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload an Image',
            style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: GestureDetector(
              onTap: () {
                print('Clicked');
                GetImage();
              },
              child: Container(
                height: 100,
                width: 100,
                child: _image != null
                    ? Image.file(_image!.absolute)
                    : Icon(Icons.image_rounded),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 4)),
              ),
            ),
          ),
          ElevatedButton(
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });

                firebase_storage.Reference ref =
                firebase_storage.FirebaseStorage.instance.ref('/Adeel/'+DateTime.now().millisecondsSinceEpoch.toString());
                firebase_storage.UploadTask uploadTask = ref.putFile(_image!.absolute);



                Future.value(uploadTask).then((value)async{

                  var newUrl = await ref.getDownloadURL();

                  databaseRef.child('1').set({
                    'id' : '1212' ,
                    'title' : newUrl.toString()
                  }).then((value){
                    setState(() {
                      isLoading = false ;
                    });
                    Utils().toastMessage('uploaded');

                  }).onError((error, stackTrace){
                    print(error.toString());
                    setState(() {
                      isLoading = false ;
                    });
                  });
                }).onError((error, stackTrace){
                  Utils().toastMessage(error.toString());
                  setState(() {
                    isLoading = false ;
                  });
                });
              },
              child: isLoading
                  ? CircularProgressIndicator()
                  : Text('Upload image'))
        ],
      ),
    );
  }
}
