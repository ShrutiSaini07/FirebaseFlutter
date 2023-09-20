import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/utils/utils.dart';
import 'package:firebase/widgets/roundButton.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddFirestoreScreen extends StatefulWidget {
  const AddFirestoreScreen({super.key});

  @override
  State<AddFirestoreScreen> createState() => _AddFirestoreScreenState();
}

class _AddFirestoreScreenState extends State<AddFirestoreScreen> {
  bool loading = false;
  final postController = TextEditingController();
  final firestore = FirebaseFirestore.instance.collection('user');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Firestore Date',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            TextFormField(
              maxLines: 4,
              controller: postController,
              decoration: InputDecoration(
                  hintText: 'Sync your memory here !!!',
                  border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 30,
            ),
            RoundButtton(
                title: 'Add',
                loading: loading,
                onTap: () {
                  setState(() {
                    loading = true;
                  });

                  String id = DateTime.now().millisecondsSinceEpoch.toString();
                  firestore.doc(id).set({
                    'title' : postController.text.toString(),
                     'id' : id

                  }).then((value){
                    setState(() {
                      loading = false;
                    });
                    Utils().toastMessage('post added');
                  }).onError((error, stackTrace){
                    Utils().toastMessage(error.toString());
                  });

                })
          ],
        ),
      ),
    );
  }
}
