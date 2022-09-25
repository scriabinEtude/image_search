import 'package:flutter/material.dart';
import 'package:image_search/presentation/add_edit_note/add_edit_note_screen.dart';
import 'package:image_search/presentation/notes/components/note_item.dart';
import 'package:image_search/presentation/notes/notes_event.dart';
import 'package:image_search/presentation/notes/notes_view_model.dart';
import 'package:provider/provider.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<NotesViewModel>();
    final state = viewModel.state;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your note',
          style: TextStyle(fontSize: 30),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.sort),
          )
        ],
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool? isSaved = await Navigator.push(context,
              MaterialPageRoute(builder: ((context) => AddEditNoteScreen())));
          if (isSaved == true) {
            viewModel.onEvent(const NotesEvent.loadNotes());
          }
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: state.notes
              .map((note) => InkWell(
                    onTap: () async {
                      bool? isSaved = await Navigator.push(context,
                          MaterialPageRoute(builder: ((context) {
                        return AddEditNoteScreen(note: note);
                      })));

                      if (isSaved == true) {
                        viewModel.onEvent(const NotesEvent.loadNotes());
                      }
                    },
                    child: NoteItem(
                      note: note,
                      onDeleteTap: () {
                        viewModel.onEvent(NotesEvent.deleteNote(note));
                        final snackBar = SnackBar(
                          content: Text('note was deleted'),
                          action: SnackBarAction(
                            label: 'cancel',
                            onPressed: () {
                              viewModel.onEvent(const NotesEvent.restoreNote());
                            },
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
