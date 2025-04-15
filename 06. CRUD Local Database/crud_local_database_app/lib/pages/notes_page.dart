import 'package:crud_local_database_app/models/note.dart';
import 'package:crud_local_database_app/models/note_database.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  // text controller to access what the user typed
  final textController = TextEditingController();
  String? _pickedImagePath;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    readNotes();
  }
  // Pick the image from camera and save it on system
  Future<String?> _pickImageAndSave() async {
    // Pick image using the image picker
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      // Get the directory to save the image
      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'image_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final imagePath = '${directory.path}/$fileName';

      // Save the image to the app's document directory
      final File imageFile = File(imagePath);
      await imageFile.writeAsBytes(await pickedImage.readAsBytes());
      return imagePath;
    }
    return null;
  }

  // create a note
  void createNote() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text("Create Note"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: textController,
                  decoration: const InputDecoration(labelText: "Note text"),
                ),
                const SizedBox(height: 10),
                _pickedImagePath != null
                    ? Image.file(File(_pickedImagePath!), height: 150)
                    : const Text("No image selected"),
                TextButton.icon(
                  onPressed: () async {
                    // Pick and save image
                    final imagePath = await _pickImageAndSave();
                    if (imagePath != null) {
                      setState(() {
                        _pickedImagePath = imagePath;
                        // print("WEYNARD $_pickedImagePath");
                      });
                    }
                  },
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Take Photo"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                textController.clear();
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_pickedImagePath != null && textController.text.isNotEmpty) {
                  // Save the note with the image path
                  context.read<NoteDatabase>().addNote(
                    textController.text,
                    _pickedImagePath!,
                  );
                  textController.clear();
                  _pickedImagePath = null;
                  Navigator.pop(context);
                }
              },
              child: const Text("Create"),
            ),
          ],
        ),
      ),
    );
  }

  // read notes
  void readNotes() {
    context.read<NoteDatabase>().fetchNotes(); // Use read instead of watch
  }

  // update a note
  void updateNote(Note note) {
    textController.text = note.text;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Update Note"),
          content: TextField(controller: textController),
          actions: [
            MaterialButton(
                onPressed: () {
                  context
                      .read<NoteDatabase>()
                      .updateNote(note.id, textController.text);
                  // clear controller
                  textController.clear();

                  Navigator.pop(context);
                },
                child: const Text("Update"))
          ],
        ));
  }

  // delete a note
  void deleteNote(int id) {
    context.read<NoteDatabase>().deleteNote(id);
  }

  @override
  Widget build(BuildContext context) {
    // note database
    final noteDatabase = context.watch<NoteDatabase>();

    // current notes
    List<Note> currentNotes = noteDatabase.currentNotes;

    return Scaffold(
        appBar: AppBar(title: const Text('Notes')),
        floatingActionButton: FloatingActionButton(
          onPressed: createNote,
          child: const Icon(Icons.add),
        ),
        body: ListView.builder(
          itemCount: currentNotes.length,
          itemBuilder: (context, index) {
            // get individual note
            final note = currentNotes[index];

            // list tile UI
            return ListTile(
              leading: note.imagePath.isNotEmpty
                  ? Image.file(File(note.imagePath), width: 50, height: 50, fit: BoxFit.cover)
                  : const Icon(Icons.image_not_supported),
              title: Text(note.text),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => updateNote(note),
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () => deleteNote(note.id),
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
            );
          },
        ));
  }
}