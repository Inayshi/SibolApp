import 'package:flutter/material.dart';
import 'package:urban_farming/ai_assist.dart';
import 'package:urban_farming/components/ai_assist/farm_setup.dart';
import 'package:urban_farming/components/my_farm/new_plant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyFarm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/sibol.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'My Farm',
              style: TextStyle(
                fontSize: 20,
                color: Color.fromARGB(255, 23, 90, 25),
              ),
            ),
          ],
        ),
        actions: [
          // Exit icon button
          IconButton(
            icon: const Icon(
              Icons.exit_to_app,
              color: Color.fromARGB(255, 23, 90, 25),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Plants',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 23, 90, 25),
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NewPlant()),
                      );
                    },
                    icon: Icon(Icons.add, color: Colors.white),
                    label: Text('Add Plant',
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('MyPlants')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }
                    final plants = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: plants.length,
                      itemBuilder: (context, index) {
                        final plant = plants[index];
                        final name = plant['name'];
                        final plantType = plant['plant_type'];
                        final soilType = plant['soil_type'];
                        final water = plant['water'];
                        final image = plant['image_url'];

                        return Card(
                          color: Colors.white,
                          elevation: 4,
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(
                                  name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 23, 90, 25),
                                  ),
                                ),
                                subtitle: Text(
                                    'Plant Type: $plantType\nSoil Type: $soilType\nWater $water times per week'),
                                leading: Image.network(image),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Guides',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 23, 90, 25),
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FarmSetupPage()),
                      );
                    },
                    icon: Icon(Icons.add, color: Colors.white),
                    label: Text('Create Guide',
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Saved_Guides')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }
                    final guides = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: guides.length,
                      itemBuilder: (context, index) {
                        final guide = guides[index];
                        final title = guide['title'];
                        final response = guide['response'];

                        return GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(title),
                                  content: SingleChildScrollView(
                                    child: Text(response),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Close'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Card(
                            color: Colors.white,
                            elevation: 4,
                            child: ListTile(
                              title: Text(
                                title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 23, 90, 25),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
