import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_edit_note_event.freezed.dart';

/*
  메모 작성/편집 화면에서 발생할 수 있는 이벤트 정의
  1. 색상변경,
  2. 노트 저장
 */
@freezed
abstract class AddEditNoteEvent<T> with _$AddEditNoteEvent {
  const factory AddEditNoteEvent.changeColor(int color) = ChangeColor;
  // 노트 저장 이벤트는 원시 타입으로 작성.
  // 메인에서 id 없이 진입하거나 특정 메모 선택해서 진입할 수 있어서 id는 nullable
  const factory AddEditNoteEvent.saveNote(
      int? id, String title, String content) = SaveNote;
}
