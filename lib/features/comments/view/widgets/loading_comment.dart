import 'package:comment_tree/data/comment.dart';
import 'package:comment_tree/widgets/comment_tree_widget.dart';
import 'package:comment_tree/widgets/tree_theme_data.dart';
import 'package:flutter/material.dart';

import 'package:shimmer/shimmer.dart';
import 'package:squeak/core/thames/styles.dart';

import '../../../../core/constant/global_function/global_function.dart';
import '../../../../core/helper/build_service/main_cubit/main_cubit.dart';

class CommentWidget extends StatelessWidget {
  const CommentWidget({
    super.key,
    required this.scaffoldKey,
  });

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade400,
      highlightColor: Colors.grey.shade300,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Directionality(
          textDirection: isArabic() ? TextDirection.rtl : TextDirection.ltr,
          child: ListView.builder(
            itemBuilder: (context, index) {
              return CommentTreeWidget<Comment, Comment>(
                commentsDummy[index],
                [],
                treeThemeData: TreeThemeData(
                  lineColor: ColorTheme.primaryColor,
                  lineWidth: 1,
                ),
                avatarRoot: (context, data) {
                  return PreferredSize(
                    preferredSize: Size.fromRadius(25),
                    child: CircleAvatar(
                      radius: 25,
                    ),
                  );
                },
                contentRoot: (context, data) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 60,
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          color: MainCubit.get(context).isDark
                              ? Colors.white10
                              : Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 1.2,
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 1.1,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                    ],
                  );
                },
              );
            },
            itemCount: 5,
          ),
        ),
      ),
    );
  }
}

List<Comment> commentsDummy = [
  Comment(
      avatar:
          'https://img.freepik.com/premium-vector/people-communication-icon-comic-style-people-vector-cartoon-illustration-pictogram-partnership-business-concept-splash-effect_157943-6552.jpg?size=626&ext=jpg&uid=R78903714&ga=GA1.1.798062041.1678310296&semt=ais',
      userName: 'null',
      content: 'A Dart template generator which helps teams'),
  Comment(
      avatar:
          'https://img.freepik.com/premium-vector/people-communication-icon-comic-style-people-vector-cartoon-illustration-pictogram-partnership-business-concept-splash-effect_157943-6552.jpg?size=626&ext=jpg&uid=R78903714&ga=GA1.1.798062041.1678310296&semt=ais',
      userName: 'null',
      content: 'A Dart template generator which helps teams'),
  Comment(
      avatar:
          'https://img.freepik.com/premium-vector/people-communication-icon-comic-style-people-vector-cartoon-illustration-pictogram-partnership-business-concept-splash-effect_157943-6552.jpg?size=626&ext=jpg&uid=R78903714&ga=GA1.1.798062041.1678310296&semt=ais',
      userName: 'null',
      content: 'A Dart template generator which helps teams'),
  Comment(
      avatar:
          'https://img.freepik.com/premium-vector/people-communication-icon-comic-style-people-vector-cartoon-illustration-pictogram-partnership-business-concept-splash-effect_157943-6552.jpg?size=626&ext=jpg&uid=R78903714&ga=GA1.1.798062041.1678310296&semt=ais',
      userName: 'null',
      content:
          'A Dart template generator which helps teams generator which helps teams generator which helps teams'),
  Comment(
      avatar:
          'https://img.freepik.com/premium-vector/people-communication-icon-comic-style-people-vector-cartoon-illustration-pictogram-partnership-business-concept-splash-effect_157943-6552.jpg?size=626&ext=jpg&uid=R78903714&ga=GA1.1.798062041.1678310296&semt=ais',
      userName: 'null',
      content: 'A Dart template generator which helps teams'),
  Comment(
      avatar:
          'https://img.freepik.com/premium-vector/people-communication-icon-comic-style-people-vector-cartoon-illustration-pictogram-partnership-business-concept-splash-effect_157943-6552.jpg?size=626&ext=jpg&uid=R78903714&ga=GA1.1.798062041.1678310296&semt=ais',
      userName: 'null',
      content:
          'A Dart template generator which helps teams generator which helps teams '),
];
