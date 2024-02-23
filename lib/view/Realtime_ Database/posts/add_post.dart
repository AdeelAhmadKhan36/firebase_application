import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class add_postScreen extends StatefulWidget {
  const add_postScreen({super.key});

  @override
  State<add_postScreen> createState() => _add_postScreenState();

}

class _add_postScreenState extends State<add_postScreen> {

  TextEditingController postController=TextEditingController();


  final databaseRef=FirebaseDatabase.instance.ref('Posts');


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Post Screen',style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            TextFormField(
              controller: postController,
              decoration: InputDecoration(
                hintText: 'Have you any thing in your mind?',
                border: OutlineInputBorder()
              ),
            ),


            SizedBox(height: 50,),

            ElevatedButton(
                onPressed: (){
                  postController;
               String id=DateTime.now().microsecondsSinceEpoch.toString();
              databaseRef.child(id).set(
                {
                  'id':id,
                  'title':postController.text.toString()
                }
              )  ;

            },
                style: ElevatedButton.styleFrom(

                  minimumSize: Size(550, 50)
                ),

                child: Text('Post Submit'))
          ],
        ),
      ),
    );
  }
}
