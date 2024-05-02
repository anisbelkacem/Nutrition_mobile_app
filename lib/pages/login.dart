import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nutritionapp/pages/Mainpage.dart';
import 'package:nutritionapp/pages/home_page.dart';
import 'package:nutritionapp/firebase_options.dart';

import 'home.dart';

class Login extends StatefulWidget{
  final VoidCallback showRegisterPage;
  const Login({Key? key, required this.showRegisterPage}): super(key: key);
  @override
  State<Login> createState() => _loginstate();
}
class _loginstate extends State<Login>{
  final _emailcontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();
  Future signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailcontroller.text.trim(),
        password: _passwordcontroller.text.trim(),
      );
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> Mainpage()));
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'Invalid email address.';
          break;
        case 'user-disabled':
          errorMessage = 'Your account is disabled.';
          break;
        case 'user-not-found':
          errorMessage = 'No user found with this email address.';
          break;
        case 'wrong-password':
          errorMessage = 'Invalid password.';
          break;
        case 'network-request-failed':
          errorMessage = 'Network error: $e';
          break;
        default:
          errorMessage = 'Error signing in: $e';
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }

  @override
  void dispose(){
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor:  Colors.grey[150],
      body:  SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.food_bank_outlined, size: 120,),
                SizedBox(height: 75,),
                //Hello again !
                Text('Hello Again',
                  style: GoogleFonts.bebasNeue(
                    fontSize:52,
                  ),
                ),
                SizedBox(height: 10),
                Text('Welcome back, you\'ve been missed', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                SizedBox(height: 50),
                //email textfield
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
            
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left : 0.0),
                      child: TextField(
                        controller: _emailcontroller,
                        decoration:  InputDecoration(border: InputBorder.none,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(12)
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.deepPurple),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          hintText:'Email',
                          fillColor: Colors.grey[200],
                          filled: true,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                //password textfield
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
            
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left : 0.0),
                      child: TextField(
                        controller: _passwordcontroller,
                        obscureText: true,
                        decoration:  InputDecoration(border: InputBorder.none,
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(12)
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.deepPurple),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          hintText:'Password',
                          fillColor: Colors.grey[200],
                          filled: true,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                //login buttom
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: GestureDetector(
                    onTap: signIn,
                    child: Container(
                      padding: EdgeInsets.all(25),
                      decoration: BoxDecoration(color: Colors.deepPurple,borderRadius: BorderRadius.circular(15),),
                                
                      child: Center(
                        child: Text('Sign In ',
                        style: TextStyle(color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Not a member?',style: TextStyle(fontWeight: FontWeight.bold,)),
                    GestureDetector(
                        onTap: widget.showRegisterPage,
                        child: Text('  Register now', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold,) ,)),
                  ],
                ),
                //register now
              ],
            ),
          ),
        ),
      ),
    );
  }
}