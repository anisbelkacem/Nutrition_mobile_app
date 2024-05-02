import 'package:flutter/material.dart';
import 'package:nutritionapp/pages/planpage.dart';
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Profile Page'),
        backgroundColor: Colors.grey[200],
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => PlanPage()));
              // Add your edit functionality here
            },
          ),
        ],
      ),
      body: Center(
        child: Text('Profile'),
      ),
    );
  }
}
