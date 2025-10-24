import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/layout/search/domain/entities/clinic_search_entity.dart';

import '../controller/search_cubit.dart';

Widget buildDetailsContentSearch(
  ClinicEntitySearch entities,
  SearchCubit cubit,
  context,
  index,
) {
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
            Expanded(
              child: Text(
                entities.name,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontFamily: 'bold', fontSize: 15),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundImage: NetworkImage('$imageUrl${entities.image}'),
              radius: 20,
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  const Icon(Icons.location_city, size: 14),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      '${entities.location.length > 10 ? entities.location.substring(0, 10) : entities.location} , ${entities.city.length > 10 ? entities.city.substring(0, 10) : entities.city}  , ${entities.address.length > 10 ? entities.address.substring(0, 10) : entities.address} ',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, fontFamily: 'bold'),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title:
                          cubit.isFollowBefore
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
                                const SizedBox(width: 5),
                                Text(
                                  entities.phone.startsWith('0')
                                      ? entities.phone
                                      : '0${entities.phone}',
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
                              style: TextStyle(
                                color:
                                    cubit.isFollowBefore
                                        ? Colors.red
                                        : Colors.green,
                              ),
                            ),
                            onPressed: () {
                              if (cubit.isFollowBefore) {
                                cubit.unfollowClinic(entities.id);
                              } else {
                                cubit.followClinic(entities.id);
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
              child:
                  cubit.isFollowBefore
                      ? Container(
                        key: const ValueKey('following'),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.red.shade400, Colors.red.shade600],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              S.of(context).unfollow,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      )
                      : Container(
                        key: const ValueKey('follow'),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.green.shade400,
                              Colors.green.shade600,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.person_add_alt,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isArabic() ? 'متابعة' : 'Follow',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
            ),
          ],
        ),
      ],
    ),
  );
}
