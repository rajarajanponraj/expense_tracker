import 'package:isar/isar.dart';

part 'user.g.dart';

@collection
class User {
  Id id = Isar.autoIncrement; // you can also use id = null to auto increment

  String? username;

  int? age;

  int? phoneNumber;

  String? password;

  DateTime? createdAt;

  DateTime? updatedAt;

}


