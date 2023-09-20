import 'package:flutter/material.dart';
import 'dart:io';

class ShowImagePage extends StatelessWidget {
  final File imageFile;

  ShowImagePage({required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Viewer'),
      ),
      body: Center(
        child: Image.file(
          imageFile,
          // You can customize image properties like width, height, fit, etc.
          width: 300,
          height: 300,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
