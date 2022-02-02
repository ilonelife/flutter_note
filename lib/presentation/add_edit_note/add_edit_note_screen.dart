import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_note/domain/model/note.dart';
import 'package:flutter_note/presentation/add_edit_note/add_edit_note_event.dart';
import 'package:flutter_note/presentation/add_edit_note/add_edit_note_view_model.dart';
import 'package:flutter_note/ui/colors.dart';
import 'package:provider/provider.dart';

class AddEditNoteScreen extends StatefulWidget {
  final Note? note;

  const AddEditNoteScreen({Key? key, this.note}) : super(key: key);

  @override
  State<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  StreamSubscription? _streamSubscription;

  final List<Color> noteColors = [
    roseBud,
    primrose,
    wisteria,
    skyBlue,
    illusion,
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // 기존 메모를 선택해서 에디트 화면으로 이동한 경우
    // 기존 메모 내용을 표시하게 처리함
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }

    Future.microtask(() {
      // 새 메모 작성하고 저장 버튼 누르면 해당 이벤트를 처리하는 로직
      // 메모 작성 화면을 닫음(pop),
      // 저장 버튼을 눌렀을 경우 pop(context, true),  백 버튼의 경우와 구분되게 처리함
      final viewModel = context.read<AddEditNoteViewModel>();
      _streamSubscription = viewModel.eventStream.listen((event) {
        event.when(saveNote: () {
          Navigator.pop(context, true);
        }, showSnackBar: (String message) {
          final snackBar = SnackBar(content: Text(message));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AddEditNoteViewModel>();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          /*
            내용이나 제목이 없으면 스낵바로 에러 출력하는 로직
            viewModel에서 구현하기 위해 옮김
           */
          // if (_titleController.text.isEmpty ||
          //     _contentController.text.isEmpty) {
          //   const snackBar = SnackBar(content: Text('제목이나 내용이 없습니다'));
          //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
          //   return;
          // }

          // 새 노트를 저장한다. id가 null이면 null, 아니면  id 전달
          viewModel.onEvent(
            AddEditNoteEvent.saveNote(
                widget.note == null ? null : widget.note!.id,
                _titleController.text,
                _contentController.text),
          );
        },
        child: const Icon(Icons.save),
      ),
      body: AnimatedContainer(
        padding:
            const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 48),
        color: Color(viewModel.color),
        duration: const Duration(milliseconds: 500),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: noteColors
                  .map(
                    (color) => InkWell(
                      onTap: () {
                        viewModel
                            .onEvent(AddEditNoteEvent.changeColor(color.value));
                      },
                      child: _buildBackgroundColor(
                        color: color,
                        selected: viewModel.color == color.value,
                      ),
                    ),
                  )
                  .toList(),
            ),
            TextField(
              controller: _titleController,
              maxLines: 1,
              style: Theme.of(context)
                  .textTheme
                  .headline5!
                  .copyWith(color: darkGray),
              decoration: const InputDecoration(
                hintText: '제목을 입력하세요',
                border: InputBorder.none,
              ),
            ),
            TextField(
              controller: _contentController,
              maxLines: null,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: darkGray),
              decoration: const InputDecoration(
                hintText: '내용을 입력하세요',
                border: InputBorder.none,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundColor({
    required Color color,
    required bool selected,
  }) {
    return Container(
      height: 32,
      width: 32,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 3.0,
              spreadRadius: 0.2),
        ],
        border: selected
            ? Border.all(
                color: Colors.black,
                width: 1.0,
              )
            : null,
      ),
    );
  }
}
