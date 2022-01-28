import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'note.freezed.dart';
part 'note.g.dart';

/*
불변 객체, toJson/fromJson, copy 매서드 만들기 위해 freezed 사용
 */
@freezed
class Note with _$Note {
  factory Note({
    required String title,
    required String content,
    required int color,
    required int timestamp,
    int? id,
  }) = _Note;

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);
}
