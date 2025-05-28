import 'package:dio/dio.dart';
import 'package:squeak/features/auth/contactus/data/datasources/contact_us_remote_data_source.dart';
import 'package:squeak/features/auth/contactus/domin/entities/contact_us_entity.dart';
import 'package:squeak/features/auth/contactus/domin/repositries/contact_us_repository.dart';
import '../../../../../core/service/service_locator/locatore_export_path.dart';

class ContactUsRepositoryImpl implements ContactUsRepository {
  final ContactUsRemoteDataSource remoteDataSource;

  ContactUsRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> sendContactRequest(ContactUsEntity entity) async {
    try {
      await remoteDataSource.contactUs(
        title: entity.title,
        phone: entity.phone,
        fullName: entity.fullName,
        comment: entity.comment,
        email: entity.email,
      );
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }
}
