import 'dart:async';
import 'package:firebase/screens/Firestore/firestore_list_screen.dart';
import 'package:firebase/screens/auth/loginScreen.dart';
import 'package:firebase/screens/upload_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class SplashServices{

  void isLogin(BuildContext context){

    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    if(user!= null){
      Timer(const Duration(seconds: 3),
              ()=>Navigator.push(context,MaterialPageRoute(builder: (context)=>LoginScreen()))
      );
    }else {
      Timer(const Duration(seconds: 3),
              ()=>Navigator.push(context,MaterialPageRoute(builder: (context)=>LoginScreen()))
      );
    }
  }
}
