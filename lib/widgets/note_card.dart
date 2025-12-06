import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/note.dart';

// Danh sách màu pastel nhẹ nhàng để random
final List<Color> _lightColors = [
  Colors.amber.shade100,
  Colors.lightGreen.shade100,
  Colors.lightBlue.shade100,
  Colors.orange.shade100,
  Colors.pink.shade100,
  Colors.teal.shade100,
  Colors.purple.shade100,
];

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final int index; // Dùng index để chọn màu cố định cho note đỡ bị nháy màu

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onDelete,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    // Chọn màu dựa trên index
    final color = _lightColors[index % _lightColors.length];

    return Card(
      color: color, // Màu nền thẻ
      elevation: 2, // Độ nổi
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      note.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  InkWell(
                    onTap: onDelete,
                    child: const Icon(
                      Icons.close,
                      size: 20,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                note.content,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
                maxLines: 4, // Hiển thị tối đa 4 dòng nội dung
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(), // Đẩy ngày tháng xuống đáy nếu card dài
              const SizedBox(height: 8),
              Text(
                DateFormat('MMM dd, yyyy').format(note.updatedAt),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black45,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
