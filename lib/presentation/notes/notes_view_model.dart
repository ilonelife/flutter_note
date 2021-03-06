import 'package:flutter/material.dart';
import 'package:flutter_note/domain/model/note.dart';
import 'package:flutter_note/domain/use_case/use_cases.dart';
import 'package:flutter_note/domain/util/note_order.dart';
import 'package:flutter_note/domain/util/order_type.dart';
import 'package:flutter_note/presentation/notes/notes_event.dart';
import 'package:flutter_note/presentation/notes/notes_state.dart';

/*
  노트 메인 화면에서 처리할 기능 제공
  기능 : 기록한 메모 전체 리스트 불러오기, 메모 삭제, 삭제 메모 복구
 */
class NotesViewModel with ChangeNotifier {
  final UseCases useCases;

  NotesViewModel(
    this.useCases,
  ) {
    _loadNotes();
  }

  // 삭제한 노트를 저장할 변수
  Note? _recentlyDeletedNote;

  // NotesState _state = NotesState();  => @Default 사용해서 초기화 했을 경우 사용
  NotesState _state = NotesState(
    notes: [],
    noteOrder: const NoteOrder.date(OrderType.descending()),
    isOrderSectionVisible: false, // 정렬 기본값으로 date 설정함
  );

  NotesState get state => _state;

  // 다양한 상태 관리를 위해서 위의 NotesState 로 대체함..
  // List<Note> _notes = [];
  // UnmodifiableListView<Note> get notes => UnmodifiableListView(_notes);

  // onEvent 를 통해서만 이벤트 실행하도록 함
  // notes_event.dart 에서 정의 함
  void onEvent(NotesEvent event) {
    event.when(
      loadNotes: _loadNotes,
      deleteNote: _deleteNote,
      restoreNote: _restoreNote,
      changeOrder: (NoteOrder noteOrder) {
        _state = state.copyWith(
          noteOrder: noteOrder,
        );
        _loadNotes();
      },
      toggleOrderSection: () {
        _state = state.copyWith(
          isOrderSectionVisible: !state.isOrderSectionVisible,
        );
        notifyListeners();
      },
    );
  }

  // 노트 전체 리스트 가져오기
  Future<void> _loadNotes() async {
    List<Note> notes = await useCases.getNotes(state.noteOrder);
    _state = state.copyWith(
      notes: notes,
    );
    notifyListeners();
  }

  // 휴지통 아이콘으로 해당 노트 삭제하기
  // 삭제한 노트를 되살리기 위해, _recentlyDeleteNote에 저장해 둔다
  Future<void> _deleteNote(Note note) async {
    await useCases.deleteNote(note);
    _recentlyDeletedNote = note;

    await _loadNotes();
  }

  // 삭제한 노트 되살리기
  Future<void> _restoreNote() async {
    if (_recentlyDeletedNote != null) {
      await useCases.addNote(_recentlyDeletedNote!);
      _recentlyDeletedNote = null;

      _loadNotes();
    }
  }
}
