import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/firebase_service/firebase_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _titleController = TextEditingController();
  FirebaseService firebaseService = FirebaseService();

  void openAlertBox({String? docId, String? title}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: TextField(controller: _titleController..text = title ?? '', ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (docId != null) {
                  firebaseService.updateNote(docId, _titleController.text);
                }
                else {
                  firebaseService.addNote(_titleController.text);
                }                
                Navigator.pop(context);
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: firebaseService.getNotes(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List notesList = snapshot.data!.docs;
            return ListView.builder(
              itemBuilder: (context, index) {
                DocumentSnapshot document = notesList[index];
                String docId = document.id;
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                return ListTile(
                  title: Text(data['title']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          openAlertBox(docId: docId, title: data['title']);
                        },
                        icon: Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () {
                          firebaseService.deleteNote(docId);
                        },
                        icon: Icon(Icons.delete),
                      ),
                    ],
                  ),
                );
              },
              itemCount: notesList.length,
            );
          }
          return Center(child: Text("No data"));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openAlertBox,
        child: Icon(Icons.add),
      ),
    );
  }
}
