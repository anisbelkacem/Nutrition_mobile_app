import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nutritionapp/pages/authpage.dart';
import 'package:nutritionapp/pages/home.dart';
import 'package:intl/intl.dart';
import 'Mainpage.dart';
import 'components/dialog.dart';
class RegisterPage extends StatefulWidget {
  final VoidCallback showloginPage;


  const RegisterPage({Key? key , required this.showloginPage}) : super(key:key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailcontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();
  final _confpasswordcontroller = TextEditingController();
  final _firstNamecontroller = TextEditingController();
  final _lastNamecontroller = TextEditingController();
  final _agecontroller = TextEditingController();
  @override
  void dispose(){
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    _confpasswordcontroller.dispose();
    _firstNamecontroller.dispose();
    _lastNamecontroller.dispose();
    _agecontroller.dispose();
    super.dispose();
  }
  Future addUserDetails(String firstName, String lastName, String email, String age) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final currentDate = DateTime.now();
    String Date = DateFormat('yyyy-MM-dd').format(currentDate);

    // Add user details to 'users' collection
    await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'first name': firstName,
      'last name': lastName,
      'email': email,
      'date of birth': age,
      'height' : 0 ,

    });

    // Add initial calories details to 'calories' collection
    final docRef = FirebaseFirestore.instance.collection('weight').doc(userId);
    final doc = await docRef.get();

    if (doc.exists) {
      await docRef.update({
        'fat': 0,
        'carbs': 0,
        'date': Date,
        'protein': 0,
        'tot_cal': 0,
      });
    } else {
      await docRef.set({
        'fat': 0,
        'carbs': 0,
        'date': Date,
        'user_id': userId,
        'protein': 0,
        'tot_cal': 0,
      });
    }
  }
  Future <void> selectDate()async {
    DateTime? _picker= await showDatePicker(context: context, firstDate: DateTime(1990), lastDate: DateTime(2024));
    if(_picker !=null ){
      setState(() {
        _agecontroller.text= _picker.toString().split(" ")[0];
      });

    }
  }
  bool passwordconfirmed(){
    if(_passwordcontroller.text.trim()==_confpasswordcontroller.text.trim())
    {
      return true;
    }else return false;
  }
  Future<void> signUp() async {
    if (passwordconfirmed()) {
      try {

        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailcontroller.text.trim(),
          password: _passwordcontroller.text.trim(),
        );
        addUserDetails(
          _firstNamecontroller.text.trim(),
          _lastNamecontroller.text.trim(),
          _emailcontroller.text.trim(),
          _agecontroller.text.trim(),
        );
         Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Mainpage()));
      } on FirebaseAuthException catch (exception) {
        _showErrorDialog(context, exception.code);
      } catch (e) {
        _showErrorDialog(context, e.toString());
      }
    }
  }

  void _showErrorDialog(BuildContext context, String error) {
    String message;
    switch (error) {
      case 'weak-password':
        message = 'Please choose a stronger password.';
        break;
      case 'email-already-in-use':
        message = 'An account already exists with this email address.';
        break;
      case 'invalid-email':
        message = 'Invalid email, please check your email and try again.';
        break;
      case 'too-many-requests':
        message = 'A problem occurred, Please try again later.';
        break;
      default:
        message = 'Sorry, something went wrong.';
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor:  Colors.grey[150],
      body:  SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Icon(Icons.android, size: 100,),
                //SizedBox(height: 40,),
                //Hello again !
                Text('Hello There',
                  style: GoogleFonts.bebasNeue(
                    fontSize:52,
                  ),
                ),
                SizedBox(height: 10),
                Text('Register below with your details!', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                SizedBox(height: 30),

                // first name
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
                        controller: _firstNamecontroller,
                        decoration:  InputDecoration(border: InputBorder.none,
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(12)
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.deepPurple),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          hintText:'First Name',
                          fillColor: Colors.grey[200],
                          filled: true,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                // last name
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
                        controller: _lastNamecontroller,
                        decoration:  InputDecoration(border: InputBorder.none,
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(12)
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.deepPurple),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          hintText:'Last Name',
                          fillColor: Colors.grey[200],
                          filled: true,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
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
                        controller: _agecontroller,
                        decoration:  InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(12)
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.deepPurple),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          hintText:'Date of birth',
                          fillColor: Colors.grey[200],
                          filled: true,
                        ),
                        onTap: (){
                          selectDate();
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
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
                        controller: _confpasswordcontroller,
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
                          hintText:'Confirm Password',
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
                    onTap: signUp ,
                    child: Container(
                      padding: EdgeInsets.all(25),
                      decoration: BoxDecoration(color: Colors.deepPurple,borderRadius: BorderRadius.circular(15),),

                      child: Center(
                        child: Text('Sign up ',
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
                        onTap: widget.showloginPage,
                        child: Text('  Login now', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold,) ,)),
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
