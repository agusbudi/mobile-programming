import 'package:crud_local_database_app/models/note.dart';
import 'package:flutter/cupertino.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class NoteDatabase extends ChangeNotifier{
  static late Isar isar;

  // INIT
  static Future<void> initialize() async {
    if (Platform.isAndroid) { // Check if it's Android
      final dir = await getApplicationDocumentsDirectory();
      isar = await Isar.open([NoteSchema], directory: dir.path);
    } else {
      // Handle other platforms or provide a default directory
      final dir = getTemporaryDirectory(); // Example for other platforms
      isar = await Isar.open([NoteSchema], directory: (await dir).path);
    }
  }

  // list
  final List<Note> currentNotes = [];

  // create
  void addNote(String text, String imagePath) async {
    final note = Note()
      ..text = text
      ..imagePath = imagePath;

    await isar.writeTxn(() async {
      await isar.notes.put(note);
    });

    fetchNotes(); // refresh notes list
  }
  // read
  Future<void> fetchNotes() async {
    List<Note> fetchedNotes = await isar.notes.where().findAll();
    currentNotes.clear();
    currentNotes.addAll(fetchedNotes);
    notifyListeners();
  }
  // update
  Future<void> updateNote(int id, String newText) async {
    final existingNote = await isar.notes.get(id);
    if (existingNote != null) {
      existingNote.text = newText;
      await isar.writeTxn(() => isar.notes.put(existingNote));
      await fetchNotes();
    }
  }
  // delete
  Future<void> deleteNote(int id) async {
    await isar.writeTxn(() => isar.notes.delete(id));
    await fetchNotes();
  }
}