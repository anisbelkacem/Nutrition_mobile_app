import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import '../pages/authpage.dart';
import 'home.dart';

class Mainpage extends StatelessWidget{
  const Mainpage({Key? key}): super(key:key);
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            return MyHomePage(currentIndex: 0); // or any other index you want
          }else{
            return Authpage();
          }
        }
      )
    );
  }
}
