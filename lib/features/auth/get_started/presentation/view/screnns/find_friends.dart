import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';

class FindFriendsScreen extends StatelessWidget {
  const FindFriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.editScreenTextFieldBaseColor,
      appBar: AppBar(
        backgroundColor: ColorManager.editScreenTextFieldBaseColor,
        title: Text(
          'Connect with Pet Friends',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: ColorManager.editScreenBaseFontColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView(
          physics: BouncingScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            LinearProgressIndicator(
              value: 1,
              minHeight: 2,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation(Colors.blue),
            ),

            const SizedBox(height: 24),
            const SizedBox(height: 8),
            const Text(
              textAlign: TextAlign.center,
              'Discover other pet parents in your area and start building your pet\'s social network!',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                decoration: InputDecoration(
                  fillColor: ColorManager.followersShadowLightColor,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: ColorManager.primaryColor.withOpacity(.7),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search by pet name, breed, or location...',
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 5,
              itemBuilder:
                  (context, index) => _PetFriendCard(
                    name: 'Max & Luna',
                    breed: 'Golden Retriever',
                    age: '3 years old',
                    distance: '2 miles away',
                    healthStatus: 'Healthy',
                    mutualFriends: 3,
                  ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.white),
              ),
              margin: const EdgeInsets.all(16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager.followersShadowLightColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor:
                            ColorManager.editScreenTextFieldBaseColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        title: const Text(
                          "Are you sure you want to skip finding friends?",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: ColorManager.editScreenBaseFontColor,
                          ),
                        ),
                        content: const Text(
                          "You can always connect later.",
                          style: TextStyle(
                            fontSize: 14,
                            color: ColorManager.editScreenBaseFontColor,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {},
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 6,
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: ColorManager.bTwitter,
                              ),
                              child: InkWell(
                                onTap: () {
                                  navigateToScreen(context, LayoutScreen());
                                },
                                child: const Text(
                                  "OK",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 6,
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: ColorManager.followersShadowLightColor,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                "Cancel",
                                style: TextStyle(
                                  color: ColorManager.editScreenBaseFontColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },

                child: const Text(
                  "Skip For Now",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,

            child: Container(
              margin: const EdgeInsets.all(8),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  "Complete Setup",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PetFriendCard extends StatelessWidget {
  final String name;
  final String breed;
  final String age;
  final String? distance;
  final String healthStatus;
  final int mutualFriends;

  const _PetFriendCard({
    required this.name,
    required this.breed,
    required this.age,
    this.distance,
    required this.healthStatus,
    required this.mutualFriends,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 22),
      decoration: BoxDecoration(
        border: Border.all(color: ColorManager.editScreenBaseFontColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(),
            title: Text(
              name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorManager.editScreenBaseFontColor,
              ),
            ),
            subtitle: RichText(
              text: TextSpan(
                text: '$breed • $age',
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
            trailing: Text(
              ' • $distance',
              style: const TextStyle(
                color: ColorManager.followersShadowLightColor,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    healthStatus,
                    style: TextStyle(
                      color: Colors.green[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      color: ColorManager.editScreenBaseFontColor,
                    ),
                    SizedBox(width: 8),
                    Text(
                      '$mutualFriends mutual friend${mutualFriends != 1 ? 's' : ''}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(FontAwesomeIcons.bone),
                            SizedBox(width: 8),
                            const Text('Connect'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.grey,
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cancel, size: 22),
                            SizedBox(width: 8),
                            const Text('Pass'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
