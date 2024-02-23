import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_application/Util/utils.dart';
import 'package:firebase_application/view/Firestore%20Database/add_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Firestore_Screen extends StatefulWidget {
  const Firestore_Screen({super.key});

  @override
  State<Firestore_Screen> createState() => _Firestore_ScreenState();
}

class _Firestore_ScreenState extends State<Firestore_Screen> {
  @override
  final searchController=TextEditingController();
  final editController=TextEditingController();
  final add_firestore=FirebaseFirestore.instance.collection('Users').snapshots();
  CollectionReference ref=FirebaseFirestore.instance.collection('Users');



  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firestore Screen",style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,

        centerTitle: true,
      ),

      body: Column(children: [
        StreamBuilder<QuerySnapshot>(
            stream: add_firestore,
            builder: (BuildContext , AsyncSnapshot<QuerySnapshot> snapshot){
              if(snapshot.connectionState==ConnectionState)
                return CircularProgressIndicator();

              if(snapshot.hasError){
                return Text('Some Error');
              }

              return Expanded(
                child: ListView.builder(
                   itemCount: snapshot.data!.docs.length,
                    itemBuilder: (contex, index){
                    return ListTile(
                      trailing: PopupMenuButton(
                        icon: Icon(Icons.more_vert),
                        itemBuilder: (context)=>[
                          PopupMenuItem(
                              child:  ListTile(
                                onTap: (){

                                  ShowMyDilaog(
                                      snapshot.data!.docs[index]['title'].toString(),
                                      snapshot.data!.docs[index].id.toString(),

                                  );
                                },
                                title: Text('Edit'),
                                leading: Icon(Icons.edit),

                              )),

                          PopupMenuItem(
                              child:
                              ListTile(
                                onTap:(){
                                  ref.doc(snapshot.data!.docs[index].id.toString()).delete();
                      },
                            title: Text('Delete'),
                            leading: Icon(Icons.delete),
                          ))

                        ],
                      ),
                      title: Text(snapshot.data!.docs[index]['title'].toString()),
                      subtitle: Text(snapshot.data!.docs[index].id.toString())
                    );
                    }),
              );
            }


        )

      ],),


      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Get.to(AddFireStore_Screen());
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> ShowMyDilaog(String title, String id) async{

    return showDialog(
        context: context,
        builder: (Buildcontext){
          editController.text=title;
          return AlertDialog(
            title: Text('Update'),
            content: Container(
                child: TextField(
                  controller: editController,
                  decoration: InputDecoration(
                      hintText: 'Edit'
                  ),

                )),
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(context);
              },
                  child: Text('Cancel')
              ),
              TextButton(onPressed: (){
                Navigator.pop(context);
                ref.doc(id).update(
                  {
                    'title':editController.text.toLowerCase(),
                  }

                );
              },
                  child: Text('Update')
              )
            ],
          );
        });
  }
}
