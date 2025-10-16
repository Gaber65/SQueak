import 'package:flutter/material.dart';
import 'package:squeak/core/service/global_function/format_utils.dart';

class LoadingWidget extends StatelessWidget {
  final String enMessage;
  final String arMessage;
  const LoadingWidget({
    super.key,
    required this.enMessage,
    required this.arMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 10),
          Text(
            isArabic() ? arMessage : enMessage,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class LoadingItem extends StatelessWidget {
  const LoadingItem({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: CircularProgressIndicator(),
      ),
    );
  }
}
