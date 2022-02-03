import 'package:flutter/material.dart';
import 'package:flutter_note/domain/model/note.dart';
import 'package:flutter_note/ui/colors.dart';

class NoteItem extends StatelessWidget {
  final Note note;
  final Function? onDeleteTap;

  const NoteItem({Key? key, required this.note, this.onDeleteTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Color(note.color),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note.title,
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .apply(color: Colors.black),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  note.content,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .apply(color: darkGray),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 8,
            right: 8,
            child: GestureDetector(
              onTap: () {
                onDeleteTap?.call();
              },
              child: const Icon(
                Icons.delete,
                color: darkGray,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
