import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class IdentifyPlantPage extends StatefulWidget {
  const IdentifyPlantPage({Key? key}) : super(key: key);

  @override
  _IdentifyPlantPageState createState() => _IdentifyPlantPageState();
}

class _IdentifyPlantPageState extends State<IdentifyPlantPage> {
  late File? _image;

  void _sendQuery3(BuildContext context) {
    // Validate input fields
    if (_image == null) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please provide an image.'),
      ));
    } else {
      // Navigate to the result page with the provided data
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: Text('Identify Plant Result'),
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
        title: Text('Identify Plant'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Let’s see what that plant looks like.',
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
                'Upload an image of the plant you want me to identify.',
                style: TextStyle(fontSize: 14),
              ),
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
                _sendQuery3(context);
              },
              child: Text('Send'),
            ),
          ],
        ),
      ),
    );
  }
}
