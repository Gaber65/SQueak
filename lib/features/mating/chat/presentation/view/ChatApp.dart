import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';

import '../controllers/chat_list_cubit.dart';
import 'ChatHomePage.dart';
import 'chat_app_cubit.dart';

class ChatApp extends StatelessWidget {
  final String petId;
  final String fullName;
  final String image;

  const ChatApp({
    super.key,
    required this.petId,
    required this.fullName,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ChatAppCubit(
            petId: petId,
            fullName: fullName,
            image: image,

          )..initialize(),


        ),
        BlocProvider(
          create: (context) => sl<ChatListCubit>()..loadChats(petId),
        ),

      ],
      child: const ChatHomePage(),
    );
  }
}
