import '../entities/contact_us_entity.dart';

abstract class ContactUsRepository {
  Future<void> sendContactRequest(ContactUsEntity entity);
}