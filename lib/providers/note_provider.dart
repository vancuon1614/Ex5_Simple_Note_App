import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/note.dart';

class NoteProvider extends ChangeNotifier {
  List<Note> _notes = [];
  List<Note> get notes => _notes;

  // Load notes từ DB
  Future<void> loadNotes() async {
    _notes = await DatabaseHelper.instance.readAll();
    notifyListeners();
  }

  // Thêm note mới
  Future<void> addNote(Note note) async {
    await DatabaseHelper.instance.create(note);
    await loadNotes(); // <--- Dòng này cực quan trọng để báo UI cập nhật
  }

  Future<void> updateNote(Note note) async {
    await DatabaseHelper.instance.update(note);
    await loadNotes();
  }

  // Xóa note
  Future<void> deleteNote(int id) async {
    await DatabaseHelper.instance.delete(id);
    await loadNotes();
  }
}
