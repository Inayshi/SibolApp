import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class IdentifyPlantPage extends StatefulWidget {
  const IdentifyPlantPage({Key? key}) : super(key: key);

  @override
  _IdentifyPlantPageState createState() => _IdentifyPlantPageState();
}

class _IdentifyPlantPageState extends State<IdentifyPlantPage> {
  final Gemini gemini = Gemini.instance;
  bool _showQuery2 = false;
  late File? _image = null;
  TextEditingController lastMessage = TextEditingController();

  void _sendQuery3(BuildContext context) {
    if (_image == null) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please provide an image.'),
      ));
    } else {
      _showQuery2 = true;
      String question =
          "Identify the plant on image above and provide a beginner-friendly urban farming guide. Include how to take care of the provided plant, how much sunlight it needs and highlight in bullet points how often it needs to be watered in a week and what kind of soil it needs.";

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
        });
      }).catchError((e) => print('textAndImageInput'));
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
              'Identify Plant',
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
        ],
      ),
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
              'Lets see what that plant looks like.',
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
              'Upload an image of the plant you want me to identify. Select one from your gallery.',
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.left, // Align text to the left
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
              'Add image of the plant',
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
              _sendQuery3(context);
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
        ],
      ),
    );
  }
}
