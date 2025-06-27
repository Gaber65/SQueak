import 'package:flutter/material.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/network/end-points.dart';
import '../../../pets/domain/entities/pet_entity.dart';

class PetProfilePublicScreen extends StatefulWidget {
  final PetEntities pet;

  const PetProfilePublicScreen({
    super.key,
    required this.pet,
  });

  @override
  State<PetProfilePublicScreen> createState() => _PetProfilePublicScreenState();
}

class _PetProfilePublicScreenState extends State<PetProfilePublicScreen> {
  @override
  void initState() {
    super.initState();
    _sendScanNotification();
  }

  void _sendScanNotification() {
    // In a real implementation, you would send a notification to the pet owner
    print('Sending scan notification for pet: ${widget.pet.petName}');
  }

  @override
  Widget build(BuildContext context) {
    final age = widget.pet.birthdate.isNotEmpty
        ? DateTime.now().difference(DateTime.parse(widget.pet.birthdate)).inDays ~/ 365
        : 0;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2563EB),
              Color(0xFF3B82F6),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Header Section
                Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 64,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        backgroundImage: NetworkImage(
                          widget.pet.imageName.toString().contains('PetAvatar') ||
                              widget.pet.imageName.toString().isEmpty
                              ? 'https://img.freepik.com/free-vector/hand-drawn-animal-rescue-illustration_52683-109643.jpg'
                              : '$imageUrl${widget.pet.imageName}',
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.pet.petName,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        widget.pet.breed?.enBreed ?? 'Unknown Breed',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),

                // Content Section
                Container(
                  height: 600,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Pet Details
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: widget.pet.gender == 1
                                    ? Colors.blue.withOpacity(0.1)
                                    : Colors.pink.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                widget.pet.gender == 1 ? '♂ Male' : '♀ Female',
                                style: TextStyle(
                                  color: widget.pet.gender == 1 ? Colors.blue : Colors.pink,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            if (widget.pet.isSpayed) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Text(
                                  '✂ Spayed/Neutered',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),

                        const SizedBox(height: 24),

                        if (widget.pet.birthdate.isNotEmpty)
                          _buildInfoRow(
                            Icons.cake,
                            'Born ${widget.pet.birthdate.substring(0, 10)}',
                          ),

                        if (widget.pet.passportNumber != null && widget.pet.passportNumber!.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            Icons.badge,
                            'Passport/Microchip: ${widget.pet.passportNumber}',
                          ),
                        ],

                        const SizedBox(height: 32),

                        // Owner Contact Section
                        const Text(
                          'Owner Contact',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 16),

                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                              child: const Icon(Icons.person, color: Colors.blue),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Pet Owner', // You can add owner name to PetEntities if needed
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Contact Buttons
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _callOwner,
                            icon: const Icon(Icons.phone),
                            label: const Text('Call Owner'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorManager.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: _openWhatsApp,
                            icon: const Icon(Icons.message, color:ColorManager.primaryColor),
                            label: const Text('WhatsApp', style: TextStyle(color: ColorManager.primaryColor)),
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: const BorderSide(color: ColorManager.primaryColor),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        Center(
                          child: Text(
                            'Powered by Squeak Pet QR System',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, {Color? color}) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: color ?? Colors.grey[600],
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ),
      ],
    );
  }

  void _callOwner() async {
    // You would need to add owner phone to PetEntities
    // For now, this is a placeholder
    const phone = '+1234567890';
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _openWhatsApp() async {
    const phone = '1234567890'; // You would get this from pet owner data
    final message = Uri.encodeComponent('Hi! I found your pet ${widget.pet.petName}. Please contact me.');
    final uri = Uri.parse('https://wa.me/$phone?text=$message');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
