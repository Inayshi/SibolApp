import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:urban_farming/core/dialogs.dart';
import 'package:urban_farming/services/auth_service.dart';
import 'package:urban_farming/widgets/note_icon_button_outlined.dart';

String _formatTime(DateTime time) {
  String period = 'AM';
  int hour = time.hour;

  if (hour >= 12) {
    period = 'PM';
    if (hour > 12) {
      hour -= 12;
    }
  }
  if (hour == 0) {
    hour = 12;
  }

  return '${hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} $period';
}

class ForumPage extends StatelessWidget {
  void _showAddPostModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Ensures the modal is centered
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) => _buildAddPostModal(context),
    );
  }

  Widget _buildAddPostModal(BuildContext context) {
    TextEditingController postController = TextEditingController();

    void saveForumData() async {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String firstName = '';
        String lastName = '';

        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        print('User Document Data: ${userDoc.data()}');

        if (userDoc.exists) {
          Map<String, dynamic>? userData =
              userDoc.data() as Map<String, dynamic>?;

          if (userData != null) {
            firstName = userData['firstName'] ?? '';
            lastName = userData['lastName'] ?? '';
          }
        }

        print('First Name: $firstName');
        print('Last Name: $lastName');

        String postText = postController.text;

        FirebaseFirestore.instance.collection('forums').add({
          'firstName': firstName,
          'lastName': lastName,
          'post': postText,
          'likesCount': 0,
          'commentsCount': 0,
          'timestamp': Timestamp.now(),
        }).then((value) {
          print('Data saved successfully');
          Navigator.pop(context);
        }).catchError((error) {
          print('Failed to save data: $error');
        });
      }
    }

    return Container(
      height: 600,
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            children: [
              const Spacer(),
              ElevatedButton(
                onPressed: saveForumData,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green[700],
                ),
                child: Text('Add Post'),
              ),
              const SizedBox(width: 15.0),
              ElevatedButton(
                child: const Text('X'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          Align(
            alignment: Alignment.centerLeft, // Align the text to the left
            child: Text(
              "Add Post",
              style: const TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0), // Set border radius
              border: Border.all(), // Optionally add a border
            ),
            child: TextField(
              controller: postController,
              decoration: InputDecoration(
                border: InputBorder.none, // Hide default border
                contentPadding: EdgeInsets.all(10.0), // Add padding
                labelText: "Add Posts",
              ),
              onSubmitted: (value) {
                // Process the submitted text here
                print("Submitted text: $value");
                // You can save the text to your data model or perform any other action
              },
            ),
          ),
        ],
      ),
    );
  }

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
              'Forums',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                color: Color.fromARGB(
                    255, 23, 90, 25), // Custom color with hexadecimal value
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              _showAddPostModal(context);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('forums').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Text('No forums available.');
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var forumData = snapshot.data!.docs[index].data()
                          as Map<String, dynamic>;
                      var forumId = snapshot.data!.docs[index].id;

                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text((forumData['firstName'] ?? '') +
                              ' ' +
                              (forumData['lastName'] ?? '')),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_formatTime(forumData['timestamp'].toDate())}',
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.95,
                                height: MediaQuery.of(context).size.width * 0.5,
                                margin: EdgeInsets.symmetric(vertical: 8),
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.green[900],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    forumData['post'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ),
                              SizedBox(height: 2),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.thumb_up,
                                        size: 15, color: Colors.green[900]),
                                    onPressed: () {
                                      likePost(forumId);
                                    },
                                  ),
                                  SizedBox(width: 2),
                                  Text(forumData['likesCount'].toString()),
                                  SizedBox(width: 20),
                                  IconButton(
                                    icon: Icon(Icons.message,
                                        size: 15, color: Colors.green[900]),
                                    onPressed: () {
                                      void viewComments(String forumId) {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext context) {
                                            TextEditingController
                                                commentController =
                                                TextEditingController();

                                            void addComment() async {
                                              String commentText =
                                                  commentController.text.trim();
                                              if (commentText.isNotEmpty) {
                                                FirebaseFirestore.instance
                                                    .collection('comments')
                                                    .add({
                                                  'postId': forumId,
                                                  'commentText': commentText,
                                                  'userId': FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .uid,
                                                  'timestamp': Timestamp.now(),
                                                });
                                                await FirebaseFirestore.instance
                                                    .collection('forums')
                                                    .doc(forumId)
                                                    .update({
                                                  'commentsCount':
                                                      FieldValue.increment(1),
                                                });

                                                commentController.clear();
                                                Navigator.pop(context);
                                              }
                                            }

                                            return Container(
                                              padding: EdgeInsets.all(20.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  StreamBuilder<QuerySnapshot>(
                                                    stream: FirebaseFirestore
                                                        .instance
                                                        .collection('comments')
                                                        .where('postId',
                                                            isEqualTo: forumId)
                                                        .orderBy('timestamp',
                                                            descending: true)
                                                        .snapshots(),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .waiting) {
                                                        return CircularProgressIndicator();
                                                      }
                                                      if (snapshot.hasError) {
                                                        return Text(
                                                            'Error: ${snapshot.error}');
                                                      }
                                                      if (!snapshot.hasData ||
                                                          snapshot.data!.docs
                                                              .isEmpty) {
                                                        return Text('');
                                                      }
                                                      return Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: snapshot
                                                            .data!.docs
                                                            .map((commentDoc) {
                                                          Map<String, dynamic>
                                                              commentData =
                                                              commentDoc.data()
                                                                  as Map<String,
                                                                      dynamic>;
                                                          return FutureBuilder<
                                                              DocumentSnapshot>(
                                                            future: FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'users')
                                                                .doc(commentData[
                                                                    'userId'])
                                                                .get(),
                                                            builder: (context,
                                                                snapshot) {
                                                              if (snapshot
                                                                      .connectionState ==
                                                                  ConnectionState
                                                                      .waiting) {
                                                                return ListTile(
                                                                  title: Text(
                                                                      commentData[
                                                                          'commentText']),
                                                                  subtitle: Text(
                                                                      'Loading...'),
                                                                );
                                                              }
                                                              if (snapshot
                                                                      .hasError ||
                                                                  !snapshot
                                                                      .hasData ||
                                                                  !snapshot
                                                                      .data!
                                                                      .exists) {
                                                                return ListTile(
                                                                  title: Text(
                                                                      commentData[
                                                                          'commentText']),
                                                                  subtitle: Text(
                                                                      'User not found'),
                                                                );
                                                              }
                                                              var userData = snapshot
                                                                      .data!
                                                                      .data()
                                                                  as Map<String,
                                                                      dynamic>?; // Cast to expected type
                                                              if (userData ==
                                                                  null) {
                                                                return ListTile(
                                                                  title: Text(
                                                                      commentData[
                                                                          'commentText']),
                                                                  subtitle: Text(
                                                                      'User data not available'),
                                                                );
                                                              }
                                                              return ListTile(
                                                                title: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      '${userData['firstName']} ${userData['lastName']}',
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    SizedBox(
                                                                        height:
                                                                            4),
                                                                    Text(
                                                                      commentData[
                                                                          'commentText'],
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.grey[600]),
                                                                    ),
                                                                    SizedBox(
                                                                        height:
                                                                            4),
                                                                    Text(
                                                                      _formatTime((commentData['timestamp']
                                                                              as Timestamp)
                                                                          .toDate()),
                                                                      style: TextStyle(
                                                                          color: Colors.grey[
                                                                              400],
                                                                          fontSize:
                                                                              12),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        }).toList(),
                                                      );
                                                    },
                                                  ),
                                                  TextField(
                                                    controller:
                                                        commentController,
                                                    decoration: InputDecoration(
                                                      hintText:
                                                          'Add a comment...',
                                                      suffixIcon: IconButton(
                                                        icon: Icon(Icons.send),
                                                        onPressed: addComment,
                                                      ),
                                                    ),
                                                    onSubmitted: (_) =>
                                                        addComment(),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      }

                                      viewComments(forumId);
                                    },
                                  ),
                                  Text(forumData['commentsCount'].toString()),
                                ],
                              ),
                              SizedBox(height: 2),
                            ],
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
    );
  }

  Future<void> likePost(String postId) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      bool alreadyLiked = await hasLikedPost(postId, user.uid);
      if (!alreadyLiked) {
        await FirebaseFirestore.instance
            .collection('forums')
            .doc(postId)
            .update({
          'likesCount': FieldValue.increment(1),
        });
        await FirebaseFirestore.instance
            .collection('likes')
            .doc('${postId}_${user.uid}')
            .set({
          'postId': postId,
          'userId': user.uid,
          'timestamp': FieldValue.serverTimestamp(),
        });
      } else {
        print('User already liked this post.');
      }
    }
  }

  Future<bool> hasLikedPost(String postId, String userId) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('likes')
        .where('postId', isEqualTo: postId)
        .where('userId', isEqualTo: userId)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  void commentOnPost(String postId) async {
    await FirebaseFirestore.instance.collection('forums').doc(postId).update({
      'commentsCount': FieldValue.increment(1),
    });
  }
}
