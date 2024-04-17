import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FarmSetupPage extends StatefulWidget {
  const FarmSetupPage({Key? key}) : super(key: key);

  @override
  _FarmSetupPageState createState() => _FarmSetupPageState();
}

class _FarmSetupPageState extends State<FarmSetupPage> {
  late File? _image;
  late TextEditingController locationController;
  late String dropdownValue;
  late List<String> plantPreferences;

  @override
  void initState() {
    super.initState();
    locationController = TextEditingController();
    dropdownValue = 'Choose plant preference';
    plantPreferences = [
      'Choose plant preference',
      'Vegetables',
      'Herbs',
      'Fruits',
      'Flowers',
      'Succulents',
      'Trees',
      'Shrubs',
      'Cacti',
    ];
  }

  @override
  void dispose() {
    locationController.dispose();
    super.dispose();
  }

  void _sendQuery1(BuildContext context) {
    if (_image == null ||
        locationController.text.isEmpty ||
        dropdownValue == 'Choose plant preference') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please provide location, plant preference, and image.'),
      ));
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: Text('Farm Setup Result'),
            ),
            body: Center(
              child: Text('Results will be displayed here'),
            ),
          ),
        ),
      );
    }
  }

  void _getImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    setState(() {
      _image = File(image.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Farm Setup'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Let’s talk about setting up your urban farm.',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Specify your location, plant preferences, and upload an image of the area for your farm.',
                style: TextStyle(fontSize: 14),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                controller: locationController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Location',
                ),
              ),
            ),
            DropdownButton<String>(
              value: dropdownValue,
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                });
              },
              items: plantPreferences
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            _image != null
                ? Image.file(
                    _image!,
                    width: 250,
                    height: 250,
                    fit: BoxFit.cover,
                  )
                : Placeholder(
                    fallbackHeight: 250,
                    fallbackWidth: 250,
                  ),
            ElevatedButton(
              onPressed: () {
                _getImage();
              },
              child: Text('Add Image'),
            ),
            ElevatedButton(
              onPressed: () {
                _sendQuery1(context);
              },
              child: Text('Send'),
            ),
          ],
        ),
      ),
    );
  }
}
