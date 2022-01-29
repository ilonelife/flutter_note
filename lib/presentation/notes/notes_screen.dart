import 'package:flutter/material.dart';
import 'package:flutter_note/domain/model/note.dart';
import 'package:flutter_note/presentation/add_edit_note/add_edit_note_screen.dart';
import 'package:flutter_note/presentation/notes/components/note_item.dart';
import 'package:flutter_note/ui/colors.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your note',
          style: TextStyle(fontSize: 30.0),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.sort),
          )
        ],
        elevation: 0.0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEditNoteScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: ListView(
        children: [
          NoteItem(
            note: Note(
              title: 'title1',
              content: 'content',
              color: wisteria.value,
              timestamp: 1,
            ),
          ),
          NoteItem(
            note: Note(
              title: 'title2',
              content: 'content 2',
              color: skyBlue.value,
              timestamp: 2,
            ),
          ),
        ],
      ),
    );
  }
}
