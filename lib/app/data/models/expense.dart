import 'package:isar/isar.dart';

part 'expense.g.dart';

@collection
class Expense {
  Id id = Isar.autoIncrement; // you can also use id = null to auto increment

  String? amount;

  String? title;

  String? brief;

  DateTime? createdAt;

  DateTime? updatedAt;

}