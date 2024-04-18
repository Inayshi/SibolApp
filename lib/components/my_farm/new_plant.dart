import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class NewPlant extends StatefulWidget {
  @override
  _NewPlantState createState() => _NewPlantState();
}

class _NewPlantState extends State<NewPlant> {
  final TextEditingController nameController = TextEditingController();
  String dropdownValue = 'Edible';
  String? selectedGuide;
  List<String> guides = [];
  int water = 0;
  String soilType = 'Loam';
  File? _imageFile;
  String bucketName = 'urban-farming-3efe6.appspot.com';

  @override
  void initState() {
    super.initState();
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

  void _savePlant(BuildContext context) async {
    String name = nameController.text;

    if (name.isNotEmpty && _imageFile != null) {
      try {
        String imageName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference storageReference =
            FirebaseStorage.instance.ref().child('images/$imageName.jpg');
        storageReference = FirebaseStorage.instance
            .refFromURL('gs://$bucketName')
            .child('images/$imageName.jpg');
        UploadTask uploadTask = storageReference.putFile(_imageFile!);
        TaskSnapshot taskSnapshot = await uploadTask;
        String imageUrl = await taskSnapshot.ref.getDownloadURL();

        await FirebaseFirestore.instance.collection('MyPlants').add({
          'name': name,
          'plant_type': dropdownValue,
          'water': water,
          'soil_type': soilType,
          'image_url': imageUrl,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Plant details saved successfully!'),
          ),
        );

        nameController.clear();
        setState(() {
          _imageFile = null;
        });
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save plant details: $error'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter plant name and select an image.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add New Plant',
          style: TextStyle(
            fontSize: 20,
            color: Color.fromARGB(255, 23, 90, 25),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Enter plant name',
                  filled: true,
                  fillColor: Colors.green[50],
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              SizedBox(height: 20.0),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Plant Type:',
                          style: TextStyle(fontSize: 20.0, fontFamily: 'Inter'),
                        ),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.green[50],
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          value: dropdownValue,
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValue = newValue!;
                            });
                          },
                          items: <String>['Edible', 'Decorative']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                      width: 20), // Add some spacing between the two dropdowns
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Soil Type:',
                          style: TextStyle(fontSize: 20.0, fontFamily: 'Inter'),
                        ),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.green[50],
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          value: soilType,
                          onChanged: (String? newValue) {
                            setState(() {
                              soilType = newValue!;
                            });
                          },
                          items: <String>[
                            'Loam',
                            'Sand',
                            'Silt',
                            'Clay',
                            'Chalk'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Text(
                'Water:',
                style: TextStyle(fontSize: 20.0, fontFamily: 'Inter'),
              ),
              Slider(
                value: water.toDouble(),
                min: 0,
                max: 6,
                divisions: 100,
                label: water.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    water = value.round();
                  });
                },
                activeColor: Colors.green,
              ),
              SizedBox(height: 20.0),
              Text(
                'Image:',
                style: TextStyle(fontSize: 20.0, fontFamily: 'Inter'),
              ),
              _imageFile != null && _imageFile!.existsSync()
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: Text(
                  'Select Image',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  _savePlant(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
