import 'dart:typed_data';

import 'package:isar/isar.dart';

// this line is needed ot generate file
// then run dart run build_runner build
part 'note.g.dart';

@Collection()
class Note {
  Id id = Isar.autoIncrement;
  late String text;

  late String imagePath; // stores path to the image file
}