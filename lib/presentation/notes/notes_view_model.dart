import 'package:flutter/material.dart';
import 'package:flutter_note/domain/model/note.dart';
import 'package:flutter_note/domain/repository/note_repository.dart';
import 'package:flutter_note/presentation/notes/notes_event.dart';
import 'package:flutter_note/presentation/notes/notes_state.dart';

class NotesViewModel with ChangeNotifier {
  final NoteRepository repository;

  // NotesState _state = NotesState();  => @Default 사용해서 초기화 했을 경우..
  NotesState _state = NotesState(notes: []);

  NotesState get state => _state;

  // 위의 NotesState를 사용해서 대체함..
  // List<Note> _notes = [];
  // UnmodifiableListView<Note> get notes => UnmodifiableListView(_notes);

  Note? _recentlyDeletedNote;

  NotesViewModel(this.repository);

  void onEvent(NotesEvent event) {
    event.when(
      loadNotes: _loadNotes,
      deleteNote: _deleteNote,
      restoreNote: _restoreNote,
    );
  }

  Future<void> _loadNotes() async {
    List<Note> notes = await repository.getNotes();
    _state = state.copyWith(notes: notes);
    notifyListeners();
  }

  Future<void> _deleteNote(Note note) async {
    await repository.deleteNote(note);
    _recentlyDeletedNote = note;
    await _loadNotes();
  }

  Future<void> _restoreNote() async {
    if (_recentlyDeletedNote != null) {
      await repository.insertNote(_recentlyDeletedNote!);
      _recentlyDeletedNote = null;

      _loadNotes();
    }
  }
}
