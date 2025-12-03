import 'package:flutter/widgets.dart';

class AppStrings {
  static bool _isArabic(BuildContext context) => Localizations.localeOf(
    context,
  ).languageCode.toLowerCase().startsWith('ar');

  static String tapToAddPhoto(BuildContext context) =>
      _isArabic(context) ? 'اضغط لإضافة صورة' : 'Tap to add photo';

  static String storyPostedSuccess(BuildContext context) =>
      _isArabic(context) ? 'تم نشر القصة بنجاح!' : 'Story posted successfully!';

  static String validationSelectImage(BuildContext context) =>
      _isArabic(context)
          ? 'يرجى اختيار صورة للمتابعة.'
          : 'Please select an image to continue.';

  static String postStory(BuildContext context) =>
      _isArabic(context) ? 'زر نشر القصة' : 'Post Story';

  static String cancelStory(BuildContext context) =>
      _isArabic(context) ? 'إلغاء القصة' : 'Cancel';

  static String deleteStoryisDonw(BuildContext context) =>
      _isArabic(context) ? 'تم حذف القصة' : 'Story deleted successfully!';
}
