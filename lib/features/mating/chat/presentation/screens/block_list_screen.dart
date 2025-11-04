import 'package:flutter/material.dart';

class BlockedPet {
  final String name;
  final String ownerName;
  final String petType;
  final String imageUrl;
  final String blockedDate;
  final String reason;

  BlockedPet({
    required this.name,
    required this.ownerName,
    required this.petType,
    required this.imageUrl,
    required this.blockedDate,
    required this.reason,
  });
}

class BlockedPetsScreen extends StatefulWidget {
  const BlockedPetsScreen({super.key});

  @override
  State<BlockedPetsScreen> createState() => _BlockedPetsScreenState();
}

class _BlockedPetsScreenState extends State<BlockedPetsScreen> {
  final List<BlockedPet> blockedPets = [
    BlockedPet(
      name: 'Max',
      ownerName: 'Sarah Johnson',
      petType: 'Golden Retriever',
      imageUrl: 'https://images.unsplash.com/photo-1633722715463-d30f4f325e24?w=400',
      blockedDate: 'Oct 15, 2024',
      reason: 'Aggressive behavior',
    ),
    BlockedPet(
      name: 'Luna',
      ownerName: 'Mike Chen',
      petType: 'Siamese Cat',
      imageUrl: 'https://images.unsplash.com/photo-1513360371669-4adf3dd7dff8?w=400',
      blockedDate: 'Oct 28, 2024',
      reason: 'Inappropriate content',
    ),
    BlockedPet(
      name: 'Charlie',
      ownerName: 'Emma Davis',
      petType: 'Beagle',
      imageUrl: 'https://images.unsplash.com/photo-1505628346881-b72b27e84530?w=400',
      blockedDate: 'Nov 02, 2024',
      reason: 'Spam messages',
    ),
    BlockedPet(
      name: 'Whiskers',
      ownerName: 'Tom Anderson',
      petType: 'Persian Cat',
      imageUrl: 'https://images.unsplash.com/photo-1574158622682-e40e69881006?w=400',
      blockedDate: 'Sep 22, 2024',
      reason: 'Harassment',
    ),
    BlockedPet(
      name: 'Buddy',
      ownerName: 'Lisa Martinez',
      petType: 'Labrador',
      imageUrl: 'https://images.unsplash.com/photo-1552053831-71594a27632d?w=400',
      blockedDate: 'Aug 30, 2024',
      reason: 'Policy violation',
    ),
  ];

  void _showUnblockDialog(BlockedPet pet, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              const Icon(Icons.block, color: Color(0xFF6B4EFF)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Unblock ${pet.name}?',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to unblock ${pet.name} owned by ${pet.ownerName}? They will be able to interact with your pets again.',
            style: const TextStyle(fontSize: 15),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  blockedPets.removeAt(index);
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${pet.name} has been unblocked'),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6B4EFF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Unblock'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2D3142)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Blocked Pets',
          style: TextStyle(
            color: Color(0xFF2D3142),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.grey.shade200,
            height: 1,
          ),
        ),
      ),
      body: blockedPets.isEmpty
          ? _buildEmptyState()
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  color: Colors.white,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE5E5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.block,
                          color: Color(0xFFFF6B6B),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${blockedPets.length} Blocked',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D3142),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'These pets can\'t interact with yours',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF9FA5C0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: blockedPets.length,
                    itemBuilder: (context, index) {
                      final pet = blockedPets[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () => _showUnblockDialog(pet, index),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  Hero(
                                    tag: 'pet_${pet.name}_$index',
                                    child: Container(
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        image: DecorationImage(
                                          image: NetworkImage(pet.imageUrl),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(16),
                                          color: Colors.black.withOpacity(0.2),
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.block,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          pet.name,
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF2D3142),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.person_outline,
                                              size: 14,
                                              color: Color(0xFF9FA5C0),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              pet.ownerName,
                                              style: const TextStyle(
                                                fontSize: 13,
                                                color: Color(0xFF9FA5C0),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 3,
                                              ),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFE8E4FF),
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                pet.petType,
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  color: Color(0xFF6B4EFF),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            const Icon(
                                              Icons.calendar_today,
                                              size: 11,
                                              color: Color(0xFF9FA5C0),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              pet.blockedDate,
                                              style: const TextStyle(
                                                fontSize: 11,
                                                color: Color(0xFF9FA5C0),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE8F5E9),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.check_circle_outline,
                                        color: Color(0xFF4CAF50),
                                        size: 22,
                                      ),
                                    ),
                                    onPressed: () => _showUnblockDialog(pet, index),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.pets,
              size: 60,
              color: Color(0xFF4CAF50),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Blocked Pets',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3142),
            ),
          ),
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'You haven\'t blocked any pets yet.\nEveryone can interact with your furry friends!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF9FA5C0),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}