import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:urban_farming/core/constants.dart';

class FarmSetupPage extends StatefulWidget {
  const FarmSetupPage({Key? key}) : super(key: key);

  @override
  _FarmSetupPageState createState() => _FarmSetupPageState();
}

class _FarmSetupPageState extends State<FarmSetupPage> {
  final Gemini gemini = Gemini.instance;

  bool _showQuery2 = false;
  late File? _image = null;
  late TextEditingController locationController;
  late String dropdownValue;
  late List<String> plantPreferences;
  String response = '';
  List<String> messages = [];
  TextEditingController lastMessage = TextEditingController();
  GlobalKey containerKey = GlobalKey();

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

  void _sendQuery1(BuildContext context) async {
    if (_image == null ||
        locationController.text.isEmpty ||
        dropdownValue == 'Choose plant preference') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please provide location, plant preference, and image.'),
      ));
    } else {
      _showQuery2 = true;

      String question =
          "Generate a beginner-friendly guide on setting up a farm based on the provided location and Plant Preferences. List your suggestions of plants, how to take care of them and how they can be set up based on the image provided. Include the soil type if either Loam, Clay, Chalk, Silt or Sand and how many times it needs to be watered per week.\n"
          "Location: ${locationController.text}\n"
          "Plant Preferences: $dropdownValue";

      final List<Uint8List> images =
          _image != null ? [_image!.readAsBytesSync()] : [];

      gemini
          .textAndImage(
              text: question,

              /// text
              images: images

              /// list of images
              )
          .then((value) {
        setState(() {
          lastMessage.text = value?.content?.parts?.last.text ?? '';
          lastMessage.text = lastMessage.text.replaceAll('*', '');
          lastMessage.text = lastMessage.text.replaceAll('#', '');
        });
      }).catchError((e) => print(e));
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
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // Add some spacing between logo and title
            Text(
              'Farm Setup',
              style: TextStyle(
                fontSize: 20,
                color: Color.fromARGB(
                    255, 23, 90, 25), // Custom color with hexadecimal value
              ),
            ),
          ],
        ),
        actions: [],
      ),
      body: _showQuery2 ? _query2(screenWidth) : _query1(screenWidth),
    );
  }

  Widget _query1(double screenWidth) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Text(
              'Lets talk about setting up your urban farm.',
              style: TextStyle(
                fontSize: 30,
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
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: TextField(
              controller: locationController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter Location',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
            child: Container(
              key: containerKey,
              width: double.infinity, // Make the container full width
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return DropdownMenu<String>(
                    initialSelection: plantPreferences.first,
                    width: constraints
                        .maxWidth, // Set the width of the DropdownMenu to the maxWidth of the container
                    onSelected: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        dropdownValue = value!;
                      });
                    },
                    dropdownMenuEntries: plantPreferences
                        .map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(
                          value: value, label: value);
                    }).toList(),
                  );
                },
              ),
            ),
          ),
          _image != null
              ? Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20), // Adjust the padding as needed
                  child: Image.file(
                    _image!,
                    width: screenWidth,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                )
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Container(
                    width: screenWidth,
                    height: 250,
                    color: Colors.grey[300], // Adjust color as needed
                  ),
                ),
          ElevatedButton(
            onPressed: () {
              _getImage();
            },
            child: Text(
              'Add image of your farm',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              fixedSize: Size(300, 60),
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              _sendQuery1(context);
            },
            child: Text(
              'Send',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              fixedSize: Size(300, 60),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _query2(double screenWidth) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          _image != null
              ? Padding(
                  padding: EdgeInsets.all(8.0), // Adjust the padding as needed
                  child: Image.file(
                    _image!,
                    width: screenWidth,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                )
              : Padding(
                  padding: EdgeInsets.all(8.0), // Adjust the padding as needed
                  child: Placeholder(
                    fallbackHeight: 250,
                    fallbackWidth: 250,
                  ),
                ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: lastMessage,
              readOnly: true, // Make the text field read-only
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
              maxLines: null, // Allow multiple lines
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _saveResponse(context);
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.green[700],
            ),
            child: Text('Save Response'),
          ),
        ],
      ),
    );
  }

  void _saveResponse(BuildContext context) async {
    String? title = await _showTitleDialog(context);
    if (title != null && title.isNotEmpty) {
      // Save response and title to Firestore
      await FirebaseFirestore.instance.collection('Saved_Guides').add({
        'title': title,
        'response': lastMessage.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Response saved successfully.'),
      ));
    }
  }

  Future<String?> _showTitleDialog(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Title'),
          content: TextField(
            controller: titleController,
            decoration: InputDecoration(hintText: 'Title'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(titleController.text);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
