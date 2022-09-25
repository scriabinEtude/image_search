import 'package:flutter/cupertino.dart';
import 'package:image_search/domain/repository/note_repository.dart';

class NotesViewModel with ChangeNotifier {
  final NoteRepository repository;

  NotesViewModel(this.repository);
}
