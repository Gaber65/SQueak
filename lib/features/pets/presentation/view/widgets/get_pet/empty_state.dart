import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/generated/l10n.dart';

class EmptyState extends StatelessWidget {
  final VoidCallback onAddPetPressed;

  const EmptyState({
    super.key,
    required this.onAddPetPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 80,
            backgroundImage: FastCachedImageProvider(
                'https://firebasestorage.googleapis.com/v0/b/squeak-c005f.appspot.com/o/happy-pets-animal-ai-art-388_720x.webp?alt=media&token=eee507ff-48c5-450d-88d9-4203537ed79b'),
          ),
          const SizedBox(height: 24),
          Text(
            S.of(context).noPetsFound,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorManager.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: onAddPetPressed,
            child: Text(S.of(context).addYourFirstPet),
          ),
        ],
      ),
    );
  }
}