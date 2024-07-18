import 'package:expenseflow/app/data/local/my_isar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../data/models/expense.dart';
import '../../../data/models/user.dart';
import '../../../services/api_call_status.dart';

class HomeController extends GetxController {
  RxInt index = 0.obs;
  RxInt overall = 0.obs;
  RxMap<DateTime, List<Expense>> groupedExpenses = <DateTime, List<Expense>>{}.obs;
  RxList<Expense> expenses = <Expense>[].obs;

  ApiCallStatus apiCallStatus = ApiCallStatus.holding;

  Future<void> registerUser(String name, String email, int age, int phoneNumber) async {
    await MyIsar.registerUser(name, email, age, phoneNumber);
  }

  Future<User?> loginUser(String email, String password) async {
    return await MyIsar.loginUser(email, password);
  }

  Future<void> getAllExpenses() async {
    final allExpenses = await MyIsar.getAllExpense();
    overall.value = allExpenses.fold(0, (sum, expense) => sum + int.parse(expense.amount!));

    // Group expenses by date
    final Map<DateTime, List<Expense>> grouped = {};
    if(allExpenses.isNotEmpty) {
      for (var expense in allExpenses) {

        final date = DateTime(expense.createdAt!.year, expense.createdAt!.month,
            expense.createdAt!.day);
        if (grouped.containsKey(date)) {
          grouped[date]!.add(expense);
        } else {
          grouped[date] = [expense];
        }
      }
    }

    // Sort the groups by date
    final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));
    final sortedGroupedExpenses = {for (var key in sortedKeys) key: grouped[key]!};

    groupedExpenses.assignAll(sortedGroupedExpenses);
    expenses.assignAll(allExpenses);
    apiCallStatus = ApiCallStatus.success;
    update();
  }

  Future<Expense?> getExpense(int id) async {
    return await MyIsar.getExpense(id);
  }

  Future<void> createExpense(String title, String brief, String amount, DateTime time) async {
    await MyIsar.createExpense(title, brief, amount, time);
    await getAllExpenses();
    update();
  }

  Future<void> updateExpense(int id, String title, String amount, String brief,DateTime time) async {
    final expense = await getExpense(id);
    if (expense != null) {
      expense.title = title;
      expense.amount = amount;
      expense.brief = brief;
      expense.createdAt=time;
      expense.updatedAt = DateTime.now();
      print('update funtion');
      // print(expense.id);
      print(expense.title);
      print(expense.amount);
      print(expense.brief);
      print(expense.createdAt);
      print(expense.updatedAt);
      await MyIsar.editExpense(expense);
      await getAllExpenses();
      update();
    }
  }

  Future<void> deleteExpense(int id) async {
    await MyIsar.deleteExpense(id);
    await getAllExpenses();
    update();
  }

  String getFormattedDate(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(date);
  }

  List<Expense> getExpensesByDate(DateTime date) {
    return groupedExpenses[date] ?? [];
  }



  Map<String, int> getWeeklySummary() {
    final now = DateTime.now();
    final lastWeek = now.subtract(const Duration(days: 7));
    final weeklyExpenses = expenses.where((expense) =>
    expense.createdAt!.isAfter(lastWeek) && expense.createdAt!.isBefore(now));
    final summary = <String, int>{};

    for (var expense in weeklyExpenses) {
      final day = DateFormat('EEEE').format(expense.createdAt!);
      summary[day] = (summary[day] ?? 0) + int.parse(expense.amount!);
    }

    return summary;
  }

  Map<String, int> getMonthlySummary() {
    final now = DateTime.now();
    final lastMonth = now.subtract(const Duration(days: 30));
    final monthlyExpenses = expenses.where((expense) =>
    expense.createdAt!.isAfter(lastMonth) && expense.createdAt!.isBefore(now));
    final summary = <String, int>{};

    for (var expense in monthlyExpenses) {
      final week = 'Week ${((expense.createdAt!.day - 1) / 7 + 1).ceil()}';
      summary[week] = (summary[week] ?? 0) + int.parse(expense.amount!);
    }

    return summary;
  }

  @override
  void onInit() {
    getAllExpenses();
    super.onInit();
  }
}
