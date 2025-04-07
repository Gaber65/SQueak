import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/constant/global_widget/toast.dart';
import 'package:squeak/core/helper/cache/cache_helper.dart';
import 'package:squeak/core/helper/remotely/end-points.dart';
import 'package:squeak/core/thames/decorations.dart';
import 'package:squeak/core/thames/styles.dart';
import 'package:squeak/features/service/view/pet_vaccination.dart';
import 'package:squeak/features/vetcare/controller/vet_cubit.dart';
import 'package:squeak/features/vetcare/view/pet_merge_screen.dart';

import '../../../core/constant/global_function/global_function.dart';
import '../../layout/layout.dart';

class FollowRequestScreen extends StatelessWidget {
  const FollowRequestScreen({super.key, required this.ClinicID});
  final String ClinicID;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VetCubit()
        ..getClinicbyID(ClinicID)
        ..getNotifications(ClinicID),
      child: BlocConsumer<VetCubit, VetState>(
        listener: (context, state) {
          if (state is ErrorAcceptIvationState) {
            errorToast(
              context,
              state.error.errors.isNotEmpty
                  ? state.error.errors.values.first.first
                  : state.error.message,
            );
          }
          if (state is SuccessAcceptIvationState) {
            if (state.isHavePet) {
              navigateToScreen(
                context,
                PetMergeScreen(
                  Code: VetCubit.get(context).entities!.code,
                  isNavigation: false,
                ),
              );
            } else {
              navigateToScreen(
                context,
                LayoutScreen(),
              );
            }
          }
        },
        builder: (context, state) {
          var cubit = VetCubit.get(context);
          return WillPopScope(
            onWillPop: () async {
              navigateAndFinish(context, LayoutScreen());
              return false;
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text(isArabic() ? 'طلبات المتابعة' : 'Follow Requests'),
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                  ),
                  onPressed: () {
                    navigateAndFinish(context, LayoutScreen());
                  },
                ),
              ),
              body: cubit.entities == null
                  ? VacShimmer()
                  : cubit.isGetClinic
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: Decorations.kDecorationBoxShadow(
                                context: context),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage: NetworkImage(
                                    imageUrl + cubit.entities!.image.toString(),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cubit.entities!.name.toString(),
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          child: ElevatedButton(
                                            onPressed: !cubit.isAccept
                                                ? () {
                                                    // navigateToScreen(context, PetMergeScreen());

                                                    print(cubit.vetClientModel);
                                                    cubit.acceptIvation(
                                                      clinicCode:
                                                          cubit.entities!.code,
                                                      clientId: cubit
                                                          .vetClientModelOne!
                                                          .vetICareId,
                                                      squeakUserId:
                                                          CacheHelper.getData(
                                                              'clintId'),
                                                    );
                                                  }
                                                : null,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  ColorTheme.primaryColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: cubit.isAccept
                                                  ? CircularProgressIndicator()
                                                  : Text(isArabic()
                                                      ? 'قبول'
                                                      : 'Accept'),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              navigateAndFinish(
                                                  context, LayoutScreen());
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.black87,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Text(isArabic()
                                                  ? 'رفض'
                                                  : 'Ignore'),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      : Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.cancel,
                                  size: 64,
                                  color: Colors.red,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  isArabic()
                                      ? 'طلب المتابعة غير متوفر'
                                      : 'Follow Request Unavailable',
                                  style: FontStyleThame.textStyle(
                                    context: context,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  isArabic()
                                      ? "طلب المتابعة الذي تبحث عنه لم يعد متوفرًا. قد يكون قد تم إلغاؤه، أو انتهت صلاحيته، أو تم قبوله بالفعل."
                                      : 'The follow request you\'re looking for is no longer available. It may have been cancelled, expired, or already accepted.',
                                  textAlign: TextAlign.center,
                                  style: FontStyleThame.textStyle(
                                    fontSize: 16,
                                    context: context,
                                    fontColor: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
            ),
          );
        },
      ),
    );
  }
}
