import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nutritionapp/pages/login.dart';
import 'package:nutritionapp/pages/signUp.dart';

class Authpage extends StatefulWidget {
  const Authpage({super.key});

  @override
  State<Authpage> createState() => _AuthpageState();
}

class _AuthpageState extends State<Authpage> {

  // initially ,show loginpage
  bool showLoginpage = true;
  void toggleScreens() {
    setState(() {
      showLoginpage = !showLoginpage;
    });
  }
  @override
  Widget build(BuildContext context) {
    /*return Scaffold(
      body: StreamBuilder<User?>(
          stream:FirebaseAuth.instance.authStateChanges(),
          builder :(context,snapshot){
            if (FirebaseAuth.instance.currentUser==null){
              return const Login(showRegisterPage : toggleScreens);
          }else
          {
          return const RegisterPage(showloginPage: toggleScreens);
          }
          }

      )
      ,
    );*/
    if(showLoginpage){
      return Login(showRegisterPage : toggleScreens );
    }else{
      return RegisterPage( showloginPage: toggleScreens);

    };
  }
}
