import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/features/auth/contactus/domin/entities/contact_us_entity.dart';
import 'package:squeak/features/auth/contactus/domin/usecses/contact_us_use_case.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/utils/export_path/export_files.dart';

part 'contact_us_state.dart';

class ContactUsCubit extends Cubit<ContactUsState> {
  static ContactUsCubit get(BuildContext context) => BlocProvider.of(context);

  final ContactUsUseCase contactUsUseCase;

  ContactUsCubit(this.contactUsUseCase) : super(ContactUsInitial());

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final commentController = TextEditingController();
  final titleController = TextEditingController();
  final nameController = TextEditingController();

  bool isContactUs = false;

  void init(context) {
    if (CacheHelper.getData('phone') != null) {
      emailController.text = CacheHelper.getData('email');
      nameController.text = CacheHelper.getData('username');
      phoneController.text = CacheHelper.getData('phone');
    }
  }

  Future<void> contactUs() async {
    if (!formKey.currentState!.validate()) return;

    isContactUs = true;
    emit(ContactUsLoadingState());
    await contactUsUseCase
        .execute(
          ContactUsEntity(
            title: titleController.text,
            phone: phoneController.text,
            fullName: nameController.text,
            comment: commentController.text,
            email: emailController.text,
          ),
        )
        .then((value) {
          isContactUs = false;
          emit(ContactUsSuccessState());
        })
        .catchError((error) {
          ServerException failure = error;
          isContactUs = false;
          emit(ContactUsErrorState(failure.errorMessageModel));
        });
  }

  void clearContactUs() {
    titleController.clear();
    phoneController.clear();
    nameController.clear();
    commentController.clear();
    emailController.clear();
  }

  @override
  Future<void> close() {
    // Dispose controllers to free resources
    emailController.dispose();
    phoneController.dispose();
    commentController.dispose();
    titleController.dispose();
    nameController.dispose();
    return super.close();
  }
}
