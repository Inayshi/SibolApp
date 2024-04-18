import 'package:flutter/material.dart';
import 'package:urban_farming/components/ai_assist/farm_setup.dart';
import 'package:urban_farming/components/ai_assist/plant_identifier.dart';
import 'components/ai_assist/plant_care.dart';

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
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/images/sibol.png'), // Replace with your logo image
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width: 8), // Add some spacing between logo and title
            Text(
              'AI Assist',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                color: Color.fromARGB(
                    255, 23, 90, 25), // Custom color with hexadecimal value
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 100),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: Text(
                'Hi there, how I can help you?',
                style: TextStyle(
                    color: Color.fromARGB(255, 23, 90, 25),
                    fontSize: 50,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w900),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FarmSetupPage()),
                );
              },
              child: Text(
                'I need help setting up my farm',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                fixedSize: Size(350, 60),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const IdentifyPlantPage()),
                );
              },
              child: Text(
                'I need help identifying a plant',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                fixedSize: Size(350, 60),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PlantCarePage()),
                );
              },
              child: Text(
                'I need help with my plant',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                fixedSize: Size(350, 60),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
