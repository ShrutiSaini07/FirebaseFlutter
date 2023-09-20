import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({Key? key}) : super(key: key);

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  bool loading = false;
  File? _image;
  final picker = ImagePicker();

  double uploadProgress = 0.0; // Track the upload progress

  Future getImageGallery() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('no image picked');
      }
    });
  }

  Future<void> listImagesInStorage() async {
    try {
      firebase_storage.ListResult listResult =
      await firebase_storage.FirebaseStorage.instance.ref('shruti/').listAll();
      List<String> imageUrls = [];

      for (var item in listResult.items) {
        var url = await item.getDownloadURL();
        imageUrls.add(url);
      }

      // Now, you can navigate to a page to display the list of images
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ShowImagesPage(imageUrls: imageUrls),
        ),
      );
    } catch (e) {
      print('Error listing images: $e');
    }
  }

  Future<void> uploadImageToStorage() async {
    if (_image != null) {
      try {
        setState(() {
          loading = true;
        });

        firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref('shruti/${DateTime.now().millisecondsSinceEpoch.toString()}');

        final task = ref.putFile(_image!);

        // Listen for changes in the task to track the upload progress
        task.snapshotEvents.listen((firebase_storage.TaskSnapshot snapshot) {
          setState(() {
            uploadProgress = (snapshot.bytesTransferred / snapshot.totalBytes);
          });
        });

        // Wait for the upload to complete
        await task;

        setState(() {
          loading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Image uploaded successfully!'),
            duration: Duration(seconds: 2),
          ),
        );
      } catch (e) {
        print('Error uploading image: $e');
        setState(() {
          loading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No image selected.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Upload Images',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: InkWell(
                onTap: () {
                  getImageGallery();
                },
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                    ),
                  ),
                  child: _image != null
                      ? Image.file(_image!)
                      : Center(child: Icon(Icons.image)),
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 100,
              child: ElevatedButton(
                onPressed: () {
                  uploadImageToStorage(); // Call the function to upload the image
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  primary: Colors.orange,
                ),
                child: Text(
                  'Upload',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 150,
              child: ElevatedButton(
                onPressed: () {
                  listImagesInStorage(); // Call the function to list images
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  primary: Colors.orange[600],
                ),
                child: Text(
                  'Show Images',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Progress bar to show upload progress
            if (loading)
              LinearProgressIndicator(
                value: uploadProgress,
                minHeight: 10,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
              ),
          ],
        ),
      ),
    );
  }
}

class ShowImagesPage extends StatelessWidget {
  final List<String> imageUrls;

  ShowImagesPage({required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Gallery'),
      ),
      body: ListView.builder(
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Image.network(imageUrls[index]),
          );
        },
      ),
    );
  }
}
