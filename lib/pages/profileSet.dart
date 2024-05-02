import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nutritionapp/pages/planpage.dart';
import 'package:nutritionapp/pages/profilepage.dart';

import 'authpage.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? _userData;
  Map<String, dynamic>? _weightData;

  @override
  void initState() {
    super.initState();
    if (user!= null) {
      readUserDetails();
    } else {
      // Handle the case where the user is not logged in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Authpage()),
      );
    }
  }

  Future<void> readUserDetails() async {
    final userId = user!.uid;
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
    final userSnapshot = await userDoc.get();
    if (userSnapshot.exists) {
      final userData = userSnapshot.data() as Map<String, dynamic>;
      print('User data: $userData');
      setState(() {
        _userData = userData;
      });

      final weightDoc = FirebaseFirestore.instance.collection('weight').where('user_id', isEqualTo: userId).orderBy('date', descending: true).limit(1);
      final weightSnapshot = await weightDoc.get();
      print('Weight snapshot: $weightSnapshot'); // print the weight snapshot
      if (weightSnapshot.docs.isNotEmpty) {
        final weightData = weightSnapshot.docs.first.data() as Map<String, dynamic>;
        print('Weight data: $weightData');
        setState(() {
          _weightData = weightData;
        });
      } else {
        setState(() {
          _weightData = null;
        });
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    if(_userData== null)
      {
        return Scaffold(
          backgroundColor: Colors.grey[200], // Add this line
          body: Center(
            child: CircularProgressIndicator(),),);
      }else
        {
          if (_weightData == null &&  _userData!['plan'] == null) {
            return PlanPage();
          } else {
            return ProfilePage();
          }
        }
  }
}
