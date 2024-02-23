
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_application/Util/utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddFireStore_Screen extends StatefulWidget {
  const AddFireStore_Screen({super.key});

  @override
  State<AddFireStore_Screen> createState() => _AddFireStore_ScreenState();

}

class _AddFireStore_ScreenState extends State<AddFireStore_Screen> {
  bool isLoading= false;
  TextEditingController postController=TextEditingController();
  final add_firestore=FirebaseFirestore.instance.collection('Users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Post Screen',style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            TextFormField(
              controller: postController,
              decoration: const InputDecoration(
                  hintText: 'Have you any thing in your mind?',
                  border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 50.0), // Adjust the vertical padding

              ),
            ),


            const SizedBox(height: 50,),

            ElevatedButton(
                onPressed:(){
                  setState(() {
                    isLoading = true; // Set loading to true when button is pressed
                  });
                  postController;
                  String id=DateTime.now().microsecondsSinceEpoch.toString();
                   add_firestore.doc(id).set(
                     {
                       'title':postController.text.toString(),
                       'id':id,
                     }
                   ).then((value){
                     Utils().toastMessage('Posted Successfully ');
                   }).onError((error, stackTrace){
                     print(error.toString());
                     Utils().toastMessage(error.toString());
                   }).whenComplete(() {

                     setState(() {
                       isLoading = false; // Set loading to true when button is pressed
                     });
                   });

                },
                style: ElevatedButton.styleFrom(

                    minimumSize: const Size(550, 50)
                ),

                child: isLoading?CircularProgressIndicator(color: Colors.red,): Text('Post Submit',))
          ],
        ),
      ),
    );
  }
}
