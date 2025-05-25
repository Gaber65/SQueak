import 'dart:math';

import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:share_plus/share_plus.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/appointments/exam/domain/entities/clinic_entity.dart';
import 'package:squeak/features/appointments/exam/presentation/controller/clinic/appointment_cubit.dart';
import 'package:squeak/features/layout/search/presentation/controller/search_cubit.dart';

class WhatsappAppbar extends SliverPersistentHeaderDelegate {
  double screenWidth;
  Tween<double>? profilePicTranslateTween;
  BuildContext context;
  Clinic clinics;

  WhatsappAppbar({
    required this.screenWidth,
    required this.clinics,
    required this.context,
  }) {
    profilePicTranslateTween = Tween<double>(
      begin: screenWidth / 2 - 45 - 40 + 15,
      end: 40.0,
    );
  }

  static final appbarIconColorTween = ColorTween(
    begin: Colors.grey[800],
    end: Colors.white,
  );

  static final phoneNumberTranslateTween = Tween<double>(begin: 20.0, end: 0.0);

  static final phoneNumberFontSizeTween = Tween<double>(begin: 20.0, end: 16.0);

  static final profileImageRadiusTween = Tween<double>(begin: 3.5, end: 1.0);

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final relativeScroll = min(shrinkOffset, 45) / 45;
    final relativeScroll70px = min(shrinkOffset, 70) / 70;
    final appBarColorTween = ColorTween(
      begin:
          MainCubit.get(context).isDark
              ? ThemeData.dark().scaffoldBackgroundColor
              : Colors.white,
      end:
          MainCubit.get(context).isDark
              ? ThemeData.dark().scaffoldBackgroundColor
              : Colors.white,
    );

    return Container(
      color: appBarColorTween.transform(relativeScroll),
      child: Stack(
        children: [
          Stack(
            children: [
              Positioned(
                left: 0,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon:
                      isArabic()
                          ? Icon(
                            Icons.arrow_forward,
                            size: 25,
                            color:
                                MainCubit.get(context).isDark
                                    ? Colors.white
                                    : Colors.black,
                          )
                          : Icon(
                            Icons.arrow_back,
                            size: 25,
                            color:
                                MainCubit.get(context).isDark
                                    ? Colors.white
                                    : Colors.black,
                          ),
                  color: appbarIconColorTween.transform(relativeScroll),
                ),
              ),
              Positioned(
                top: 15,
                left: 90,
                child: displayPhoneNumber(relativeScroll70px),
              ),
              Positioned(
                top: 5,
                left: profilePicTranslateTween!.transform(relativeScroll70px),
                child: displayProfilePicture(relativeScroll70px, clinics.image),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget displayProfilePicture(double relativeFullScrollOffset, String image) {
    return Transform(
      transform:
          Matrix4.identity()..scale(
            profileImageRadiusTween.transform(relativeFullScrollOffset),
          ),
      child: CircleAvatar(
        backgroundColor:
            MainCubit.get(context).isDark ? Colors.black38 : Colors.black12,
        backgroundImage: FastCachedImageProvider(imageUrl + image),
      ),
    );
  }

  Widget displayPhoneNumber(double relativeFullScrollOffset) {
    if (relativeFullScrollOffset >= 0.8) {
      return Transform(
        transform:
            Matrix4.identity()..translate(
              0.0,
              phoneNumberTranslateTween.transform(
                (relativeFullScrollOffset - 0.8) * 5,
              ),
            ),
        child: Text(
          clinics.name,
          style: TextStyle(
            fontSize: phoneNumberFontSizeTween.transform(
              (relativeFullScrollOffset - 0.8) * 5,
            ),
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  @override
  double get maxExtent => 120;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(WhatsappAppbar oldDelegate) {
    return true;
  }
}

class WhatsappProfileBody extends StatelessWidget {
  WhatsappProfileBody({Key? key, required this.list}) : super(key: key);
  final Widget list;

  @override
  Widget build(BuildContext context) {
    return SliverList(delegate: SliverChildListDelegate([list]));
  }
}

class ProfileIconButtons extends StatelessWidget {
  ProfileIconButtons({Key? key, required this.clinics}) : super(key: key);

  final Clinic clinics;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Share.share(
                  isArabic()
                      ? 'مرحبا، أود التوصية بالعيادة ${clinics.name} بكود ${clinics.code} . يرجى تحميل التطبيق من هنا https://veticareapp.com/share '
                      : 'Hello, I would recommend clinic ${clinics.name} with code : ${clinics.code}. Please download the app from here https://veticareapp.com/share',
                  subject: 'Check out this clinic!',
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.blue,
                backgroundColor:
                    MainCubit.get(context).isDark
                        ? ColorManager.myPetsBaseBlackColor
                        : Colors.blue.shade100.withOpacity(.4),
                elevation: 0,
                shape: (RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                )),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Icon(Icons.share),
                  Flexible(
                    child: Text(
                      isArabic() ? 'مشاركة' : 'Share',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: BlocProvider(
              create: (context) => sl<SearchCubit>(),
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: () {
                      SearchCubit.get(context).unfollowClinic(clinics.id);

                      AppointmentCubit.get(context).emit(UnfollowSuccess());
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.red,
                      backgroundColor:
                          MainCubit.get(context).isDark
                              ? ColorManager.myPetsBaseBlackColor
                              : Colors.red.shade100.withOpacity(.4),
                      elevation: 0,
                      shape: (RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      )),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(IconlyLight.user),
                        Flexible(
                          child: Text(
                            isArabic() ? 'الغاء المتابعة' : 'UnFollow',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PhoneAndName extends StatelessWidget {
  PhoneAndName({
    Key? key,
    required this.speciality,
    required this.clinicName,
    required this.phone,
  }) : super(key: key);
  final String speciality;
  final String phone;
  final String clinicName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 35),
        Text(
          clinicName,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(phone, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}
