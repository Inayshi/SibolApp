import 'package:flutter/material.dart';

class AiAssistPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // Logo widget (replace Container with your logo widget)
            Container(
              width: 40, // Adjust width as needed
              height: 40, // Adjust height as needed
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/images/logo.png'), // Replace with your logo image
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(width: 8), // Add some spacing between logo and title
            Text('AI Assist'), // Title text
          ],
        ),
        actions: [
          // Exit icon button
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              // Add navigation logic to exit the page
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              'Hi there, how I can help you?',
              style: TextStyle(
                  fontSize: 50,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: Text('I need help setting up my farm'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              child: Text('I need help identifying a plant'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              child: Text('I need help with taking care of my farm'),
            ),
          ],
        ),
      ),
    );
  }
}
