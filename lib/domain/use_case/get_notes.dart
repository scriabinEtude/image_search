import 'package:image_search/domain/model/note.dart';
import 'package:image_search/domain/repository/note_repository.dart';

class GetNotes {
  final NoteRepository repository;
  const GetNotes(this.repository);

  Future<List<Note>> call() async {
    List<Note> notes = await repository.getNotes();
    return notes;
  }
}
