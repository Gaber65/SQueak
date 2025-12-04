import 'package:flutter/material.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

class PostContent extends StatefulWidget {
  const PostContent({super.key, required this.content, required this.isDark});

  final String content;
  final bool isDark;

  @override
  State<PostContent> createState() => _PostContentState();
}

class _PostContentState extends State<PostContent> {
  bool _isExpanded = false;
  static const int _maxLines = 4;

  @override
  Widget build(BuildContext context) {
    final textColor = widget.isDark ? Colors.white : Colors.black87;
    final shouldShowMore = widget.content.length > 200;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.content,
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              height: 1.5,
              letterSpacing: 0.2,
            ),
            maxLines: _isExpanded ? null : _maxLines,
            overflow: _isExpanded ? null : TextOverflow.ellipsis,
          ),
          if (shouldShowMore)
            GestureDetector(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  _isExpanded
                      ? (isArabic() ? 'عرض أقل' : 'See less')
                      : (isArabic() ? 'المزيد' : 'See more'),
                  style: TextStyle(
                    color: widget.isDark ? Colors.blue[300] : Colors.blue[700],
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}