import 'package:flutter_note/domain/model/note.dart';
import 'package:flutter_note/domain/util/note_order.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notes_state.freezed.dart';

@freezed
class NotesState with _$NotesState {
  factory NotesState({
    // 초기값을 제공하고자 할 경우 : @Default([]) List<Note> notes,
    required List<Note> notes,
    required NoteOrder noteOrder,
    required bool isOrderSectionVisible,
  }) = _NotesState;
}
