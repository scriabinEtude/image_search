import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_search/domain/model/note.dart';
import 'package:image_search/presentation/add_edit_note/add_edit_note_event.dart';
import 'package:image_search/presentation/add_edit_note/add_edit_note_ui_event.dart';
import 'package:image_search/presentation/add_edit_note/add_edit_note_view_model.dart';
import 'package:image_search/ui/colors.dart';
import 'package:provider/provider.dart';

class AddEditNoteScreen extends StatefulWidget {
  Note? note;
  AddEditNoteScreen({
    super.key,
    this.note,
  });

  @override
  State<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  StreamSubscription? _streamSubscription;

  @override
  void initState() {
    super.initState();

    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }

    Future.microtask(() {
      final viewModel = context.read<AddEditNoteViewModel>();

      _streamSubscription = viewModel.eventStream.listen((event) {
        event.when(
          saveNote: () {
            Navigator.pop(context, true);
          },
          showSnackBar: ((message) {
            final snackBar = SnackBar(content: Text(message));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }),
        );
      });
    });
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AddEditNoteViewModel>();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          viewModel.onEvent(AddEditNoteEvent.saveNote(
            widget.note == null ? null : widget.note!.id,
            _titleController.text,
            _contentController.text,
          ));
        },
        child: const Icon(Icons.save),
      ),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
        color: Color(viewModel.color),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: noteColors
                  .map((color) => InkWell(
                        onTap: () {
                          viewModel.onEvent(
                              AddEditNoteEvent.changeColor(color.value));
                        },
                        child: _buildBackgroundColor(
                          color: color,
                          selected: viewModel.color == color.value,
                        ),
                      ))
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
            )
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
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5.0,
            spreadRadius: 1.0,
          )
        ],
        border: selected
            ? Border.all(
                color: Colors.black,
                width: 2.0,
              )
            : null,
      ),
    );
  }
}
