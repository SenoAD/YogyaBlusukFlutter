import 'package:yogya_blusuk/Domain/Entities/api_domain_entities.dart';

abstract class AccountRepository {
  Future<UserWithToken> loginToken(String username, String password);
  Future register(UserCreate userCreate);
}