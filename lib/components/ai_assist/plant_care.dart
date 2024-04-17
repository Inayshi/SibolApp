import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PlantCarePage extends StatefulWidget {
  const PlantCarePage({Key? key}) : super(key: key);

  @override
  _PlantCarePageState createState() => _PlantCarePageState();
}

class _PlantCarePageState extends State<PlantCarePage> {
  late File? _image;
  late TextEditingController concernController;

  @override
  void initState() {
    super.initState();
    concernController = TextEditingController();
  }

  @override
  void dispose() {
    concernController.dispose();
    super.dispose();
  }

  void _sendQuery2(BuildContext context) {
    // Validate input fields
    if (_image == null || concernController.text.isEmpty) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please provide an image and describe your concern.'),
      ));
    } else {
      // Navigate to the result page with the provided data
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: Text('Plant Care Result'),
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
        title: Text('Plant Care'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Let me know how I can help with your plant.',
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
                'Send me an image of your plant and describe your concern.',
                style: TextStyle(fontSize: 14),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                controller: concernController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Write your Concern',
                ),
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
                _sendQuery2(context);
              },
              child: Text('Send'),
            ),
          ],
        ),
      ),
    );
  }
}
