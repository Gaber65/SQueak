import 'package:flutter/material.dart';

class ProfileSwitcherItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String image;
  final VoidCallback onTap;
  final bool selected;

  const ProfileSwitcherItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.image,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue,
        child: image.isNotEmpty
            ? ClipOval(
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: Text(
                      title[0].toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              )
            : Text(
                title[0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
      ),
      title: Text(title),
      subtitle: subtitle.isNotEmpty
          ? Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            )
          : null,
      trailing: selected ? const Icon(Icons.check, color: Colors.blue) : null,
      onTap: onTap,
    );
  }
}
