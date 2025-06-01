import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/auth/register/presentation/cubit/register_cubit.dart';

class ConsentCheckbox extends StatefulWidget {
  const ConsentCheckbox({
    super.key,
    required this.cubit,
    required this.clinicName,
  });

  final RegisterCubit cubit;
  final String clinicName;

  @override
  State<ConsentCheckbox> createState() => _ConsentCheckboxState();
}

class _ConsentCheckboxState extends State<ConsentCheckbox> {
  bool isShared = false;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Card(
          color:
              MainCubit.get(context).isDark
                  ? Colors.blue.shade900
                  : Colors.orange.shade50,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: isShared,

                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onChanged: (value) {
                    isShared = value!;
                    widget.cubit.toggleDataSharing(value);
                    setState(() {});
                  },
                  activeColor: ColorManager.primaryColor,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: _getConsentPrefix(),
                            style: FontStyleThame.textStyle(
                              context: context,
                              fontSize: 13,
                              fontColor:
                                  MainCubit.get(context).isDark
                                      ? Colors.white60
                                      : Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: widget.clinicName,
                            style: FontStyleThame.textStyle(
                              context: context,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              fontColor:
                                  MainCubit.get(context).isDark
                                      ? Colors.white
                                      : ColorManager.primaryColor,
                            ),
                          ),
                          TextSpan(
                            text: _getConsentSuffix(),
                            style: FontStyleThame.textStyle(
                              context: context,
                              fontColor:
                                  MainCubit.get(context).isDark
                                      ? Colors.white60
                                      : Colors.black,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getConsentPrefix() {
    return isArabic()
        ? 'أوافق على مشاركة اسمي ورقم هاتفي مع '
        : "I agree to share my name and phone number with ";
  }

  String _getConsentSuffix() {
    return isArabic()
        ? ' للحصول على العروض والترويجات ومعلومات الخدمة.'
        : " for receiving offers, promotions, and service information.";
  }
}
