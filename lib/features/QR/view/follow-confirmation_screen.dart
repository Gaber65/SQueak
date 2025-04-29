import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import 'package:squeak/core/utils/export_path/export_files.dart';

import '../../../generated/l10n.dart';
import '../../layout/layout.dart';
import '../../vetcare/view/pet_merge_screen.dart';
import '../controller/qrcubit_cubit.dart';
import '../controller/qrcubit_state.dart';

class ConfirmationScreen extends StatelessWidget {
  final String clinicCode;
  final String clinicName;
  final String clinicLogo;

  const ConfirmationScreen({
    super.key,
    required this.clinicCode,
    required this.clinicName,
    required this.clinicLogo,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QRCubit()..getSupplier(clinicCode),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              !isArabic() ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
            ),
            onPressed: () => navigateAndFinish(context, LayoutScreen()),
          ),
          title: Text(S.of(context).followConfirmation),
        ),
        body: BlocConsumer<QRCubit, QRState>(
          listener: (context, state) {
            if (state is FollowSuccess) {
              if (!state.isHavePet) {
                navigateAndFinish(context, LayoutScreen());
              } else {
                navigateAndFinish(
                  context,
                  PetMergeScreen(
                    Code: clinicCode,
                    isNavigation: false,
                  ),
                );
              }
            }
          },
          builder: (context, state) {
            var cubit = QRCubit.get(context);
            return cubit.isLoading
                ? _buildShimmerPlaceholder()
                : cubit.isAlreadyFollow
                    ? buildCenterAlreadyFollow(context, state)
                    : buildCenterConfirmFollow(context, cubit);
          },
        ),
      ),
    );
  }

  Widget buildCenterConfirmFollow(BuildContext context, QRCubit cubit) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(16),
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(imageUrl + clinicLogo),
              ),
              SizedBox(height: 16),
              Text(
                clinicName,
                style: FontStyleThame.textStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  context: context,
                ),
              ),
              SizedBox(height: 8),
              SizedBox(height: 16),
              if (!cubit.isConfirmed) ...[
                Text(
               isArabic() ? 'هل تريد متابعة هذه العيادة؟' :  'Do you want follow this clinic ?',
                  textAlign: TextAlign.center,
                  style: FontStyleThame.textStyle(
                    fontSize: 20,
                    context: context,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => cubit.followClinic(clinicCode),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: ColorManager.primaryColor,
                        ),
                        child: Text(
                          isArabic()
                              ? 'تأكيد'
                              : 'Confirm',
                          style: FontStyleThame.textStyle(
                              fontSize: 14,
                              context: context,
                              fontColor: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => navigateAndFinish(context, LayoutScreen()),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: Colors.black,
                        ),
                        child: Text(
                          isArabic() ? 'رفض' : 'Decline',
                          style: FontStyleThame.textStyle(
                              fontSize: 14,
                              context: context,
                              fontColor: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                Text(
                  isArabic()
                      ? 'تم تأكيد نقل البيانات'
                      : 'Data transfer confirmed!',
                  style: FontStyleThame.textStyle(
                    context: context,
                    fontColor: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  isArabic()
                      ? "تحويل البيانات في ${cubit.countdown} ثانية"
                      : 'Redirecting in${cubit.countdown} seconds...',
                ),
                SizedBox(height: 8),
                LinearProgressIndicator(
                  value: (5 - cubit.countdown) / 5,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCenterAlreadyFollow(BuildContext context, QRState state) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(16),
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircleAvatar(
                radius: 54,
                backgroundColor: Colors.green,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: CircleAvatar(
                    radius: 52,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 51,
                      backgroundColor: Colors.green,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.check,
                          color: Colors.green,
                          size: 100,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                clinicName,
                style: FontStyleThame.textStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  context: context,
                ),
              ),
              SizedBox(height: 8),
              Text(
                isArabic()
                    ? "انت تتابع هذه العيادة"
                    : 'You\'re following this clinic',
                style: FontStyleThame.textStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  fontColor: Colors.grey,
                  context: context,
                ),
              ),
              SizedBox(height: 16),
              if (state is FollowSuccess && state.isHavePet)
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => navigateAndFinish(
                      context,
                      PetMergeScreen(
                        Code: clinicCode,
                        isNavigation: false,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Transform.rotate(
                          angle: 45,
                          child: Icon(
                            Icons.pets,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          isArabic()
                              ? 'اظهار أليفك علي هذة العيادة'
                              : 'Show My Pet on thi Clinic',
                          style: FontStyleThame.textStyle(
                            fontSize: 14,
                            context: context,
                            fontColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerPlaceholder() {
    return Center(
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              color: Colors.white,
            ),
            SizedBox(height: 16),
            Container(
              width: 200,
              height: 24,
              color: Colors.white,
            ),
            SizedBox(height: 8),
            Container(
              width: 250,
              height: 16,
              color: Colors.white,
            ),
            SizedBox(height: 16),
            Container(
              width: 180,
              height: 40,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
