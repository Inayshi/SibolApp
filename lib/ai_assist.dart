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
  late TextEditingController? locationController = TextEditingController();
  late TextEditingController? concernController = TextEditingController();

  bool _showBuildUI = false;
  bool _showQuery1 = false;
  bool _showQuery2 = false;
  bool _showQuery3 = false;
  late String dropdownValue;
  late List<String> list;

  @override
  void dispose() {
    // Clean up the TextEditingController when the widget is disposed
    locationController?.dispose();
    concernController?.dispose();

    super.dispose();
  }

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
              : _showQuery2
                  ? _query2()
                  : _showQuery3
                      ? _query3()
                      : _introduction(),
    );
  }

  void _sendQuery1(String? location, String plants, File? image) {
    if (location == null ||
        image == null ||
        plants == "Choose plant preference") {
      // Show error modal
      print(location);
      print(image);
      print(plants);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content:
                Text('Please provide location, plant preference, and image.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      _showBuildUI = true;
      String guide =
          "Generate a beginner-friendly guide on setting up a farm based on the provided:\n"
                  "Location:" +
              location +
              "\nPlant Preferences:" +
              plants +
              "\nList your suggestions of plants, how to take care of them and how they can be set up based on the image provided.";
      ChatMessage chatMessage = ChatMessage(
        user: currentUser,
        createdAt: DateTime.now(),
        text: guide,
        medias: [
          ChatMedia(
            url: image.path,
            fileName: "",
            type: MediaType.image,
          )
        ],
      );
      _sendMessage(chatMessage);
    }
  }

  void _sendQuery2(String? concern, File? image) {
    if (concern == null || image == null) {
      // Show error modal
      print(concern);
      print(image);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content:
                Text('Please provide location, plant preference, and image.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
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
            url: image.path,
            fileName: "",
            type: MediaType.image,
          )
        ],
      );
      _sendMessage(chatMessage);
    }
  }

  void _sendQuery3(File? image) {
    if (image == null) {
      // Show error modal
      print(image);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content:
                Text('Please provide location, plant preference, and image.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      _showBuildUI = true;
      String guide =
          "Identify the plant on image above and provide a beginner-friendly urban farming guide. Include how to take care of the provided plant, how much sunlight it needs and highlight in bullet points how often it needs to be watered in a week and what kind of soil it needs.";
      ChatMessage chatMessage = ChatMessage(
        user: currentUser,
        createdAt: DateTime.now(),
        text: guide,
        medias: [
          ChatMedia(
            url: image.path,
            fileName: "",
            type: MediaType.image,
          )
        ],
      );
      _sendMessage(chatMessage);
    }
  }

  @override
  void initState() {
    super.initState();
    list = <String>[
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
    dropdownValue =
        list.first; // Initialize dropdownValue with the first item in the list
    locationController = TextEditingController();
    concernController = TextEditingController();
  }

  Widget _query1() {
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
                controller: locationController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Location',
                ),
              ),
            ),
            DropdownMenu<String>(
              initialSelection: dropdownValue,
              onSelected: (String? value) {
                setState(() {
                  dropdownValue =
                      value!; // Update dropdownValue with the selected value
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
                String? location = locationController?.text;

                setState(() {
                  _sendQuery1(location, dropdownValue, _image);
                  locationController!.clear(); // Clear the text field
                  dropdownValue = list.first;
                  _image = null;
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

  Widget _query3() {
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
                'Let’s see what that plant looks like.',
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
                'Upload an image of the plant you want me to identify.',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Inter',
                ),
                textAlign: TextAlign.left,
              ),
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
                  _sendQuery3(_image);
                  _image = null;
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

  Widget _query2() {
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
                'Let me know how I can help with your farm.',
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
                'Send me an image of your farm, and describe important details there.',
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
                String? concern = concernController?.text;

                setState(() {
                  _sendQuery2(concern, _image);
                  concernController!.clear(); // Clear the text field
                  _image = null;
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
                _showQuery2 = true;
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
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _showQuery3 = true;
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
                  onPressed: () {
                    setState(() {
                      _showBuildUI = false;
                      _showQuery1 = true;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('I need help setting up my Farm'),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.green), // Set background color to green
                    foregroundColor: MaterialStateProperty.all<Color>(
                        Colors.white), // Set text color to white
                  ),
                  onPressed: () {
                    setState(() {
                      _showBuildUI = false;
                      _showQuery2 = true;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('I need help taking care of my plant'),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.green), // Set background color to green
                    foregroundColor: MaterialStateProperty.all<Color>(
                        Colors.white), // Set text color to white
                  ),
                  onPressed: () {
                    setState(() {
                      _showBuildUI = false;
                      _showQuery3 = true;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('I need help identifying a plant'),
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
