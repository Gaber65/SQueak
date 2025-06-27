import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/service/main_service/presentation/controller/main_cubit/main_cubit.dart';
import '../../../../core/service/global_function/format_utils.dart';
import '../controller/qr_cubit.dart';
import '../../../pets/domain/entities/pet_entity.dart';

class QrStatusIndicator extends StatelessWidget {
  final PetEntities pet;

  const QrStatusIndicator({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QrCubit, QrState>(
      builder: (context, state) {
        final isLinked = pet.qrCodeId != null;

        return Row(
          children: [
            Text(
              isArabic() ? "حالة   QR " : 'QR Status: ',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: isLinked ? Colors.green : null,
                border:
                    isLinked
                        ? null
                        : Border.all(
                          color: isLinked ? Colors.green : Colors.grey.shade400,
                          width: 1,
                        ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                isLinked
                    ? isArabic()
                        ? 'مرتبط'
                        : 'Linked'
                    : isArabic()
                    ? 'غير مرتبط'
                    : 'Not Linked',
                style: TextStyle(
                  fontSize: 10,
                  color:
                      isLinked
                          ? Colors.white
                          : MainCubit.get(context).isDark
                          ? Colors.white
                          : Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
