// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_tracker/src/constants/models/profile_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart%20';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  XFile? selectedImage;

  Future<void> saveProfile() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter data in required fields"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }


    try {
      await editProfile(
        nameController.text,
        emailController.text,
        phoneController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profile details added successfully!"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
      rethrow;
    }
  }

  Future<void> editProfile(String name, String email, String phone) async {
    // final pid = randomAlphaNumeric(8);
    final profile = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid ?? '');

    final profileModel = ProfileModel(
      uid: FirebaseAuth.instance.currentUser?.uid ?? '',
      name: name,
      email: email,
      number: phone,
    );

    await profile.set(profileModel.toMap());
  }

  Future<void> requestPermissions() async {
    if (await Permission.camera.request().isDenied ||
        await Permission.storage.request().isDenied) {}
  }

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .snapshots();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 40,
              ),
              Stack(
                children: [
                  GestureDetector(
                    onTap: () => _showImagePickerOptions(context),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: selectedImage != null
                          ? FileImage(File(selectedImage!.path))
                          : null,
                    ),
                  ),
                  const Positioned(
                    bottom: 0,
                    right: 10,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.blue,
                      child: Icon(
                        Icons.image,
                        size: 28,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                    focusColor: Colors.grey.shade200,
                    hintText: "Enter Your name",
                    hoverColor: Colors.grey.shade200,
                    hintStyle: TextStyle(
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w400,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(8),
                    )),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    focusColor: Colors.grey.shade200,
                    hintText: "Enter your email",
                    hoverColor: Colors.grey.shade200,
                    hintStyle: TextStyle(
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w400,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(8),
                    )),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                keyboardType: TextInputType.number,
                controller: phoneController,
                decoration: InputDecoration(
                    hintStyle: TextStyle(
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w400,
                    ),
                    hintText: "Enter your number",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(8),
                    )),
              ),
              const SizedBox(
                height: 40,
              ),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    saveProfile();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusDirectional.circular(10)),
                      maximumSize: Size(MediaQuery.of(context).size.width, 80)),
                  child: const Text(
                    "Save",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showImagePickerOptions(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
              leading: Icon(
                Icons.photo_library,
                color: Colors.grey.shade500,
              ),
              title: const Text('Choose from Gallery'),
              onTap: () {
                _pickImage(ImageSource.gallery);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
              leading: Icon(
                Icons.camera_alt,
                color: Colors.grey.shade500,
              ),
              title: const Text('Take a Photo'),
              onTap: () {
                _pickImage(ImageSource.camera);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        selectedImage = image;
      });
    }
  }


}
