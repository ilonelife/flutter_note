import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_edit_note_ui_event.freezed.dart';

/*
  화면에서 save 버튼 혹은 back 버튼에 의한 조작 이벤트 처리하기 위해...
 */
@freezed
abstract class AddEditNoteUiEvent with _$AddEditNoteUiEvent {
  const factory AddEditNoteUiEvent.saveNote() = SaveNote;
  const factory AddEditNoteUiEvent.showSnackBar(String message) = ShowSnackBar;
}
