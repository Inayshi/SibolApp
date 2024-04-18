import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io'; // To use File class
import 'package:image_picker/image_picker.dart'; // For image picking
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:urban_farming/core/dialogs.dart';
import 'package:urban_farming/services/auth_service.dart'; // For Firebase Storage

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late String fullName = '';
  late String initials = '';
  late String profileImageUrl = '';
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  XFile? _image = null;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    getUserSettings();
  }

  Future<void> getUserSettings() async {
    Map<String, dynamic> userData = await getUserData();

    // Access user data
    setState(() {
      String firstName = userData['firstName'] ?? '';
      String lastName = userData['lastName'] ?? '';
      fullName = "$firstName $lastName";
      initials = _getInitials(firstName, lastName);
      profileImageUrl = userData['profileImageUrl'] ?? '';
    });
  }

  String _getInitials(String firstName, String lastName) {
    String firstInitial = firstName.isNotEmpty ? firstName[0] : '';
    String lastInitial = lastName.isNotEmpty ? lastName[0] : '';
    return firstInitial + lastInitial;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // Logo widget (replace Container with your logo widget)
            Container(
              width: 40, // Adjust width as needed
              height: 40, // Adjust height as needed
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/images/sibol.png'), // Replace with your logo image
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width: 8), // Add some spacing between logo and title
            Text(
              'Settings',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                color: Color.fromARGB(
                    255, 23, 90, 25), // Custom color with hexadecimal value
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              final bool shouldLogout = await showConfirmationDialog(
                    context: context,
                    title: 'Do you want to sign out of the app?',
                  ) ??
                  false;
              if (shouldLogout) AuthService.logout();
            },
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 35),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 70,
                backgroundColor: Color.fromARGB(255, 23, 90, 25),
                child: _image != null ||
                        profileImageUrl
                            .isNotEmpty // Check if image or URL exists
                    ? ClipOval(
                        child:
                            _image != null // Check if local image is available
                                ? Image.file(
                                    File(_image!.path),
                                    fit: BoxFit.cover,
                                    width: 140,
                                    height: 140,
                                  )
                                : Image.network(
                                    profileImageUrl, // Use profile image URL
                                    fit: BoxFit.cover,
                                    width: 140,
                                    height: 140,
                                  ),
                      )
                    : Text(
                        initials,
                        style: TextStyle(fontSize: 30, color: Colors.white),
                      ),
              ),
              // Other widgets...

              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    fullName,
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      _showUpdateNameModal(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showUpdateNameModal(BuildContext context) {
    final ImagePicker _picker = ImagePicker();

    Future<void> _getImage() async {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = image;
      });
    }

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.all(20),
              child: Container(
                height: 900,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Update Name and Profile Image',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      _image != null
                          ? CircleAvatar(
                              radius: 50,
                              backgroundImage: FileImage(File(_image!.path)),
                            )
                          : CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey,
                              child: Icon(Icons.person, size: 40),
                            ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _getImage,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.green[700],
                        ),
                        child: Text('Pick Image'),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: firstNameController,
                        decoration: InputDecoration(labelText: 'First Name'),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: lastNameController,
                        decoration: InputDecoration(labelText: 'Last Name'),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          // Upload image if selected
                          String imageUrl = '';
                          if (_image != null) {
                            final imageFile = File(_image!.path);
                            firebase_storage.Reference ref = firebase_storage
                                .FirebaseStorage.instance
                                .ref()
                                .child('profile_images')
                                .child(
                                    '${FirebaseAuth.instance.currentUser!.uid}.jpg');
                            await ref.putFile(imageFile);
                            imageUrl = await ref.getDownloadURL();
                          }

                          // Update user data
                          updateUserNames(firstNameController.text,
                              lastNameController.text, imageUrl);
                          Navigator.pop(context); // Close the bottom sheet
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.green[700],
                        ),
                        child: Text('Update'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> updateUserNames(
      String firstName, String lastName, String imageUrl) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'firstName': firstName,
        'lastName': lastName,
        'profileImageUrl': imageUrl, // Update profile image URL
      });
      setState(() {
        fullName = '$firstName $lastName';
        initials = _getInitials(firstName, lastName);
      });
    }

    Future<void> updateUserNames(String firstName, String lastName) async {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'firstName': firstName,
          'lastName': lastName,
        });
        setState(() {
          fullName = '$firstName $lastName';
          initials = _getInitials(firstName, lastName);
        });
      }
    }

    @override
    void dispose() {
      firstNameController.dispose();
      lastNameController.dispose();
      super.dispose();
    }
  }

  Future<Map<String, dynamic>> getUserData() async {
    // Get current user
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Get user document from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      // Extract user data
      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        return userData;
      }
    }

    // Return an empty map if user not found or document doesn't exist
    return {};
  }
}
