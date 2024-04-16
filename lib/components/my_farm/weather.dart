import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String location = ''; // User input location
  String apiKey = 'YOUR_API_KEY'; // Your weather API key

  String weather = '';
  int humidity = 0;
  double windSpeed = 0;

  Future<void> fetchWeatherData() async {
    final url = 'https://api.openweathermap.org/data/2.5/weather?q=$location&appid=$apiKey';
    final response = await http.get(Uri.parse(url));
    final responseData = json.decode(response.body);
    
    setState(() {
      weather = responseData['weather'][0]['main'];
      humidity = responseData['main']['humidity'];
      windSpeed = responseData['wind']['speed'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  location = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Enter Location',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                fetchWeatherData();
              },
              child: Text('Get Weather'),
            ),
            SizedBox(height: 20),
            Text('Weather: $weather'),
            Text('Humidity: $humidity'),
            Text('Wind Speed: $windSpeed'),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: WeatherScreen(),
  ));
}
