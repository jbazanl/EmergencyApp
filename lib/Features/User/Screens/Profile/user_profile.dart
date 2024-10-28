import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:public_emergency_app/Features/User/Controllers/session_controller.dart';

import '../../../EmergencyContacts/add_contacts.dart';
import '../../../EmergencyContacts/emergency_contacts.dart';
import '../../../Login/login_screen.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.red, minimumSize: Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                    // foreground
                  ),
                  onPressed: () {
                    // final user = auth.currentUser;
                    FirebaseAuth auth = FirebaseAuth.instance;

                    auth.signOut().then((value) {
                      SessionController().userid = '';
                      Get.offAll(() => const LoginScreen());
                    });
                  },
                  child: const Text("Logout")),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.green, minimumSize: Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                    // foreground
                  ),
                  onPressed: () {
                    Get.to(() => add_contact());
                  },
                  child: const Text("Add Emergency Contacts")),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.blue, minimumSize: Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                    // foreground
                  ),
                  onPressed: () {
                    Get.to(() => ContactListScreen());
                  },
                  child: const Text("Emergency Contacts")),
            ],
          ),
        ),
      ),
    );
  }
}
