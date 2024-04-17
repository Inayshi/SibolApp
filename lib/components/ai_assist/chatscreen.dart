import 'dart:io';
import 'dart:typed_data';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final Gemini gemini = Gemini.instance;

  List<ChatMessage> messages = [];

  ChatUser currentUser = ChatUser(id: "0", firstName: "User");
  ChatUser geminiUser = ChatUser(
    id: "1",
    firstName: "Gemini",
  );
  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: displayWidth * 0.1, // Adjust width based on screen width
              height: displayWidth * 0.1, // Adjust height based on screen width
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/logo.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(width: 8),
            Text(
              'AI Assist',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold, // Make font bold
                fontSize: displayWidth * 0.04,
              ),
              // Adjust font size based on screen width
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
      body: _buildUI(),
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
}
