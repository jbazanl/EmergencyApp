import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/place_type.dart';
import 'package:google_places_flutter/model/prediction.dart';

import '../../../EmergencyContacts/add_contacts.dart';
import '../../Controllers/session_controller.dart';

class ProfileFormWidget extends StatefulWidget {
  const ProfileFormWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileFormWidget> createState() => _ProfileFormWidgetState();
}

class _ProfileFormWidgetState extends State<ProfileFormWidget> {
  DatabaseReference ref = FirebaseDatabase.instance.ref('Users');
  final directionTxtController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    ref.child(user!.uid.toString()).onValue.listen((event) {
      Map<dynamic, dynamic> map = event.snapshot.value as Map<dynamic, dynamic>;
      directionTxtController.text = map['Direction'] ?? '';
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _formkey = GlobalKey<FormState>();

    String userEmail;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30 - 10),
      // this function will get current user data form firebase
      child: StreamBuilder(
          stream: ref.child(user!.uid.toString()).onValue,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              Map<dynamic, dynamic> map = snapshot.data.snapshot.value ?? {};
              final nameController =
                  TextEditingController(text: map['UserName']);
              final phoneController = TextEditingController(text: map['Phone']);
              userEmail = map["email"].toString();

              return Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "User Info",
                      style: TextStyle(
                        color: Colors.lightBlueAccent,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 30 - 10),
                    TextFormField(
                      controller: nameController,
                      // initialValue: map['UserName'],
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'This field is required';
                        }
                        if (value.trim().length < 2) {
                          return 'Name must be valid';
                        }
                        // Return null if the entered username is valid
                        // return null;
                      },

                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_outline_rounded),
                        labelText: "Full Name",
                        hintText: "Full Name",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                    const SizedBox(height: 30 - 20),
                    TextFormField(
                      // initialValue: map['Phone'],
                      controller: phoneController,

                      validator: (value) {
                        bool _isEmailValid =
                            RegExp(r'^(?:[+0][1-9])?[0-9]{8,15}$')
                                .hasMatch(value!);
                        if (!_isEmailValid) {
                          return 'Invalid phone number';
                        }
                        // return null;
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.phone),
                        labelText: "Phone Number",
                        hintText: "Phone Number",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                    const SizedBox(height: 30 - 20),
                    TextFormField(
                      initialValue: map['email'],
                      enableInteractiveSelection: false,
                      focusNode: new AlwaysDisabledFocusNode(),
                      validator: (value) {
                        bool _isEmailValid = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value!);
                        if (!_isEmailValid) {
                          return 'Invalid email.';
                        }
                        // return null;
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email_outlined),
                        labelText: "Email",
                        hintText: "Email",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                    const SizedBox(height: 30 - 20),
                    //direction api text field
                    GooglePlaceAutoCompleteTextField(
                      textEditingController: directionTxtController,

                      boxDecoration: BoxDecoration(
                          border: null,
                          borderRadius: BorderRadius.circular(20)),
                      googleAPIKey: "AIzaSyA8zsjcTFw4QbgPylMtbbIuZZ3d7J9FfJk",
                      inputDecoration: InputDecoration(
                        prefixIcon: const Icon(Icons.directions),
                        labelText: "Address Direction",
                        hintText: "Address Direction",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      debounceTime: 800, // default 600 ms,
                      // optional by default null is set
                      isLatLngRequired:
                          false, // if you required coordinates from place detail
                      getPlaceDetailWithLatLng: (Prediction prediction) {
                        // this method will return latlng with place detail
                        print("placeDetails" + prediction.lng.toString());
                      }, // this callback is called when isLatLngRequired is true
                      itemClick: (Prediction prediction) {
                        directionTxtController.text = prediction.description!;
                        directionTxtController.selection =
                            TextSelection.fromPosition(TextPosition(
                                offset: prediction.description!.length));
                      },
                      // if we want to make custom list item builder
                      itemBuilder: (context, index, Prediction prediction) {
                        return Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Icon(Icons.location_on),
                              SizedBox(
                                width: 7,
                              ),
                              Expanded(
                                  child:
                                      Text("${prediction.description ?? ""}"))
                            ],
                          ),
                        );
                      },
                      // if you want to add seperator between list items
                      seperatedBuilder: Divider(),
                      // want to show close icon
                      isCrossBtnShown: true,
                      // optional container padding
                      containerHorizontalPadding: 0,
                      // place type
                      placeType: PlaceType.geocode,
                    ),
                    const SizedBox(height: 30 - 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.lightBlueAccent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                        onPressed: () {
                          // ProfileController.instance?.updateprofile(
                          //   nameController.text!.trim(),
                          //   phoneController.text!.trim(),
                          // );

                          if ((_formkey.currentState)!.validate()) {
                            updateprofile(nameController.text.trim(),
                                phoneController.text.trim());
                            directionTxtController.clear();
                            directionTxtController.text = map['Direction'];

                            Get.snackbar("Save", "Profile Updated",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                                duration: const Duration(seconds: 2));
                          }
                        },
                        child: Text("Update".toUpperCase()),
                      ),
                    ),
                    const SizedBox(height: 30 - 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.lightBlueAccent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                        onPressed: () {
                          Get.to(() => const add_contact(),
                              transition: Transition.rightToLeft,
                              duration: const Duration(seconds: 1),
                              arguments: userEmail);
                        },
                        child: Text("Emergency Contacts".toUpperCase()),
                      ),
                    ),
                  ],
                ),
              );
            }
            // else if (snapshot.hasError) {
            //   return Center(child: Text(snapshot.error.toString()));
            // }
            else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  // this function to update user profile
  void updateprofile(String name, String phone) {
    ref.child(user!.uid.toString()).update({
      'UserName': name,
      'Phone': phone,
      'Direction': directionTxtController.text,
    });
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
