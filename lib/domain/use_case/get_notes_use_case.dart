import 'package:image_search/domain/model/note.dart';
import 'package:image_search/domain/repository/note_repository.dart';

class GetNotesUseCase {
  final NoteRepository repository;
  const GetNotesUseCase(this.repository);

  Future<List<Note>> call() async {
    List<Note> notes = await repository.getNotes();
    notes.sort(((a, b) => -a.timestamp.compareTo(b.timestamp)));
    return notes;
  }
}
