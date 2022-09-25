import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_search/domain/model/note.dart';
import 'package:image_search/domain/repository/note_repository.dart';
import 'package:image_search/presentation/add_edit_note/add_edit_note_event.dart';
import 'package:image_search/presentation/add_edit_note/add_edit_note_ui_event.dart';
import 'package:image_search/ui/colors.dart';

class AddEditNoteViewModel with ChangeNotifier {
  final NoteRepository repository;
  AddEditNoteViewModel(this.repository);

  int _color = roseBud.value;
  int get color => _color;

  final _eventController = StreamController<AddEditNoteUiEvent>.broadcast();
  Stream<AddEditNoteUiEvent> get eventStream => _eventController.stream;

  void onEvent(AddEditNoteEvent event) {
    event.when(
      changeColor: _changeColor,
      saveNote: _saveNote,
    );
  }

  Future<void> _changeColor(int color) async {
    _color = color;
    notifyListeners();
  }

  Future<void> _saveNote(int? id, String title, String content) async {
    if (title.isEmpty || content.isEmpty) {
      _eventController
          .add(AddEditNoteUiEvent.showSnackBar('title or content are empty'));
      return;
    }

    if (id == null) {
      repository.insertNote(Note(
        title: title,
        content: content,
        color: _color,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ));
    } else {
      await repository.updateNote(Note(
        id: id,
        title: title,
        content: content,
        color: _color,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ));
    }

    _eventController.add(AddEditNoteUiEvent.saveNote());
  }
}
