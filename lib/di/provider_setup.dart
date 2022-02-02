import 'package:flutter_note/data/data_source/note_db_helper.dart';
import 'package:flutter_note/data/repository/note_repository_impl.dart';
import 'package:flutter_note/domain/repository/note_repository.dart';
import 'package:flutter_note/presentation/add_edit_note/add_edit_note_view_model.dart';
import 'package:flutter_note/presentation/notes/notes_view_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sqflite/sqflite.dart';

/*
  의존성 관리
  top-level 함수를 만듬
 */
Future<List<SingleChildWidget>> getProviders() async {
  // 'notes_db'은 파일명,  'note' 테이블 생성
  Database database = await openDatabase(
    'notes_db',
    version: 1,
    onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE note (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, '
          'content TEXT, color INTEGER, timestamp INTEGER)');
    },
  );

  NoteDbHelper noteDbHelper = NoteDbHelper(database);
  NoteRepository repository = NoteRepositoryImpl(noteDbHelper);
  NotesViewModel notesViewModel = NotesViewModel(repository);
  AddEditNoteViewModel addEditNoteViewModel = AddEditNoteViewModel(repository);

  return [
    ChangeNotifierProvider(create: (_) => notesViewModel),
    ChangeNotifierProvider(create: (_) => addEditNoteViewModel),
  ];
}

/*  main의 MyApp 이전에 DB가 생성되어야 해서
    위의 코드로 변경함
List<SingleChildWidget> globalProviders = [
  ...independentModels,
  ...dependentModels,
  ...viewModels,
];

List<SingleChildWidget> independentModels = [
  FutureProvider<Database>(create: (_) {}, initialData: (){}),
];

List<SingleChildWidget> dependentModels = [];

List<SingleChildWidget> viewModels = [];
*/
