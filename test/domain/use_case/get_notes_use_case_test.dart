import 'package:flutter_note/domain/model/note.dart';
import 'package:flutter_note/domain/repository/note_repository.dart';
import 'package:flutter_note/domain/use_case/get_notes_use_case.dart';
import 'package:flutter_note/domain/util/note_order.dart';
import 'package:flutter_note/domain/util/order_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_notes_use_case_test.mocks.dart';

@GenerateMocks([NoteRepository])
void main() {
  test('정렬 기능 동작 테스트', () async {
    final repository = MockNoteRepository();
    final getNotes = GetNotesUseCase(repository);

    // 동작 정의
    when(repository.getNotes()).thenAnswer((_) async => [
          Note(title: 'title', content: 'content', timestamp: 0, color: 1),
          Note(title: 'title2', content: 'content2', timestamp: 2, color: 2),
        ]);

    List<Note> result =
        await getNotes(const NoteOrder.date(OrderType.descending()));
    expect(result, isA<List<Note>>());
    expect(result.first.timestamp, 2);
    verify(repository.getNotes());

    result = await getNotes(const NoteOrder.date(OrderType.ascending()));
    expect(result.first.timestamp, 0);
    verify(repository.getNotes());

    result = await getNotes(const NoteOrder.title(OrderType.ascending()));
    expect(result.first.title, 'title');
    verify(repository.getNotes());

    result = await getNotes(const NoteOrder.title(OrderType.descending()));
    expect(result.first.color, 2);
    verify(repository.getNotes());

    verifyNoMoreInteractions(repository);
  });
}
