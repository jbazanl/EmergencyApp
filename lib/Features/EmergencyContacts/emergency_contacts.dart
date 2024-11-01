import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({Key? key}) : super(key: key);

  @override
  _ContactListScreenState createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  late String _contact1 = '';
  late String _contact2 = '';
  late String _contact3 = '';
  late String _contact4 = '';
  late String _contact5 = '';

  @override
  void initState() {
    super.initState();
    // _loadContacts();
    fetchAllContacts();
  }

  List<Contact> contacts = [];

  fetchAllContacts() async {
    if (await FlutterContacts.requestPermission()) {
      // Get all contacts (lightly fetched)
      contacts = await FlutterContacts.getContacts();
    }
  }

  Future<void> _loadContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _contact1 = prefs.getString('contact1')!;
      _contact2 = prefs.getString('contact2')!;
      _contact3 = prefs.getString('contact3')!;
      _contact4 = prefs.getString('contact4')!;
      _contact5 = prefs.getString('contact5')!;
    });
  }

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
            preferredSize: Size.fromHeight(Get.height * 0.1),
            child: Container(
              padding: const EdgeInsets.only(bottom: 15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                          image: const AssetImage(
                              "assets/logos/emergencyAppLogo.png"),
                          height: Get.height * 0.1),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
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
      body: ListView.builder(
        itemCount: contacts.length,
        padding: const EdgeInsets.all(8),
        itemBuilder: (context, index) => ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          tileColor: Colors.red.shade200,
          style: ListTileStyle.drawer,
          title: Text(contacts[index].displayName),
          subtitle: Text(contacts[index].phones.first.number),
        ),
      ),
    );
  }
}
