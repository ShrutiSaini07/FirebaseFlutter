import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/screens/Firestore/Add_FireStore_Data.dart';
import 'package:flutter/material.dart';
import 'package:firebase/screens/auth/loginScreen.dart';
import 'package:firebase/screens/posts/add_post.dart';
import 'package:firebase/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class FireStoreScreen extends StatefulWidget {
  const FireStoreScreen({super.key});

  @override
  State<FireStoreScreen> createState() => _FireStoreScreenState();
}

class _FireStoreScreenState extends State<FireStoreScreen> {

  final auth = FirebaseAuth.instance;
  final editController = TextEditingController();
  final firestore = FirebaseFirestore.instance.collection('user').snapshots();
  CollectionReference ref = FirebaseFirestore.instance.collection('user');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'FireStore Screen',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              auth.signOut().then((value) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              }).onError((error, stackTrace) {
                Utils().toastMessage(error.toString());
              });
            },
            icon: Icon(
              Icons.logout_outlined,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: firestore,
              builder: (BuildContext contex , AsyncSnapshot<QuerySnapshot> snapshot){

                if(snapshot.connectionState == ConnectionState.waiting)
                  return CircularProgressIndicator();

                if(snapshot.hasError){
                  return Text('Some Error');
                }
                return Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context,index){
                        return ListTile(
                          onTap: (){
                            ref.doc(snapshot.data!.docs[index]['id'].toString()).update({
                                  'title' : 'Shruti'
                            }).then((value){
                              Utils().toastMessage('updated');
                            }).onError((error, stackTrace){
                                Utils().toastMessage(error.toString());
                            });

                            ref.doc(snapshot.data!.docs[index]['id'].toString()).delete();
                          },

                          title: Text(snapshot.data!.docs[index]['title'].toString()),
                          subtitle: Text(snapshot.data!.docs[index]['id'].toString()),
                        );
                      }
                  ),
                );
              }
          ),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddFirestoreScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> showMyDialog(String title, String id) async {

    editController.text = title;

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Update'),
            content: Container(
              child: TextField(
                controller: editController,
                decoration: InputDecoration(
                    hintText: 'Edit'
                ),
              ),
            ),
            actions: [
              TextButton(onPressed : (){
                Navigator.pop(context);
              },child: Text('Cancel'),),
              TextButton(onPressed : (){
                Navigator.pop(context);
              },child: Text('Update'),
              ),
            ],
          );
        });
  }
}
