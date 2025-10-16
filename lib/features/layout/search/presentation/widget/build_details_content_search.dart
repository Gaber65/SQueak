import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:lottie/lottie.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/layout/search/domain/entities/clinic_search_entity.dart';

import '../controller/search_cubit.dart';

Widget buildDetailsContentSearch(ClinicEntitySearch entities, SearchCubit cubit, context, index) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 5),
    width: double.infinity,
    padding: const EdgeInsets.all(10),
    decoration: Decorations.kDecorationBoxShadow(context: context),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              entities.name,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontFamily: 'bold', fontSize: 15),
            ),
            const Spacer(),
            const Spacer(),
            CircleAvatar(
              backgroundImage: NetworkImage('$imageUrl${entities.image}'),
              radius: 20,
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Row(
                children: [
                  const Icon(Icons.location_city, size: 14),
                  const SizedBox(width: 5),
                  Text(
                    '${entities.location.length > 10 ? entities.location.substring(0, 10) : entities.location} , ${entities.city.length > 10 ? entities.city.substring(0, 10) : entities.city}  , ${entities.address.length > 10 ? entities.address.substring(0, 10) : entities.address} ',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, fontFamily: 'bold'),
                  ),
                ],
              ),
            ),
            const Spacer(),
            CircleAvatar(
              backgroundColor: cubit.isFollowBefore ? Colors.red : Colors.green,
              radius: 15,
              child: IconButton(
                iconSize: 15,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: cubit.isFollowBefore
                            ? Text(S.of(context).unfollowConfirmation)
                            : Text(S.of(context).followConfirmation),
                        content: SizedBox(
                          width: MediaQuery.of(context).size.width + 100,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    entities.name,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const Spacer(),
                                  const Spacer(),
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      '$imageUrl${entities.image}',
                                    ),
                                    radius: 20,
                                  ),
                                ],
                              ),
                              Text(
                                entities.specialities.isNotEmpty
                                    ? entities.specialities[0].name
                                    : '',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontFamily: 'bold',
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  const Icon(IconlyLight.location, size: 14),
                                  const SizedBox(width: 2),
                                  SizedBox(
                                    width: MediaQuery.sizeOf(context).width / 2,
                                    child: Text(
                                      '${entities.location} , ${entities.address} , ${entities.city} ',
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'bold',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  const Icon(IconlyLight.call, size: 14),
                                  const SizedBox(width: 2),
                                  const SizedBox(width: 3),
                                  Text(
                                    entities.phone,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: TextButton(
                              child: Text(
                                cubit.isFollowBefore
                                    ? S.of(context).unfollow
                                    : isArabic()
                                    ? "متابعة"
                                    : "Follow",
                                style: TextStyle(color: Colors.green),
                              ),
                              onPressed: () {
                                if (cubit.isFollowBefore) {
                                  cubit.unfollowClinic(entities.id);
                                } else {
                                  cubit.followClinic(entities.id,);
                                }
                                Navigator.of(context).pop(true);
                              },
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text(
                              isArabic() ? "الغاء " : "cancel",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(Icons.person_add),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
