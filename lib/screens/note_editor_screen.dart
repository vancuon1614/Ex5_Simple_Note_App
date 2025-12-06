import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../providers/note_provider.dart';

class NoteEditorScreen extends StatefulWidget {
  final Note? note;
  const NoteEditorScreen({super.key, this.note});
  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveNote() async {
    // 1. Kiểm tra dữ liệu đầu vào
    if (_titleController.text.trim().isEmpty &&
        _contentController.text.trim().isEmpty) {
      print("Dữ liệu trống, không lưu.");
      Navigator.pop(context);
      return;
    }

    try {
      final noteProvider = Provider.of<NoteProvider>(context, listen: false);
      final now = DateTime.now();
      String title = _titleController.text.isEmpty
          ? 'Untitled Note'
          : _titleController.text;

      print("Bắt đầu lưu note..."); // Log kiểm tra

      if (widget.note == null) {
        // Tạo mới
        final newNote = Note(
          title: title,
          content: _contentController.text,
          createdAt: now,
          updatedAt: now,
        );
        print("Đang gọi addNote...");
        await noteProvider.addNote(newNote);
        print("Đã addNote thành công!");
      } else {
        // Cập nhật
        final updatedNote = Note(
          id: widget.note!.id,
          title: title,
          content: _contentController.text,
          createdAt: widget.note!.createdAt,
          updatedAt: now,
        );
        print("Đang gọi updateNote...");
        await noteProvider.updateNote(updatedNote);
        print("Đã updateNote thành công!");
      }

      // Chỉ thoát màn hình nếu không có lỗi
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      // 2. Bắt lỗi và in ra màn hình console
      print("LỖI KHI LƯU: $e");

      // Hiển thị thông báo lỗi lên màn hình điện thoại để bạn thấy
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving note: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        // Không để nút save ở đây nữa cho đỡ rối
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            // Title Input
            TextField(
              controller: _titleController,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                hintText: 'Title',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none, // Bỏ gạch chân
              ),
            ),
            const SizedBox(height: 10),
            // Thời gian cập nhật (chỉ hiển thị khi edit)
            if (widget.note != null)
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Last edited: ${widget.note!.updatedAt.toString().split('.')[0]}',
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
              ),
            const SizedBox(height: 10),
            // Content Input
            Expanded(
              child: TextField(
                controller: _contentController,
                style: const TextStyle(fontSize: 18, height: 1.5),
                decoration: const InputDecoration(
                  hintText: 'Type something here...',
                  border: InputBorder.none,
                ),
                maxLines: null, // Cho phép xuống dòng thoải mái
                keyboardType: TextInputType.multiline,
              ),
            ),
          ],
        ),
      ),
      // Nút Save nổi bật
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saveNote,
        label: const Text('Save Note'),
        icon: const Icon(Icons.check),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
    );
  }
}
