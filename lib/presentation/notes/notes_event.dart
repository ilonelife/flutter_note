import 'package:flutter_note/domain/model/note.dart';
import 'package:flutter_note/domain/util/note_order.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notes_event.freezed.dart';

/*note 메인 화면 view model 에서 처리할 이벤트들
  전체 이벤트 및 앞으로 추가될 수 있는 이벤트도 놓치지 않고 고려한 설계
  freezed 봉인 클래스 사용함
 */
@freezed
abstract class NotesEvent with _$NotesEvent {
  const factory NotesEvent.loadNotes() = LoadNotes;
  const factory NotesEvent.deleteNote(Note note) = DeleteNote;
  const factory NotesEvent.restoreNote() = RestoreNote;
  const factory NotesEvent.changeOrder(NoteOrder noteOrder) = ChangeOrder;
  const factory NotesEvent.toggleOrderSection() = ToggleOrderSection;
}
