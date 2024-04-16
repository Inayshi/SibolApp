import 'dart:io';
import 'dart:typed_data';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';

class AIAssist extends StatefulWidget {
  const AIAssist({super.key});

  @override
  State<AIAssist> createState() => _AIAssistState();
}

class _AIAssistState extends State<AIAssist> {
  final Gemini gemini = Gemini.instance;

  List<ChatMessage> messages = [];

  ChatUser currentUser = ChatUser(id: "0", firstName: "User");
  ChatUser geminiUser = ChatUser(
    id: "1",
    firstName: "Gemini",
  );

  late File? _image = null;

  bool _showBuildUI = false;
  bool _showQuery1 = false;
  bool _showQuery2 = false;
  bool _showQuery3 = false;

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: displayWidth * 0.1,
              height: displayWidth * 0.1,
              // decoration: BoxDecoration(
              //   image: DecorationImage(
              //     image: AssetImage('assets/images/logo.png'),
              //     fit: BoxFit.contain,
              //   ),
              // ),
            ),
            SizedBox(width: 8),
            Text(
              'AI Assist',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: displayWidth * 0.04,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              // Add navigation logic to exit the page
            },
          ),
        ],
      ),
      body: _showBuildUI
          ? _buildUI()
          : _showQuery1
              ? _query1()
              : _introduction(),
    );
  }

  Widget _query1() {
    const List<String> list = <String>['One', 'Two', 'Three', 'Four'];
    String dropdownValue = list.first;

    void getImage() async {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemporary = File(image.path);

      setState(() {
        this._image = imageTemporary;
      });
    }

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 20), // Add padding to the left and right
              child: Text(
                'Let’s talk about setting up your urban farm.',
                style: TextStyle(
                  fontSize: 39,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 20), // Add padding to the left and right
              child: Text(
                'Specify your location and plant preferences an upload an image of the area for your farm.',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Inter',
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Text',
                ),
              ),
            ),
            DropdownMenu<String>(
              initialSelection: list.first,
              onSelected: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  dropdownValue = value!;
                });
              },
              dropdownMenuEntries:
                  list.map<DropdownMenuEntry<String>>((String value) {
                return DropdownMenuEntry<String>(value: value, label: value);
              }).toList(),
            ),
            _image != null
                ? Image.file(
                    _image!,
                    width: 250,
                    height: 250,
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    'https://www.generationsforpeace.org/wp-content/uploads/2018/03/empty.jpg'),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  getImage();
                });
              },
              child: Text(
                'Add Image',
                style:
                    TextStyle(color: Colors.white), // Set text color to white
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.green), // Set background color to green
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _showBuildUI = true;
                  _sendMessageQuery1("Hi Putangina mo");
                });
              },
              child: Text(
                'Send',
                style:
                    TextStyle(color: Colors.white), // Set text color to white
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.green), // Set background color to green
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _introduction() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          const Text(
            'Hi there, how can I help you?',
            style: TextStyle(
              fontSize: 39,
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
              color: Colors.green, // Set text color to green
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _showQuery1 = true;
              });
            },
            child: Text(
              'I need help setting up my farm',
              style: TextStyle(color: Colors.white), // Set text color to white
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.green), // Set background color to green
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _showBuildUI = true;
              });
            },
            child: Text(
              'I need help identifying a plant',
              style: TextStyle(color: Colors.white), // Set text color to white
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.green), // Set background color to green
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _showBuildUI = true;
              });
            },
            child: Text(
              'I need help with taking care of my farm',
              style: TextStyle(color: Colors.white), // Set text color to white
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.green), // Set background color to green
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUI() {
    return DashChat(
      inputOptions: InputOptions(trailing: [
        IconButton(
          onPressed: _showMenu,
          icon: const Icon(
            Icons.menu,
          ),
        )
      ]),
      currentUser: currentUser,
      onSend: _sendMessage,
      messages: messages,
    );
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

  void _showMenu() async {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 250,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), // Adjust the radius value as needed
              topRight:
                  Radius.circular(20), // Adjust the radius value as needed
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      20, 0, 20, 0), // Add padding of 16 pixels around the text
                  child: Text(
                    'Hi! How can I help you with your farm?',
                    textAlign: TextAlign.justify, // Align text to center

                    style: TextStyle(
                      color: Colors.green, // Set text color to green
                      fontWeight: FontWeight.bold, // Make text bold
                      fontSize: 24, // Set font size to 24
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.green), // Set background color to green
                    foregroundColor: MaterialStateProperty.all<Color>(
                        Colors.white), // Set text color to white
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('I need Help Setting up my Farm'),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.green), // Set background color to green
                    foregroundColor: MaterialStateProperty.all<Color>(
                        Colors.white), // Set text color to white
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('I need Help Setting up my Farm'),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.green), // Set background color to green
                    foregroundColor: MaterialStateProperty.all<Color>(
                        Colors.white), // Set text color to white
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('I need Help Setting up my Farm'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _sendMediaMessage() async {
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (file != null) {
      ChatMessage chatMessage = ChatMessage(
        user: currentUser,
        createdAt: DateTime.now(),
        text:
            "Identify the plant and provide a beginner-friendly urban farming guide. Include how to take care of the provided plant, how much sunlight it needs and highlight in bullet points how often it needs to be watered in a week and what kind of soil it needs.",
        medias: [
          ChatMedia(
            url: file.path,
            fileName: "",
            type: MediaType.image,
          )
        ],
      );
      _sendMessage(chatMessage);
    }
  }

  void _sendMessageQuery1(String message) async {
    ChatMessage chatMessage = ChatMessage(
      user: currentUser,
      createdAt: DateTime.now(),
      text: message, // Set the message parameter as the text of the ChatMessage
    );
    _sendMessage(chatMessage);
  }
}
