import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:public_emergency_app/Features/User/Screens/Profile/profile_screen.dart';
import 'package:public_emergency_app/Features/User/Screens/bottom_nav.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'emergency_contacts_controller.dart';

class add_contact extends StatefulWidget {
  const add_contact({Key? key}) : super(key: key);

  @override
  State<add_contact> createState() => _add_contactState();
}

class _add_contactState extends State<add_contact> {
  @override
  void initState() {
    super.initState();
    // contactController.loadData();
    // _loadContacts();
    WidgetsBinding.instance.addPostFrameCallback((t) {
      fetchAllContacts();
    });
  }

  List<Contact> contacts = [];

  fetchAllContacts() async {
    if (await FlutterContacts.requestPermission()) {
      // Get all contacts (lightly fetched)
      contacts = await FlutterContacts.getContacts(
        withProperties: true,
        withAccounts: true,
        withGroups: true,
        withPhoto: true,
        withThumbnail: true,
      );
    }
    setState(() {});
  }

  Future<void> _loadContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _contact1 = prefs.getString('contact1') ?? '';
      _contact2 = prefs.getString('contact2') ?? '';
      _contact3 = prefs.getString('contact3') ?? '';
      _contact4 = prefs.getString('contact4') ?? '';
      _contact5 = prefs.getString('contact5') ?? '';
    });
  }

  //Emergency Contacts
  static String _contact1 = '';
  static String _contact2 = '';
  static String _contact3 = '';
  static String _contact4 = '';
  static String _contact5 = '';

  //Controllers
  final contactController = Get.put(EmergencyContactsController());
  var _formKey = GlobalKey<FormState>();
  var contact1controller =
      TextEditingController(text: Text(_contact1).data.toString());
  var contact2controller =
      TextEditingController(text: Text(_contact2).data.toString());
  var contact3controller =
      TextEditingController(text: Text(_contact3).data.toString());
  var contact4controller =
      TextEditingController(text: Text(_contact4).data.toString());
  var contact5controller =
      TextEditingController(text: Text(_contact5).data.toString());

  static const String _key1 = 'contact1';
  static const String _key2 = 'contact2';
  static const String _key3 = 'contact3';
  static const String _key4 = 'contact4';
  static const String _key5 = 'contact5';

  List<Contact> addedContacts = [];

  DatabaseReference ref = FirebaseDatabase.instance.ref('Users');
  User user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        centerTitle: true,
        automaticallyImplyLeading: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(40),
          ),
        ),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(100),
            child: Container(
              padding: const EdgeInsets.only(bottom: 15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Center(
                        child: SizedBox.fromSize(
                          size: const Size(56, 56),
                          child: ClipOval(
                            child: Material(
                              color: Colors.lightBlueAccent,
                              child: InkWell(
                                splashColor: Colors.white,
                                onTap: () {
                                  Get.to(() => NavBar());
                                },
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: Get.width * 0.3,
                      ),
                      Image(
                          image: const AssetImage(
                              "assets/logos/emergencyAppLogo.png"),
                          height: Get.height * 0.1),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Emergency Contacts",
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: Get.height * 0.02,
            ),
            const Text(
              "Add Emergency Contacts here",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: Get.height * 0.02,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: contacts.length,
                padding: const EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  var _numbers = contacts[index].phones.toList();

                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
                    child: ListTile(
                      onTap: () {
                        if (addedContacts.contains(contacts[index])) {
                          addedContacts.remove(contacts[index]);
                        } else {
                          addedContacts.add(contacts[index]);
                        }
                        setState(() {});
                      },
                      leading: Icon(
                        addedContacts.contains(contacts[index])
                            ? CupertinoIcons.check_mark_circled_solid
                            : CupertinoIcons.circle,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      tileColor: Colors.grey.shade200,
                      style: ListTileStyle.drawer,
                      title: Text(contacts[index].displayName),
                      subtitle:
                          Text(_numbers.isEmpty ? '' : _numbers.first.number),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: Get.height * 0.02,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                textStyle: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () async {
                final snapshot = await ref.child('${user.uid}/contacts').get();
                List<Contact> contactsList = [];

                if (snapshot.exists && snapshot.value != null) {
                  // Map the snapshot data to a list of Contact objects
                  contactsList = (snapshot.value as List)
                      .map((e) => Contact(
                            displayName:
                                e['name'] ?? '', // Ensure name is not null
                            phones: [
                              Phone(
                                e['phone'] ?? '', // Ensure phone is not null
                              ),
                            ],
                          ))
                      .toList();
                }

                // Add the new contact to the list
                contactsList.addAll(addedContacts);

                // Update the contacts list in the database

                ref.child(user.uid).update({
                  "contacts": contactsList
                      .map((e) => {
                            "name": e.displayName,
                            "phone":
                                e.phones.isEmpty ? '' : e.phones.first.number,
                          })
                      .toList(),
                });
                Get.back();
                //show success message and get back to the previous screen
                Get.closeAllSnackbars();
                await Get.closeCurrentSnackbar();

                Get.snackbar(
                  'Success',
                  'Contacts added successfully',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              },
              child: const Text("Save"),
            ),
            SizedBox(
              height: Get.height * 0.02,
            ),
            // Text(contact1),
          ],
        ),
      ),
    );
  }

  // void loadData() async {
  //   var contact1 = '';
  //   var contact2 = '';
  //   var contact3 = '';
  //   var contact4 = '';
  //   var contact5 = '';
  //   var prefs = await SharedPreferences.getInstance();
  //   String? getcontact1 = prefs.getString(_key1);
  //   String? getcontact2 = prefs.getString(_key2);
  //   String? getcontact3 = prefs.getString(_key3);
  //   String? getcontact4 = prefs.getString(_key4);
  //   String? getcontact5 = prefs.getString(_key5);
  //   contact1 = getcontact1 ?? '';
  //   contact2 = getcontact2 ?? '';
  //   contact3 = getcontact3 ?? '';
  //   contact4 = getcontact4 ?? '';
  //   contact5 = getcontact5 ?? '';
  //
  //   debugPrint("$contact1  $contact2  $contact3  $contact4 $contact5");
  // }
}
