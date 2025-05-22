import 'package:squeak/features/auth/contactus/domin/repositries/contact_us_repository.dart';

import '../entities/contact_us_entity.dart';

class ContactUsUseCase {
  final ContactUsRepository repository;

  ContactUsUseCase(this.repository);

  Future<void> execute(ContactUsEntity entity) async {
    return await repository.sendContactRequest(entity);
  }
}
