import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nutritionapp/pages/profileSet.dart';

import 'home.dart';
class PlanPage extends StatefulWidget {
  @override
  _PlanPageState createState() => _PlanPageState();
}

class _PlanPageState extends State<PlanPage> {
  final _weightcontroller = TextEditingController();
  final _heightcontroller = TextEditingController();
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final _formKey = GlobalKey<FormState>();
  double? _weight;
  double? _height;
  String? _plan;
  String? _Gender;
  Future addUserDetails(String plan, String gender ,double height, double weight) async {

    final currentDate = DateTime.now();
    String Date = DateFormat('yyyy-MM-dd').format(currentDate);

    // Add user details to 'users' collection
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'plan': plan,
      'height': height,
      'Gender': gender,



    });
    // Add initial calories details to 'weight' collection
    final docRef = FirebaseFirestore.instance.collection('weight').doc(userId);
    final doc = await docRef.get();

    if (doc.exists) {
      await docRef.update({
        'date': Date,
        'weight': weight,
      });
    } else {
      await docRef.set({
        'date': Date,
        'weight': weight,
        'user_id': userId,
      });
    }
  }
  Map<String, String> myMap = {
    'Durable': '55% Carbs , 15% Protein , 30% Fat',
    'Athlete': '55% Carbs , 20% Protein , 25% Fat',
    'Cardio Training': '60% Carbs , 20% Protein , 20% Fat',
    'Heigh Protein': '50% Carbs , 25% Protein , 25% Fat',
    'Low Carb': '35% Carbs , 25% Protein , 40% Fat',
  };
  List<String> myGender = ["Male", "Female"];

  Future<void> sub() async {
      try {
        addUserDetails(_plan!, _Gender! ,double.parse(_heightcontroller.text.trim()), double.parse(_weightcontroller.text.trim()));
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MyHomePage(currentIndex: 1) ));
      }  catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }

  }
  void showTextPopup(BuildContext context, String title, String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(text),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
  void dispose(){
    _weightcontroller.dispose();
    _heightcontroller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MyHomePage(currentIndex: 0) ));
          },
        ),
        title: Text('Plan Page'),
        backgroundColor: Colors.grey[200],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ListView(
              children: [
                TextFormField(
                  controller: _weightcontroller,
                decoration:  InputDecoration(border: InputBorder.none,
                  labelText: 'Weight',
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(12)
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText:'weight',
                  fillColor: Colors.grey[50],
                  filled: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your weight';
                    }
                    _weight = double.tryParse(value);
                    if (_weight == null) {
                      return 'Please enter a valid weight';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _heightcontroller,
                  decoration:  InputDecoration(border: InputBorder.none,
                    labelText: 'Height',
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText:'height',
                    fillColor: Colors.grey[50],
                    filled: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your height';
                    }
                    _height = double.tryParse(value);
                    if (_height == null) {
                      return 'Please enter a valid height';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Gender',
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText:'Gender',
                    fillColor: Colors.grey[50],
                    filled: true,
                  ),
                  value: _Gender,
                  onChanged: (value) {
                    setState(() {
                      _Gender = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a Gender';
                    }
                    return null;
                  },
                  items: myGender.map((gender) {
                    return DropdownMenuItem<String>(
                      value: gender,
                      child: Text(gender),
                    );
                  }).toList(),
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Plan',
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText:'Plan',
                    fillColor: Colors.grey[50],
                    filled: true,

                  ),
                  value: _plan,
                  onChanged: (value) {
                    setState(() {
                      _plan = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a plan';
                    }
                    return null;
                  },
                  items: myMap.keys.map((plan) {
                    return DropdownMenuItem<String>(
                      value: plan,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(plan),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(myMap[_plan]?? ''),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: GestureDetector(
                    onTap: sub,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(color: Colors.deepPurple,borderRadius: BorderRadius.circular(15),),

                      child: Center(
                        child: Text('submit ',
                          style: TextStyle(color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,),
                        ),
                      ),
                    ),
                  ),
                ),

              ],
            ),


          ),
        ),

      ),

    );
  }
}