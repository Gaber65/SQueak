import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/constant/global_function/global_function.dart';
import 'package:squeak/core/helper/build_service/main_cubit/main_cubit.dart';

import '../../../../core/thames/decorations.dart';

class FileCardWidget extends StatelessWidget {
  const FileCardWidget({
    super.key,
    required this.fileName,
    required this.fileDate,
    required this.fileDescription,
  });

  final String? fileName;
  final String? fileDate;
  final String? fileDescription;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        var mainCubit = BlocProvider.of<MainCubit>(context);
        return Container(
          // height: MediaQuery.of(context).size.height * 0.11,
          width: double.infinity,
          decoration:
              Decorations.kDecorationBoxShadow(context: context, radius: 64),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(
                  Icons.attach_file_rounded,
                ),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // Align text to the start
                    children: [
                      Text(
                        fileName ?? "Unnamed File",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        // Handle long file names
                        maxLines: 1,
                      ),
                      SizedBox(height: 4),
                      Text(
                        fileDescription == "null" || fileDescription == null
                            ? ""
                            : fileDescription.toString(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w300,
                          color: mainCubit.isDark
                              ? Colors.white
                              : Colors.grey[600],
                        ),
                        overflow: TextOverflow.ellipsis,
                        // Handle long descriptions
                        maxLines: 4,
                      ),
                    ],
                  ),
                ),
                // Spacer(),
                SizedBox(
                  width: 16,
                ),
                Text(
                  formatDateString(fileDate ?? ""),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  overflow: TextOverflow.ellipsis, // Handle long dates
                  maxLines: 1,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/*
    Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("${fileName} , ${formatDate(
            fileDate.toString(),
          )}"),
          Text(
            ' ${fileDescription == "null" ? "" : fileDescription}',
            maxLines: 2,
          ),
        ],
      ),
 */
