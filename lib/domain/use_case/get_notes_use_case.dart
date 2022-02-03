import 'package:flutter_note/domain/model/note.dart';
import 'package:flutter_note/domain/repository/note_repository.dart';
import 'package:flutter_note/domain/util/note_order.dart';

/*
enum NoteOrder {
  title, date, color,
}

enum OrderType {
  ascending, descending,
}
*/

class GetNotesUseCase {
  final NoteRepository repository;

  GetNotesUseCase(this.repository);

  //OrderType과 연관성을 만들었기 때문에, NotdOrder만 받을 수 있다
  Future<List<Note>> call(NoteOrder noteOrder) async {
    List<Note> notes = await repository.getNotes();

    noteOrder.when(
      title: (orderType) {
        orderType.when(ascending: () {
          notes.sort((a, b) => a.title.compareTo(b.title));
        }, descending: () {
          notes.sort((a, b) => -a.title.compareTo(b.title));
        });
      },
      color: (orderType) {
        orderType.when(ascending: () {
          notes.sort((a, b) => a.color.compareTo(b.color));
        }, descending: () {
          notes.sort((a, b) => -a.color.compareTo(b.color));
        });
      },
      date: (orderType) {
        orderType.when(ascending: () {
          notes.sort((a, b) => a.timestamp.compareTo(b.timestamp));
        }, descending: () {
          notes.sort((a, b) => -a.timestamp.compareTo(b.timestamp));
        });
      },
    );

    return notes;
  }
}
