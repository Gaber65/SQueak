import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:squeak/core/constant/global_function/global_function.dart';
import 'package:squeak/core/helper/build_service/main_cubit/main_cubit.dart';
import 'package:squeak/core/thames/decorations.dart';
import 'package:squeak/core/thames/styles.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isArabic() ? 'سياسة الخصوصية' : 'Privacy Policy'),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            decoration: Decorations.kDecorationBoxShadow(context: context),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: FastCachedImage(
                      url: "https://veticareapp.com/share/logo.png",
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      isArabic() ? 'سياسة الخصوصية' : 'Privacy Policy',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        color: Color(0xFF007ACC),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildSection(
                    context,
                    isArabic()
                        ? 'المعلومات التي نجمعها'
                        : 'Information We Collect',
                    isArabic()
                        ? 'قد نجمع الأنواع التالية من المعلومات:'
                        : 'We may collect the following types of information',
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Color(0x1A007ACC),
                        border: BorderDirectional(
                          start: BorderSide(color: Color(0xFF007ACC), width: 3),
                        )),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(isArabic()
                          ? "المعلومات الشخصية (الاسم، عنوان البريد الإلكتروني، رقم الهاتف، إلخ)"
                          : "Personal identification information (Name, email address, phone number, etc.)"),
                    ),
                  ),
                  _buildSection(
                    context,
                    isArabic()
                        ? 'كيف نستخدم معلوماتك'
                        : 'How We Use Your Information',
                    isArabic()
                        ? 'تُستخدم معلوماتك لتقديم وتحسين خدماتنا.'
                        : 'Your information is used to provide and improve our services.',
                  ),
                  _buildSection(
                    context,
                    isArabic() ? 'حماية المعلومات' : 'Information Protection',
                    isArabic()
                        ? 'نحن نأخذ أمن البيانات على محمل الجد ونطبق تدابير مناسبة لحماية معلوماتك الشخصية من الوصول غير المصرح به أو التعديل أو الإفشاء.'
                        : 'We take data security seriously and implement appropriate measures to safeguard your personal information against unauthorized access, alteration, or disclosure.',
                  ),
                  _buildSection(
                    context,
                    isArabic() ? 'مشاركة معلوماتك' : 'Sharing Your Information',
                    isArabic()
                        ? 'لا نقوم ببيع أو تداول معلوماتك الشخصية. ومع ذلك، قد نشارك بعض المعلومات مع مزودي الخدمات الموثوق بهم لدعم وتحسين خدماتنا. يُطلب من هؤلاء المزودين الالتزام بمعايير حماية البيانات الصارمة ويُسمح لهم فقط باستخدام المعلومات للأغراض الموضحة في سياسة الخصوصية الخاصة بنا.'
                        : 'We do not sell or trade your personal information. However, we may share certain information with trusted third-party service providers to support and improve our services. These providers are required to adhere to strict data protection standards and are only permitted to use the information for the purposes outlined in our privacy policy..',
                  ),
                  _buildSection(
                    context,
                    isArabic()
                        ? 'أمان البيانات والخصوصية'
                        : 'Data Security and Privacy',
                    isArabic()
                        ? 'خصوصيتك وأمن بيانات عيادتك هما من أولوياتنا. نحن نطبق تدابير أمان وفقًا للمعايير الصناعية لحماية بياناتك من الوصول غير المصرح به أو التعديل أو الإفشاء. يتم تحديث أنظمتنا بانتظام لمعالجة الثغرات المحتملة وضمان أعلى مستوى من الحماية.'
                        : 'Your privacy and the security of your clinic\'s data are of utmost importance to us.We implement industry-standard security measures to protect your data against unauthorized access, alteration, and disclosure. Our systems are regularly updated to address potential vulnerabilities and ensure the highest level of protection.',
                  ),
                  _buildSection(
                    context,
                    isArabic()
                        ? 'تحكم المستخدم في البيانات'
                        : 'User Control Over Data',
                    isArabic()
                        ? 'لديك السيطرة الكاملة على البيانات التي تشاركها معنا. يمكنك تحديث أو تعديل أو حذف معلوماتك الشخصية ومعلومات العيادة في أي وقت من خلال منصتنا. نوفر لك إعدادات واضحة وخيارات لإدارة بياناتك لضمان أنك دائمًا تتحكم في المعلومات المخزنة والمشتركة.'
                        : 'You have full control over the data you share with us. You can update, modify, or delete your personal and clinic information at any time through our platform. We provide clear settings and options for managing your data to ensure you are always in control of what information is stored and shared..',
                  ),
                  _buildSection(
                    context,
                    isArabic() ? 'تشفير البيانات' : 'Data Encryption',
                    isArabic()
                        ? 'يتم تشفير جميع البيانات المرسلة بين تطبيقنا وخوادمنا باستخدام بروتوكولات آمنة (مثل HTTPS). بالإضافة إلى ذلك، يتم تشفير المعلومات الحساسة، بما في ذلك بيانات عيادتك ومعلومات الدفع، وتخزينها بأمان لمنع الوصول غير المصرح به.'
                        : 'All data transmitted between our application and our servers is encrypted using secure protocols (such as HTTPS). Additionally, sensitive information, including your clinic\'s data and payment information, is encrypted and securely stored to prevent unauthorized access.',
                  ),
                  _buildSection(
                    context,
                    isArabic()
                        ? 'الامتثال للوائح حماية البيانات'
                        : 'Compliance with Data Protection Regulations',
                    isArabic()
                        ? 'نحن نلتزم بالقوانين واللوائح ذات الصلة بحماية البيانات لضمان التعامل مع بياناتك بأقصى قدر من العناية ووفقًا للمتطلبات القانونية. يشمل ذلك الالتزام بأفضل الممارسات في مجال خصوصية البيانات وحمايتها، وتوفير معلومات شفافة حول كيفية استخدام بياناتك.'
                        : 'We comply with relevant data protection laws and regulations.',
                  ),
                  _buildSection(
                    context,
                    isArabic()
                        ? 'سياسة الاحتفاظ بالبيانات'
                        : 'Data Retention Policy',
                    !isArabic()
                        ? 'We retain your data only for as long as necessary to provide you with our services and for legitimate business purposes, such as maintaining records for financial, legal, or compliance reasons. Once the data is no longer needed, we take steps to securely delete or anonymize it.'
                        : 'نحتفظ ببياناتك فقط طالما كانت ضرورية لتقديم خدماتنا ولأغراض أعمال مشروعة، مثل الاحتفاظ بالسجلات لأغراض مالية أو قانونية أو امتثال. بمجرد أن تصبح البيانات غير ضرورية، نتخذ خطوات لحذفها بأمان أو إخفاء هويتها.',
                  ),
                  _buildSection(
                    context,
                    isArabic()
                        ? 'تدقيقات الأمان المنتظمة'
                        : 'Regular Security Audits',
                    isArabic()
                        ? 'نقوم بإجراء تدقيقات أمنية منتظمة لتحديد ومعالجة المخاطر الأمنية المحتملة. فريقنا مكرس لمراقبة وتعزيز تدابير الأمان باستمرار لضمان سلامة وخصوصية بيانات عيادتك.'
                        : 'We conduct regular security audits to identify and address potential security risks. Our team is dedicated to continuously monitoring and enhancing our security measures to ensure the safety and privacy of your clinic\'s data.',
                  ),
                  _buildSection(
                    context,
                    isArabic()
                        ? 'اتصل بنا بخصوص الخصوصية'
                        : 'Contact Us About Privacy',
                    isArabic()
                        ? 'إذا كانت لديك أي مخاوف أو استفسارات حول كيفية تعاملنا مع بياناتك أو إذا كنت ترغب في ممارسة حقوقك المتعلقة بالبيانات، يرجى الاتصال بفريق الخصوصية الخاص بنا على support@veticare.com. نحن هنا لضمان شعورك بالثقة والأمان عند استخدام خدماتنا.'
                        : 'If you have any concerns or questions about how we handle your data or if you would like to exercise your data rights, please contact our privacy team at support@veticare.com. We are here to ensure that you feel confident and secure in using our services.',
                  ),
                  _buildSection(
                    context,
                    isArabic() ? 'إشعار التحديث' : 'Update Notification',
                    isArabic()
                        ? 'قد نقوم بتحديث سياسة الخصوصية الخاصة بنا من وقت لآخر. عندما نقوم بذلك، سنقوم بإبلاغك عن طريق نشر السياسة الجديدة على هذه الصفحة. تقع على عاتقك مسؤولية مراجعة هذه السياسة بشكل دوري للاطلاع على أي تغييرات.'
                        : 'We may update our privacy policy from time to time. When we do, we will notify you by posting the new policy on this page. It is your responsibility to review this privacy policy periodically for any changes.',
                  ),
                  _buildSection(
                    context,
                    isArabic() ? 'موافقتك' : 'Your Consent',
                    isArabic()
                        ? 'باستخدام تطبيقنا، فإنك توافق على سياسة الخصوصية الخاصة بنا.'
                        : 'By using our app, you consent to our privacy policy.',
                  ),
                  _buildSection(
                      context,
                      isArabic() ? 'اتصل بنا' : 'Contact Us',
                      isArabic()
                          ? 'إذا كان لديك أي أسئلة حول سياسة الخصوصية هذه، يرجى الاتصال بنا على support@veticare.com.'
                          : 'If you have any questions about this privacy policy, please contact us at support@veticare.com.'),
                  SizedBox(height: 30),
                  Center(
                    child: Text(
                      isArabic()
                          ? '© 2024 فيتيكير. جميع الحقوق محفوظة.'
                          : '© 2024 VetICare. All rights reserved.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String description) {
    const email = "support@veticare.com";

    final emailTextStyle = TextStyle(
      fontSize: 16,
      color: Color(0xFF007ACC),
      decoration: TextDecoration.underline,
    );

    final normalTextStyle = TextStyle(
      fontSize: 16,
      color: MainCubit.get(context).isDark
          ? Colors.white
          : Colors.black, // Black color for normal text
    );

    final parts = description.split(email);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: FontStyleThame.textStyle(
              fontSize: 18,
              context: context,
              fontWeight: FontWeight.bold,
              fontColor: Color(0xFF007ACC),
            ),
          ),
          SizedBox(height: 10),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(text: parts[0], style: normalTextStyle),
                if (parts.length > 1)
                  TextSpan(
                    text: email,
                    style: emailTextStyle,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        final Uri emailUri = Uri(
                          scheme: 'mailto',
                          path: email,
                        );
                        try {
                          final canLaunchResult =
                              await canLaunch(emailUri.toString());
                          print(
                              'Can launch result: $canLaunchResult'); // Debugging output
                          if (canLaunchResult) {
                            await launch(emailUri.toString());
                          } else {
                            print(
                                'Could not launch ${emailUri.toString()}. Copying to clipboard...');
                            await Clipboard.setData(ClipboardData(text: email));
                          }
                        } catch (e) {
                          print('Error launching email client: $e');
                        }
                      },
                  ),
                if (parts.length > 1)
                  TextSpan(text: parts[1], style: normalTextStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
