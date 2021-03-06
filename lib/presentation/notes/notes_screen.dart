import 'package:flutter/material.dart';
import 'package:flutter_note/presentation/add_edit_note/add_edit_note_screen.dart';
import 'package:flutter_note/presentation/notes/components/note_item.dart';
import 'package:flutter_note/presentation/notes/components/order_section.dart';
import 'package:flutter_note/presentation/notes/notes_event.dart';
import 'package:flutter_note/presentation/notes/notes_view_model.dart';
import 'package:provider/provider.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<NotesViewModel>();
    final state = viewModel.state;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '노트앱',
          style: TextStyle(fontSize: 30.0),
        ),
        actions: [
          IconButton(
            onPressed: () {
              viewModel.onEvent(const NotesEvent.toggleOrderSection());
            },
            icon: const Icon(Icons.sort),
          )
        ],
        elevation: 0.0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool? isSaved = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEditNoteScreen()),
          );

          // 새 메모 저장 버튼을 눌렀을 경우,
          // 에디트 화면은 pop 시키고, 새로고침 이벤트로 추가된 노트를 표시하게 한다
          if (isSaved != null && isSaved) {
            viewModel.onEvent(const NotesEvent.loadNotes());
          }
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: state.isOrderSectionVisible
                ? OrderSection(
                    noteOrder: viewModel.state.noteOrder,
                    onOrderChanged: (noteOrder) {
                      viewModel.onEvent(NotesEvent.changeOrder(noteOrder));
                    },
                  )
                : Container(),
          ),
          ...state.notes
              .map(
                (note) => GestureDetector(
                  onTap: () async {
                    bool? isSaved = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddEditNoteScreen(
                          note: note,
                        ),
                      ),
                    );
                    // 기존 메모 업데이트에서 저장 버튼을 눌렀을 경우,
                    // 에디트 화면은 pop 시키고, 새로고침 이벤트로 추가된 노트를 표시하게 한다
                    if (isSaved != null && isSaved) {
                      viewModel.onEvent(const NotesEvent.loadNotes());
                    }
                  },
                  child: NoteItem(
                    note: note,
                    onDeleteTap: () {
                      viewModel.onEvent(
                        NotesEvent.deleteNote(note),
                      );

                      final snackBar = SnackBar(
                        content: Text('노트가 삭제되었습니다'),
                        action: SnackBarAction(
                          label: '취소',
                          onPressed: () {
                            viewModel.onEvent(
                              NotesEvent.restoreNote(),
                            );
                          },
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                  ),
                ),
              )
              .toList(),
        ]),
      ),
    );
  }
}
