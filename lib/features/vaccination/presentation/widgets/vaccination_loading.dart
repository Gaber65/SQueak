import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class VaccinationLoading extends StatelessWidget {
  const VaccinationLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Shimmer.fromColors(
                baseColor: Colors.grey,
                highlightColor: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                                color: Colors.grey,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40))),
                            width: 40,
                            height: 14,
                          ),
                          Container(
                            decoration: const BoxDecoration(
                                color: Colors.grey,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40))),
                            width: 120,
                            height: 14,
                          ),
                          Container(
                            decoration: const BoxDecoration(
                                color: Colors.grey,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40))),
                            width: 40,
                            height: 14,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                                color: Colors.grey,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40))),
                            width: 40,
                            height: 14,
                          ),
                          const Spacer(),
                          CircleAvatar(
                            child: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
