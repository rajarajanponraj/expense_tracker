import 'package:expenseflow/app/components/custom_snackbar.dart';
import 'package:expenseflow/app/data/local/my_hive.dart';
import 'package:expenseflow/app/data/models/expense.dart';
import 'package:expenseflow/app/data/models/user_model.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import '../../routes/app_pages.dart';
import '../models/user.dart';

class MyIsar {
  MyIsar._(); // Prevent instantiation

  static late Isar isarDb;

  static Future<void> init({Function(IsarCollection)? registerAdapters, String? testPath}) async {
    final dir = await getApplicationDocumentsDirectory();
    if (testPath != null) {
      isarDb = await Isar.open(
        [UserSchema, ExpenseSchema], // Assuming UserSchema and ExpenseSchema are defined
        directory: testPath,
      );
    } else {
      if (!Isar.instanceNames.contains('main')) {
        isarDb = await Isar.open(
          [UserSchema, ExpenseSchema],
          directory: dir.path,
        );
      }
    }
  }

  static Future<void> registerUser(String name, String email, int age, int phoneNumber) async {
    final user = User()
      ..username = name
      ..password = email
      ..age = age
      ..phoneNumber = phoneNumber
    ..updatedAt=DateTime.now()
    ..createdAt=DateTime.now()
    ;

    try {
      await isarDb.writeTxn(() async {
        await isarDb.users.put(user);
        CustomSnackBar.showCustomToast(message: 'Successfully Registered');
      });
    } catch (e) {
      CustomSnackBar.showCustomToast(message: 'Failed to register: $e');
    }
  }

  static Future<User?> loginUser(String email, String password) async {
    try {
      final user = await isarDb.users.filter().usernameEqualTo(email).and().passwordEqualTo(password).findFirst();
      if (user != null) {

        MyHive.saveUserToHive(UserModel.fromData(age: user.age!, phoneNumber: user.phoneNumber!.toString(), username: user.username!, password: user.password!));
        // Handle successful login actions
        CustomSnackBar.showCustomToast(message: 'Successfully Logged In');
        Get.offAndToNamed(Routes.HOME); // Navigate to HOME route using GetX
      } else {
        CustomSnackBar.showCustomToast(message: 'User doesn\'t exist');
      }
      return user;
    } catch (e) {
      CustomSnackBar.showCustomToast(message: 'Login error: $e');
      return null;
    }
  }

  static Future<List<Expense>> getAllExpense() async {
    try {
      return await isarDb.expenses.where().findAll();
    } catch (e) {
      CustomSnackBar.showCustomToast(message: 'Error fetching expenses: $e');
      return [];
    }
  }

  static Future<void> createExpense(String title, String brief, String amount, DateTime time) async {
    final expense = Expense()
      ..title = title
      ..brief = brief
      ..amount = amount
      ..createdAt = time
      ..updatedAt = DateTime.now();

    try {
      await isarDb.writeTxn(() async {
        await isarDb.expenses.put(expense);
        CustomSnackBar.showCustomToast(message: 'Expense added successfully');
      });
    } catch (e) {
      CustomSnackBar.showCustomToast(message: 'Failed to add expense: $e');
    }
  }

  static Future<Expense?> getExpense(int id) async {
    try {
      return await isarDb.expenses.get(id);
    } catch (e) {
      CustomSnackBar.showCustomToast(message: 'Error fetching expense: $e');
      return null;
    }
  }

  static Future<void> editExpense(Expense e) async {

    try {
      await isarDb.writeTxn(() async {
        final updateExpense =await isarDb.expenses.get(e.id);
        if(updateExpense !=null){
          print('edit funtion');
          print(e.id);
          print(e.title);
          print(e.amount);
          print(e.brief);
          print(e.createdAt);
          print(e.updatedAt);
          updateExpense.title=e.title;
          updateExpense.brief=e.brief;
          updateExpense.amount=e.amount;
          updateExpense.createdAt=e.createdAt;
          updateExpense.updatedAt=DateTime.now();
          await isarDb.expenses.put(updateExpense);
          CustomSnackBar.showCustomToast(message: 'Updated Successfully');
        }


      });
    } catch (e) {
      CustomSnackBar.showCustomToast(message: 'Failed to update expense: $e');
    }
  }

  static Future<void> deleteExpense(int id) async {
    try {
      await isarDb.writeTxn(() async {
        await isarDb.expenses.delete(id);
        CustomSnackBar.showCustomToast(message: 'Deleted Successfully');
      });
    } catch (e) {
      CustomSnackBar.showCustomToast(message: 'Failed to delete expense: $e');
    }
  }

  static String formatDateTime(DateTime dateTime) {
    final formatter = DateFormat('yyyy-MM-dd HH:mm');
    return formatter.format(dateTime);
  }
}