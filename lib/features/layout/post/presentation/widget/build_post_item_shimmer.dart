import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/service/global_widget/custom_text_form_field.dart';
import '../../../../../core/utils/theme/decorations/decorations.dart';

class BuildPostItemShimmer extends StatelessWidget {
  const BuildPostItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Decorations.kDecorationBoxShadow(context: context),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Shimmer.fromColors(
        baseColor: Colors.grey,
        highlightColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(radius: 22.0),
                  const SizedBox(width: 15.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                          ),
                          width: 120,
                          height: 10,
                        ),
                        const SizedBox(height: 5.0),
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                          ),
                          width: 40,
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15.0),
                ],
              ),
              SizedBox(height: 12),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadiusDirectional.all(Radius.circular(8)),
                ),
                height: 170,
                width: double.infinity,
              ),
              SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(radius: 20.0),
                  const SizedBox(width: 15.0),
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: InkWell(
                        onTap: () {},
                        child: MyTextForm(
                          prefixIcon: const SizedBox(),
                          controller: TextEditingController(),
                          hintText: 'Write Your Comment',
                          enable: false,
                          obscureText: false,
                          enabled: false,
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
}
