import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_note/domain/model/note.dart';
import 'package:flutter_note/domain/repository/note_repository.dart';
import 'package:flutter_note/presentation/add_edit_note/add_edit_note_event.dart';
import 'package:flutter_note/ui/colors.dart';

import 'add_edit_note_ui_event.dart';

/* 새 메모 작성 화면에서 구현할 동작 제공
  기능 : 화면 색상 변경, 메모 제목/내용 작성 후 저장
 */
class AddEditNoteViewModel with ChangeNotifier {
  final NoteRepository repository;

  AddEditNoteViewModel(this.repository);

  // 메모 작성 화면에서 발생하는 이벤트 처리
  // 색상변경, 메모 저장
  void onEvent(AddEditNoteEvent event) {
    event.when(
      changeColor: _changeColor,
      saveNote: _saveNote,
    );
  }

  // 메모 색상 변수 및 초기값
  int _color = roseBud.value;
  int get color => _color;

  // 저장 버튼과 백 버튼 동작 이벤트 처리하기 위해 stream event 로직
  // 여러번 listen 하기 위해 broadcast 추가
  final _eventController = StreamController<AddEditNoteUiEvent>.broadcast();
  Stream<AddEditNoteUiEvent> get eventStream => _eventController.stream;

  Future<void> _changeColor(int color) async {
    _color = color;
    notifyListeners();
  }

  // 메인 화면에서 메모 작성으로 들어올 경우 id가 없고 신규 작성으로
  // 기존 메모를 변경 작성으로 들어올 경우 id가 있으므로 업데이트 작성으로
  // 2가지 경우로 작성한다
  Future<void> _saveNote(int? id, String title, String content) async {
    if (id == null) {
      await repository.insertNote(
        Note(
            title: title,
            content: content,
            timestamp: DateTime.now().millisecondsSinceEpoch,
            color: _color),
      );
    } else {
      await repository.updateNote(
        Note(
            id: id,
            title: title,
            content: content,
            color: _color,
            timestamp: DateTime.now().millisecondsSinceEpoch),
      );
    }
    // 에디트 화면에서의 노트 저장 이벤트를 등록함
    _eventController.add(const AddEditNoteUiEvent.saveNote());
  }
}
