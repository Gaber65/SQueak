import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import '../../../../../core/service/global_widget/custom_text_form_field.dart';
import '../../../../../generated/l10n.dart';
import '../../../../profile_switch/Presentation/cubit/switch_profile_cubit.dart';
import '../screens/upload_post.dart';
import 'get_posts_when_user_follow.dart';

Widget buildWhatsonyourmindSanjay(BuildContext context, String petId) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: Colors.blue,
          child:
              SwitchProfileCubit.get(context).image.isNotEmpty
                  ? ClipOval(
                    child: Image.network(
                      SwitchProfileCubit.get(context).image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder:
                          (context, error, stackTrace) => Center(
                            child: Text(
                              SwitchProfileCubit.get(
                                context,
                              ).name[0].toUpperCase(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                    ),
                  )
                  : Text(
                    SwitchProfileCubit.get(context).name[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 15, top: 8, bottom: 8),
            child: SizedBox(
              height: 38,
              child: MyTextForm(
                controller: TextEditingController(),
                hintText:
                    '${S.of(context).labelPost} ${SwitchProfileCubit.get(context).name}?',
                obscureText: false,
                enable: false,
                prefixIcon: const Icon(IconlyLight.image, size: 16),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadiusDirectional.circular(12),
            ),
            child: IconButton(
              onPressed: () {
                if (petId.isEmpty) {
                  showGuideOverlay(context);
                } else {
                  var image = SwitchProfileCubit.get(context).image;
                  var petID = SwitchProfileCubit.get(context).petID;
                  var name = SwitchProfileCubit.get(context).name;
                  Navigator.push(
                    context,
                    DialogRoute(
                      context: context,
                      builder: (context) {
                        return UploadPost(
                          petID: petID,
                          image: image,
                          name: name,
                        );
                      },
                    ),
                  );
                }
              },
              icon: Icon(Icons.near_me, size: 16),
            ),
          ),
        ),
      ],
    ),
  );
}
