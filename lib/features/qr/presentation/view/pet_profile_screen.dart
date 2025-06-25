import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../pets/domain/entities/pet_entity.dart';
import '../../../../core/utils/responsive_utils.dart';

class PetProfileScreen extends StatefulWidget {
  final PetEntities pet;

  const PetProfileScreen({super.key, required this.pet});

  @override
  State<PetProfileScreen> createState() => _PetProfileScreenState();
}

class _PetProfileScreenState extends State<PetProfileScreen> {
  @override
  void initState() {
    super.initState();
    _sendScanNotification();
  }

  void _sendScanNotification() {
    // In a real implementation, you would send a notification to the pet owner
    // This could include location data if available
    print('Sending scan notification for pet: ${widget.pet.petName}');
  }

  @override
  Widget build(BuildContext context) {
    final age =
        DateTime.now()
            .difference(DateTime.parse(widget.pet.birthdate))
            .inDays ~/
        365;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Header Section
                Container(
                  padding: EdgeInsets.all(responsiveWidth(24, context)),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: responsiveWidth(64, context),
                        backgroundColor: Colors.white.withOpacity(0.2),
                        child: CircleAvatar(
                          radius: responsiveWidth(48, context),
                          backgroundColor: Colors.white.withOpacity(0.3),
                          child: Text(
                            '🐾',
                            style: TextStyle(
                              fontSize: responsiveFontSize(48, context),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: responsiveHeight(16, context)),
                      Text(
                        widget.pet.petName,
                        style: TextStyle(
                          fontSize: responsiveFontSize(32, context),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                // Content Section
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: responsiveWidth(16, context),
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(responsiveWidth(24, context)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Pet Details
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    widget.pet.gender == 'male'
                                        ? Colors.blue.withOpacity(0.1)
                                        : Colors.pink.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                widget.pet.gender == 'male'
                                    ? '♂ Male'
                                    : '♀ Female',
                                style: TextStyle(
                                  color:
                                      widget.pet.gender == 'male'
                                          ? Colors.blue
                                          : Colors.pink,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            if (widget.pet.isSpayed) ...[
                              SizedBox(width: responsiveWidth(8, context)),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
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

                        SizedBox(height: responsiveHeight(24, context)),

                        _buildInfoRow(
                          Icons.cake,
                          'Born ${widget.pet.birthdate} ($age years old)',
                        ),


                        if (widget.pet.passportNumber != null) ...[
                          SizedBox(height: responsiveHeight(12, context)),
                          _buildInfoRow(
                            Icons.badge,
                            'Passport/Microchip: ${widget.pet.passportNumber}',
                          ),
                        ],

                        SizedBox(height: responsiveHeight(32, context)),



                        SizedBox(height: responsiveHeight(12, context)),



                        SizedBox(height: responsiveHeight(12, context)),

                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.map),
                            label: const Text('View Location on Map'),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                vertical: responsiveHeight(16, context),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: responsiveHeight(32, context)),

                        Center(
                          child: Text(
                            'Powered by Squeak Pet QR System',
                            style: TextStyle(
                              fontSize: responsiveFontSize(12, context),
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
          size: responsiveWidth(16, context),
          color: color ?? Colors.grey[600],
        ),
        SizedBox(width: responsiveWidth(8, context)),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: responsiveFontSize(14, context),
              color: Colors.grey[600],
            ),
          ),
        ),
      ],
    );
  }
}
