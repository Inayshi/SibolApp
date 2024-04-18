import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_gemini/flutter_gemini.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dash_chat_2/dash_chat_2.dart';

class PlantCarePage extends StatefulWidget {
  const PlantCarePage({Key? key}) : super(key: key);

  @override
  _PlantCarePageState createState() => _PlantCarePageState();
}

class _PlantCarePageState extends State<PlantCarePage> {
  final Gemini gemini = Gemini.instance;

  late File? _image = null;
  late TextEditingController concernController;
  bool _showBuildUI = false;
  List<ChatMessage> messages = [];

  ChatUser currentUser = ChatUser(id: "0", firstName: "User");
  ChatUser geminiUser = ChatUser(
    id: "1",
    firstName: "Sibol",
  );

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

  void _sendQuery2(TextEditingController concernController, File? image) {
    // Validate input fields
    if (_image == null || concernController.text.isEmpty) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please provide an image and describe your concern.'),
      ));
    } else {
      String concern = concernController.text;
      _showBuildUI = true;
      String guide =
          "I am a beginner in urban farming, I need help with the following problems regarding my plant: \n My main concern about my plant is: " +
              concern +
              "\n The image of my plant is provided above.";
      ChatMessage chatMessage = ChatMessage(
        user: currentUser,
        createdAt: DateTime.now(),
        text: guide,
        medias: [
          ChatMedia(
            url: _image != null
                ? _image!.path // Accessing path property with a null check
                : 'No image selected', // Return a default value or handle the null case

            fileName: "",
            type: MediaType.image,
          )
        ],
      );
      _sendMessage(chatMessage);
    }
  }

  void _getImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    setState(() {
      _image = File(image.path);
    });
  }

  void _sendMessage(ChatMessage chatMessage) {
    setState(() {
      messages = [chatMessage, ...messages];
    });
    try {
      String question = chatMessage.text;
      List<Uint8List>? images;
      if (chatMessage.medias?.isNotEmpty ?? false) {
        images = [
          File(chatMessage.medias!.first.url).readAsBytesSync(),
        ];
      }
      gemini
          .streamGenerateContent(
        question,
        images: images,
      )
          .listen((event) {
        ChatMessage? lastMessage = messages.firstOrNull;
        if (lastMessage != null && lastMessage.user == geminiUser) {
          lastMessage = messages.removeAt(0);
          String response = event.content?.parts?.fold(
                  "", (previous, current) => "$previous ${current.text}") ??
              "";
          response = response.replaceAll('*', '');
          lastMessage.text += response;
          setState(
            () {
              messages = [lastMessage!, ...messages];
            },
          );
        } else {
          String response = event.content?.parts?.fold(
                  "", (previous, current) => "$previous ${current.text}") ??
              "";
          response = response.replaceAll('*', '');

          ChatMessage message = ChatMessage(
            user: geminiUser,
            createdAt: DateTime.now(),
            text: response,
          );
          setState(() {
            messages = [message, ...messages];
          });
        }
      });
    } catch (e) {
      print(e);
    }
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
              'Plant Care',
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
      body: _showBuildUI ? _buildUI() : _showQuery1(screenWidth),
    );
  }

  Widget _buildUI() {
    return DashChat(
      inputOptions: InputOptions(trailing: []),
      currentUser: currentUser,
      onSend: _sendMessage,
      messages: messages,
    );
  }

  Widget _showQuery1(double screenWidth) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Text(
              'Let me know how I can help with your plant.',
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
              'Send me an image of your plant and describe your concern.',
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.left, // Align text to the left
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              controller: concernController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Write your Concern',
              ),
            ),
          ),
          _image != null
              ? Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10), // Adjust the padding as needed
                  child: Image.file(
                    _image!,
                    width: screenWidth,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                )
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
              'Add Image',
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
              _sendQuery2(concernController, _image);
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
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
