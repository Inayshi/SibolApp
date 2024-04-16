import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class NewPlant extends StatefulWidget {
  @override
  _NewPlantState createState() => _NewPlantState();
}

class _NewPlantState extends State<NewPlant> {
  final TextEditingController locationController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  File? _imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Plant'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Location:',
              style: TextStyle(fontSize: 20.0),
            ),
            TextField(
              controller: locationController,
              decoration: InputDecoration(
                hintText: 'Enter location',
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Plant Name:',
              style: TextStyle(fontSize: 20.0),
            ),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Enter plant name',
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Image:',
              style: TextStyle(fontSize: 20.0),
            ),
            _imageFile != null
                ? Container(
                    height: 200,
                    width: 200,
                    child: Image.file(_imageFile!),
                  )
                : Container(),
            ElevatedButton(
              onPressed: () {
                _selectImage(context);
              },
              child: Text('Select Image'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _savePlant(context);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _selectImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No image selected'),
        ),
      );
    }
  }

  void _savePlant(BuildContext context) {
    String location = locationController.text;
    String name = nameController.text;

    if (location.isNotEmpty && name.isNotEmpty && _imageFile != null) {
      FirebaseFirestore.instance.collection('My Plants').add({
        'location': location,
        'name': name,
        'image_path': _imageFile!.path,
      }).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Plant details saved successfully!'),
          ),
        );

        locationController.clear();
        nameController.clear();
        setState(() {
          _imageFile = null;
        });
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save plant details: $error'),
          ),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Please enter both location, plant name, and select an image.'),
        ),
      );
    }
  }
}
