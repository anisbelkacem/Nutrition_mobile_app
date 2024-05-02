import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nutritionapp/pages/authpage.dart';

class PageEdit extends StatefulWidget {
  @override
  _PageEditState createState() => _PageEditState();
}

class _PageEditState extends State<PageEdit> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  void _fetchUser() async {
    final user = await _auth.currentUser;
    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit User Information'),
      ),
      body: _user == null
          ? Center(
        child: CircularProgressIndicator(),
      )
          : Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _user?.displayName,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value != null) {
                    return 'Please enter a name';
                  }
                  return null;
                },

              ),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _user!.updateDisplayName(_user!.displayName);
                    _fetchUser();
                  }
                },
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}