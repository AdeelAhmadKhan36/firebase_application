import 'package:firebase_application/Util/utils.dart';
import 'package:firebase_application/view/Realtime_%20Database/posts/add_post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Post_Screen extends StatefulWidget {
  const Post_Screen({super.key});

  @override
  State<Post_Screen> createState() => _Post_ScreenState();
}

class _Post_ScreenState extends State<Post_Screen> {
  @override
  final searchController=TextEditingController();
  final editController=TextEditingController();
  final _auth=FirebaseAuth.instance;
  final ref=FirebaseDatabase.instance.ref('Posts');

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post Screen",style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,

        centerTitle: true,
      ),

      body: Column(children: [

        //There are Two methods to getting data from the Realtime Database
        //One is Through Streambuilder
        //Other is Through FirebaseAnimatedList

        // Expanded(
        //     child:StreamBuilder(
        //       stream: ref.onValue,
        //       builder: (context,AsyncSnapshot<DatabaseEvent> snapshot){
        //         //Get dynamic data into List so for
        //
        //         if(!snapshot.hasData){
        //            return CircularProgressIndicator();
        //         }else{
        //
        //           Map<dynamic , dynamic> map=snapshot.data!.snapshot.value as dynamic;
        //           List<dynamic> list =[];
        //           list.clear();
        //           list=map.values.toList();
        //
        //
        //           return ListView.builder(
        //             itemCount: snapshot.data!.snapshot.children.length,
        //               itemBuilder:(context,index){
        //                 return ListTile(
        //                   title: Text(list[index]['title']),
        //                   subtitle: Text(list[index]['id'].toString()),
        //
        //                 );
        //               });
        //
        //         }
        //       },
        //     )
        // ),

         Padding(
           padding: const EdgeInsets.all(20),
           child: TextFormField(
             controller: searchController,
             decoration: InputDecoration(
                 hintText: 'Search',
               border:OutlineInputBorder(
                borderSide: BorderSide(width: 5)
               ),

             ),
             onChanged: (String value){
               setState(() {

               });
             },
           ),
         ),
        Expanded(
          child: FirebaseAnimatedList(
              query: ref,
              defaultChild: Text('Loading'),
              itemBuilder: (context, snapshot ,animation, index)
              {
                final title=snapshot.child('title').value.toString();

                if(searchController.text.isEmpty){
                  return ListTile(
                    trailing:PopupMenuButton(
                      
                      icon: Icon(Icons.more_vert),
                      itemBuilder: (context)=>[
                        PopupMenuItem(
                          value: 1,
                             child: ListTile(
                               onTap: (){
                                 ShowMyDilaog(title,snapshot.child('id').value.toString() );
                               },
                              title: Text('Edit'),
                              leading: Icon(Icons.edit),
                            )),
                        PopupMenuItem(
                          value: 2,
                            child:ListTile(
                              onTap: (){
                                Navigator.pop(context);

                                ref.child(snapshot.child('id').value.toString()).remove();
                              },
                              title: Text('Delete'),
                              leading: Icon(Icons.delete),
                            ) )
                      ],
                    ),
                    title: Text(snapshot.child('title').value.toString()),
                    subtitle: Text(snapshot.child('id').value.toString()),

                  );

                }else if(title.toLowerCase().contains(searchController.text.toLowerCase().toString())){
                  return ListTile(
                      title: Text(snapshot.child('title').value.toString()),
                      subtitle: Text(snapshot.child('id').value.toString()),
                  );
                }else{
                  return Container();
                }

              }),
        )
      ],),


      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Get.to(add_postScreen());
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

            ref.child(id).update({
              'title':editController.text.toLowerCase()
            }).then((value) {
              Utils().toastMessage('Post Updated Sucessfully');

            }).onError((error, stackTrace) {
              Utils().toastMessage(error.toString());
            });
          },
              child: Text('Update')
          )
        ],
      );
  });
  }
}
