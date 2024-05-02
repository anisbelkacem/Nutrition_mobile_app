import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nutritionapp/pages/authpage.dart';

import 'editpage.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  Map<String, dynamic>? _userData;
  Map<String, dynamic>? _weightData;
  Map<String, dynamic>? _caloriesData;

  Future<void> readUserDetails() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
    final userSnapshot = await userDoc.get();
    if (userSnapshot.exists) {
      final userData = userSnapshot.data() as Map<String, dynamic>;
      print('User data: $userData');
      setState(() {
        _userData = userData;
      });

      /*final weightDoc = FirebaseFirestore.instance.collection('weight').where('user_id', isEqualTo: userId).orderBy('date', descending: true).limit(1);
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
      }*/

    }
  }

  @override
  void initState() {
    super.initState();
    readUserDetails();
  }

  @override

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
          titleSpacing: 50,
        title: Text('Settings'),
        backgroundColor: Colors.grey[200],
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => Authpage()),
                );
              },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FutureBuilder(
          future: readUserDetails(),
          builder: (context, snapshot) {
            if ( _userData!= null ) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 90,
                      backgroundImage: AssetImage('assets/images/profil.png'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 10),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                // Add code to upload image here
                                print('Upload image');
                              },
                              child: Text('Upload'),
                            ),
                            SizedBox(height: 10),
                            TextButton(
                              onPressed: () {
                                // Add code to remove image here
                                print('Remove image');
                              },
                              child: Text('Remove'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            ListTile(
                              leading: Icon(Icons.person),
                              title: Text('First Name: ${_userData!['first name']}'),
                              trailing: IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  TextEditingController controller = TextEditingController(text: _userData!['first name']);
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Edit First Name'),
                                        content: TextFormField(
                                          controller: controller,
                                          onChanged: (value) {
                                            // Update the _userData variable here with the new first name value
                                            _userData!['first name'] = value;
                                          },
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('CANCEL'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                      TextButton(
                                            child: Text('SAVE'),
                                            onPressed: () async {
                                              // Update the _userData variable here with the new first name value
                                              await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
                                                'first name': controller.text,
                                              }).then((_) {
                                                // Add code here to refresh the UI with the updated _userData
                                                setState(() {
                                                  _userData = {
                                                    'first name': controller.text,
                                                    // Add other user data properties here
                                                  };
                                                });
                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User updated successfully')));
                                              }).catchError((error) {
                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating user: $error')));
                                              });
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                            ListTile(
                              leading: Icon(Icons.person),
                              title: Text('Last Name: ${_userData!['last name']}'),
                              trailing: IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  TextEditingController controller = TextEditingController(text: _userData!['last name']);
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Edit Last Name'),
                                        content: TextFormField(
                                          controller: controller,
                                          onChanged: (value) {
                                            // Update the _userData variable here with the new first name value
                                            _userData!['last name'] = value;
                                          },
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('CANCEL'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: Text('SAVE'),
                                            onPressed: () async {
                                              // Update the _userData variable here with the new first name value
                                              await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
                                                'last name': controller.text,
                                              }).then((_) {
                                                // Add code here to refresh the UI with the updated _userData
                                                setState(() {
                                                  _userData = {
                                                    'last name': controller.text,
                                                    // Add other user data properties here
                                                  };
                                                });
                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User updated successfully')));
                                              }).catchError((error) {
                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating user: $error')));
                                              });
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                            ListTile(
                              leading: Icon(Icons.email),
                              title: Text('Email: ${_userData!['email']}'),
                            ),
                            ListTile(
                              leading: Icon(Icons.cake),
                              title: Text('date of birth: ${_userData!['date of birth']}'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    /*Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ListTile(
                          leading: Icon(Icons.scale),
                          title: Text('Weight: ${_weightData!['weight']}'),
                        ),
                      ),
                    ),*/
                    /*SizedBox(height: 10),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            ListTile(
                              leading: Icon(Icons.food_bank),
                              title: Text('Fat: ${_caloriesData!['fat']}'),
                            ),
                            ListTile(
                              leading: Icon(Icons.food_bank),
                              title: Text('Carbs: ${_caloriesData!['carbs']}'),
                            ),
                            ListTile(
                              leading: Icon(Icons.food_bank),
                              title: Text('Protein: ${_caloriesData!['protein']}'),
                            ),
                            ListTile(
                              leading: Icon(Icons.food_bank),
                              title: Text('Total Calories: ${_caloriesData!['tot_cal']}'),
                            ),
                          ],
                        ),
                      ),
                    ),*/
                  ],
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}