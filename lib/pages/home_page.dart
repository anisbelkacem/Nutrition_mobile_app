//import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:nutritionapp/pages/authpage.dart';
import  'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}


class _HomepageState extends State<Homepage> {
  final user= FirebaseAuth.instance.currentUser!;

  File? _imageFile;
  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path); // Store the picked image file
      });
    }
  }
  Future<void> _pickImageFromCamera() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path); // Store the picked image file
      });
    }
  }

  int calculateAge(String birthdate) {
    final birthDate = DateFormat("yyyy-MM-dd").parse(birthdate);
    final today = DateTime.now();
    var age = today.year - birthDate.year;

    if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }

    return age;
  }
  double calculateBMR(bool isMale, double weight, double height, int age) {
    if (isMale) {
      return 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age);
    } else {
      return 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age);
    }
  }
  void _showPicker(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: new Icon(Icons.photo_library),
                  title: new Text('Photo Library'),
                  onTap: () {
                    _pickImageFromGallery();
                    //Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text('Camera'),
                  onTap: () {
                    _pickImageFromCamera();
                    //Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      if (_imageFile!= null) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content:Container(
                width: 500,
                height: 500,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  image: _imageFile!= null
                      ? DecorationImage(image: FileImage(_imageFile!)) : null,
                ),
              ),
                actions: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // Change the background color to orange
                    ),
                    child: Text('Validate'),
                    onPressed: () {
                      // Add your validation logic here
                      print('Image validated');
                      Navigator.of(context).pop();
                    },
                  ),
                ]
            );
          },
        );
      }
    });
  }
  Future<void> readUserDetails() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
    final userSnapshot = await userDoc.get();
    if (userSnapshot.exists) {
      final userData = userSnapshot.data() as Map<String, dynamic>;
      print('User data: $userData');

      final weightDoc = FirebaseFirestore.instance.collection('weight').where('user_id', isEqualTo: userId).orderBy('date', descending: true).limit(1);
      final weightSnapshot = await weightDoc.get();
      if (weightSnapshot.docs.isNotEmpty) {
        final weightData = weightSnapshot.docs.first.data() as Map<String, dynamic>;
        print('Weight data: $weightData');
      }

      final caloriesDoc = FirebaseFirestore.instance.collection('calories').where('user_id', isEqualTo: userId).orderBy('date', descending: true).limit(1);
      final caloriesSnapshot = await caloriesDoc.get();
      if (caloriesSnapshot.docs.isNotEmpty) {
        final caloriesData = caloriesSnapshot.docs.first.data() as Map<String, dynamic>;
        print('Calories data: $caloriesData');
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor:  Colors.grey[200],
      body:  SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      '  Today',
                      style :TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      '   You can still eat 2156 calories',
                      style :TextStyle( fontSize: 15),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(height: 10,),
                LinearPercentIndicator(
                  animationDuration: 900,
                  animation: true,
                  lineHeight: 15,
                  percent: 0.7,
                  progressColor: Colors.grey[700],
                  backgroundColor: Colors.grey[350],
                  barRadius: const Radius.circular(25),
                ),
                  SizedBox(height: 10,),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      '   2365 calories eaten',
                      style :TextStyle( fontSize: 15),
                      textAlign: TextAlign.left,
                    ),
                  ),
                SizedBox(height: 50,),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //SizedBox(width:50,),
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            child: CircularPercentIndicator(radius: 50,
                              animationDuration: 1000,
                              animation: true,
                              lineWidth: 15,
                              percent: 0.3,
                              progressColor: Colors.deepPurple,
                              backgroundColor: Colors.lightBlue.shade100,
                              circularStrokeCap: CircularStrokeCap.round,
                              center: Text('Carbs', style: TextStyle(fontSize: 15),),
                            ),
                          ),
                        ),
                      ),
                      //SizedBox(width:20,),
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            child: CircularPercentIndicator(radius: 50,
                              animationDuration: 1000,
                              animation: true,
                              lineWidth: 15,
                              percent: 0.7,
                              progressColor: Colors.green,
                              backgroundColor: Colors.lightGreen.shade100,
                              circularStrokeCap: CircularStrokeCap.round,
                              center: Text('Protein', style: TextStyle(fontSize: 15),),
                            ),
                          ),
                        ),
                      ),
                      //SizedBox(width:20,),
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            child: CircularPercentIndicator(radius: 50,
                              lineWidth: 15,
                              percent: 0.6,
                              progressColor: Colors.red,
                              backgroundColor: Colors.pink.shade100,
                              circularStrokeCap: CircularStrokeCap.round,
                              center: Text('Fat', style: TextStyle(fontSize: 15),),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                  SizedBox(height: 20,),
                  DottedBorder(
                    color: Colors.black,
                    strokeWidth: 2,
                    dashPattern: [10, 5],
                    child: Container(
                      height: 350,
                      width: size.width,
                      //color: Colors.blue,
                      ),
                ),
                ],

              ),

            )
        ),
        )

    ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showPicker(context);
          },
          shape: CircleBorder(), // Change the shape to a circle
          backgroundColor: Colors.grey, // Change the color to red
          child: Icon(Icons.add),
        )
    );
  }
}
