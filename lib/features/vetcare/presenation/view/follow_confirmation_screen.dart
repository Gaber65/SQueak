import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/vetcare/presenation/view/pet_merge_screen.dart';

import '../../../appointments/exam/domain/entities/clinic_entity.dart';
import '../../../appointments/exam/presentation/controller/user/user_appointment_cubit.dart';
import '../controllers/qr_register/qr_cubit.dart';
import '../controllers/qr_register/qr_state.dart';

MySupplier? suppliers;

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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
                  sl<UserAppointmentCubit>()
                    ..fetchSuppliers()
                    ..fetchSuppliers(),
        ),

        BlocProvider(create: (context) => sl<QRCubit>()),
      ],
      child: BlocConsumer<UserAppointmentCubit, UserAppointmentState>(
        listener: (context, state) {
          if (state is GetSupplierSuccess) {
            // print('suppliers ${state.suppliers}');
            // print('suppliers $clinicCode*************************');
            QRCubit.get(
              context,
            ).checkClinicInMySupplier(clinicCode, state.suppliers);
            suppliers = state.suppliers;
            // print('suppliers ${state.suppliers}' '*************************');
          }
        },
        builder: (context, state) {
          return Scaffold(
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
                if (state is QRFollowSuccess) {
                  if (!state.success) {
                    navigateAndFinish(context, LayoutScreen());
                  } else {
                    navigateAndFinish(
                      context,
                      PetMergeScreen(code: clinicCode, isNavigation: false),
                    );
                  }
                } else if (state is QRError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                final cubit = QRCubit.get(context);

                if (cubit.isLoading) {
                  return _buildShimmerPlaceholder();
                } else {
                  return cubit.isAlreadyFollow
                      ? _buildAlreadyFollowWidget(context, cubit)
                      : _buildConfirmFollowWidget(context, cubit);
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildConfirmFollowWidget(BuildContext context, QRCubit cubit) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(16),
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(imageUrl + clinicLogo),
                  onBackgroundImageError: (_, __) => Container(),
                  child:
                      clinicLogo.isEmpty
                          ? Icon(Icons.local_hospital, size: 50)
                          : null,
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
              SizedBox(height: 24),
              Text(
                isArabic()
                    ? 'هل تريد متابعة هذه العيادة؟'
                    : 'Do you want to follow this clinic?',
                textAlign: TextAlign.center,
                style: FontStyleThame.textStyle(fontSize: 16, context: context),
              ),
              SizedBox(height: 24),
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
                        minimumSize: Size.fromHeight(48),
                      ),
                      child: Text(
                        isArabic() ? 'تأكيد' : 'Confirm',
                        style: FontStyleThame.textStyle(
                          fontSize: 16,
                          context: context,
                          fontColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed:
                          () => navigateAndFinish(context, LayoutScreen()),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: Colors.grey[600],
                        minimumSize: Size.fromHeight(48),
                      ),
                      child: Text(
                        isArabic() ? 'إلغاء' : 'Cancel',
                        style: FontStyleThame.textStyle(
                          fontSize: 16,
                          context: context,
                          fontColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAlreadyFollowWidget(BuildContext context, QRCubit cubit) {
    cubit.getVetClients(clinicCode, false);
    return Center(
      child: Card(
        margin: EdgeInsets.all(16),
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // ignore: deprecated_member_use
                  color: Colors.green.withOpacity(0.1),
                  border: Border.all(color: Colors.green, width: 2),
                ),
                child: Icon(Icons.check_circle, color: Colors.green, size: 80),
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
                    ? "أنت تتابع هذه العيادة بالفعل"
                    : "You're already following this clinic",
                style: FontStyleThame.textStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  fontColor: Colors.grey[600],
                  context: context,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              if (cubit.vetClientModel.isNotEmpty) ...[
                if (!cubit.vetClientModel.first.id.contains('0000'))
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (cubit.vetClientModel.isNotEmpty) {
                          navigateAndFinish(
                            context,
                            PetMergeScreen(
                              code: clinicCode,
                              isNavigation: false,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: ColorManager.primaryColor,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.pets, color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text(
                            isArabic()
                                ? 'إظهار حيواناتي الأليفة'
                                : 'Show My Pets',
                            style: FontStyleThame.textStyle(
                              fontSize: 16,
                              context: context,
                              fontColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
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
        child: Card(
          margin: EdgeInsets.all(16),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  width: 200,
                  height: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  width: 250,
                  height: 16,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
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
    );
  }
}
