import 'package:flutter/material.dart';
import 'package:flutter_note/presentation/add_edit_note/add_edit_note_screen.dart';
import 'package:flutter_note/presentation/notes/components/note_item.dart';
import 'package:flutter_note/presentation/notes/notes_event.dart';
import 'package:flutter_note/presentation/notes/notes_view_model.dart';
import 'package:provider/provider.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<NotesViewModel>();
    final state = viewModel.state;

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
        onPressed: () async {
          bool? isSaved = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEditNoteScreen()),
          );

          // 새로고침
          if (isSaved != null && isSaved) {
            viewModel.onEvent(const NotesEvent.loadNotes());
          }
        },
        child: const Icon(Icons.add),
      ),
      body: ListView(
        children: state.notes
            .map(
              (note) => NoteItem(
                note: note,
              ),
            )
            .toList(),
      ),
    );
  }
}
