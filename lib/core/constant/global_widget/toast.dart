import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

void successToast(context,String title) {
  toastification.show(
    context: context,
    type: ToastificationType.success,
    style: ToastificationStyle.minimal,
    autoCloseDuration: const Duration(seconds: 5),
    title: Text(title,maxLines: 2,),
    alignment: Alignment.topRight,
    animationDuration: const Duration(milliseconds: 300),
    icon: const Icon(Icons.check),
    showProgressBar: true,
  );
}

void errorToast(context,String title) {
  toastification.show(
    context: context,
    type: ToastificationType.error,
    style: ToastificationStyle.minimal,
    autoCloseDuration: const Duration(seconds: 3),
    title: Text(title,maxLines: 2,),
    alignment: Alignment.topRight,
    direction: TextDirection.ltr,
    animationDuration: const Duration(milliseconds: 300),
    icon: const Icon(Icons.error_outline),
  );
}

void infoToast(context,String title) {
  toastification.show(
    context: context,
    type: ToastificationType.warning,
    style: ToastificationStyle.minimal,
    autoCloseDuration: const Duration(seconds: 5),
    title: Text(title,maxLines: 2,),
    alignment: Alignment.topRight,
    direction: TextDirection.ltr,
    animationDuration: const Duration(milliseconds: 300),
    icon: const Icon(Icons.info_outline),

  );
}
