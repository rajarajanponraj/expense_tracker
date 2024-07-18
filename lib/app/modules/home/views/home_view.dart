import 'package:expenseflow/app/data/local/my_hive.dart';
import 'package:expenseflow/app/modules/home/views/widgets/input_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../config/translations/strings_enum.dart';
import '../controllers/home_controller.dart';
import 'widgets/header.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final briefController = TextEditingController();
    final amountController = TextEditingController();
    final dateController = TextEditingController();
    var theme = Theme.of(context);
var user =MyHive.getCurrentUser();
    return GetBuilder<HomeController>(builder: (homeController) {
      return Scaffold(
        floatingActionButton:controller.index.value ==0 ? FloatingActionButton(
          tooltip: 'Add',
          elevation: 2,
          child: const Icon(Icons.add),
          onPressed: () {
            showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (context) => Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Padding(
                  padding:  EdgeInsets.symmetric(vertical: 8.h,horizontal: 12.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 1.w),
                          child: Text(Strings.expense.tr, style: const TextStyle(fontSize: 22)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 1.w),
                        child: Text(Strings.title.tr),
                      ),
                      InputTextField(controller: titleController),
                      4.verticalSpace,
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 1.w),
                        child: Text(Strings.brief.tr),
                      ),
                      InputTextField(controller: briefController),
                      4.verticalSpace,
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 1.w),
                        child: Text(Strings.amount.tr),
                      ),
                      InputTextField(
                        format: [FilteringTextInputFormatter.digitsOnly],
                          controller: amountController),
                      4.verticalSpace,
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 1.w),
                        child: Text(Strings.date.tr),
                      ),
                      InkWell(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                            initialDate: DateTime.now(),
                          );
                          dateController.text = date != null ? DateFormat('yyyy-MM-dd').format(date) : '';
                        },
                        child: InputTextField(enabled: false, controller: dateController),
                      ),
                      4.verticalSpace,
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            controller.createExpense(
                              titleController.text,
                              briefController.text,
                              amountController.text,
                              DateTime.parse(dateController.text),
                            );
                            Get.back();
                          },
                          child: Text(Strings.add.tr,style: theme.textTheme.bodyMedium,),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ):const SizedBox(),
        bottomNavigationBar: BottomNavigationBar(
          elevation: 4,
          currentIndex: controller.index.value,
          onTap: (index) {
            controller.index.value = index;
            controller.update();
          },
          items: [
            BottomNavigationBarItem(icon: const Icon(Icons.attach_money), label: Strings.money.tr),
            BottomNavigationBarItem(icon: const Icon(Icons.summarize), label: Strings.summary.tr),
            BottomNavigationBarItem(icon: const Icon(Icons.person), label: Strings.profile.tr),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Header(),
              controller.index.value == 0? Padding(
                padding: EdgeInsets.all(8.h),
                child: Material(
                  borderRadius: BorderRadius.circular(12),
                  elevation: 4,
                  child: Padding(
                    padding: EdgeInsets.all(8.h),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text('Overall Expense: \$ ${controller.overall.value}'),
                    ),
                  ),
                ),
              ):const SizedBox(),
              IndexedStack(
                index: controller.index.value,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0), // Increased padding for better spacing
                    child: SingleChildScrollView(
                      child: Column(
                        children: controller.groupedExpenses.entries.map((entry) {
                          final date = entry.key;
                          final expenses = entry.value;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Added horizontal padding
                                child: Text(
                                  DateFormat('yyyy-MM-dd').format(date),
                                  style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold), // Bold date text
                                ),
                              ),
                              ...expenses.map((expense) {
                                return Card(
                                  elevation: 4, // Increased elevation for better shadow
                                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Added margin for spacing
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16), // Increased border radius
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0), // Increased padding inside card
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              expense.title ?? '',
                                              style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold), // Styled title text
                                            ),
                                            4.verticalSpace,// Added spacing between texts
                                            Text(
                                              expense.brief ?? '',
                                              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[700]), // Styled brief text
                                            ),
                                           4.verticalSpace, // Added spacing between texts
                                            Text(
                                              '\$${expense.amount ?? ''}', // Added dollar sign
                                              style: theme.textTheme.bodyLarge?.copyWith(color: Colors.green[700]), // Styled amount text
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.edit, color: Colors.blue), // Colored icon
                                              onPressed: () {
                                                titleController.text = expense.title ?? '';
                                                briefController.text = expense.brief ?? '';
                                                amountController.text = expense.amount ?? '';
                                                dateController.text = controller.getFormattedDate(expense.createdAt!);
                                                showModalBottomSheet(
                                                  isScrollControlled: true,
                                                  context: context,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)), // Rounded top corners
                                                  ),
                                                  builder: (context) => Padding(
                                                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                    child: Container(
                                                      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w), // Added padding
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min, // Adjusted size
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Center(
                                                            child: Text(
                                                              Strings.expense.tr,
                                                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold), // Styled title
                                                            ),
                                                          ),
                                                          16.verticalSpace, // Added spacing
                                                          Text(Strings.title.tr),
                                                          InputTextField(

                                                              textAction: TextInputAction.next,
                                                              controller: titleController),
                                                          8.verticalSpace, // Added spacing
                                                          Text(Strings.brief.tr),
                                                          InputTextField(
                                                              textAction: TextInputAction.next,
                                                              controller: briefController),
                                                          8.verticalSpace, // Added spacing
                                                          Text(Strings.amount.tr),
                                                          InputTextField(
                                                            keyBoardType: TextInputType.number,
                                                            format: [FilteringTextInputFormatter.digitsOnly],
                                                            textAction: TextInputAction.next,
                                                              controller: amountController),
                                                          8.verticalSpace, // Added spacing
                                                          Text(Strings.date.tr),
                                                          InkWell(
                                                            onTap: () async {
                                                              final date = await showDatePicker(
                                                                context: context,
                                                                firstDate: DateTime(1900),
                                                                lastDate: DateTime.now(),
                                                                initialDate: DateTime.now(),
                                                              );
                                                              dateController.text = date != null ? DateFormat('yyyy-MM-dd').format(date) : '';
                                                            },
                                                            child: InputTextField(enabled: false, controller: dateController),
                                                          ),
                                                          16.verticalSpace, // Added spacing
                                                          Center(
                                                            child: ElevatedButton(
                                                              onPressed: () {
                                                                controller.updateExpense(
                                                                  expense.id,
                                                                  titleController.text.isNotEmpty? titleController.text :  expense.title!,
                                                                  amountController.text.isNotEmpty ?amountController.text:expense.amount!,
                                                                  briefController.text.isNotEmpty?briefController.text:expense.brief!,
                                                                  dateController.text.isNotEmpty ?DateTime.parse(dateController.text):expense.createdAt!
                                                                );
                                                                Get.back();
                                                              },
                                                              // style: ElevatedButton.styleFrom(
                                                              //   textStyle: TextStyle(color: theme.textTheme.bodyMedium!.color),
                                                              //   // Button color
                                                              //   shape: RoundedRectangleBorder(
                                                              //     borderRadius: BorderRadius.circular(8.0), // Button border radius
                                                              //   ),
                                                              // ),
                                                              child: Text(Strings.update.tr,style: theme.textTheme.bodyMedium,),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.delete, color: Colors.red), // Colored icon
                                              onPressed: () {
                                                controller.deleteExpense(expense.id);
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),


                  // Expense Summary Tab
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Weekly Summary',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue, // Primary color
                            ),
                          ),
                          8.verticalSpace, // Spacing between title and content
                          ...controller.getWeeklySummary().entries.map((entry) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    entry.key,
                                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    '\$ ${entry.value.toString()}',
                                    style: theme.textTheme.bodyMedium?.copyWith(color: Colors.green), // Value color
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                           Divider(
                            color: theme.textTheme.bodySmall!.color,
                            height: 28.0, // Increased height for better separation
                            thickness: 2.0, // Increased thickness for better visibility
                          ),
                          Text(
                            'Monthly Summary',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue, // Primary color
                            ),
                          ),
                          8.verticalSpace, // Spacing between title and content
                          ...controller.getMonthlySummary().entries.map((entry) {
                            return Padding(
                              padding:  EdgeInsets.symmetric(vertical: 4.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    entry.key,
                                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    '\$ ${entry.value.toString()}',
                                    style: theme.textTheme.bodyMedium?.copyWith(color: Colors.green), // Value color
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  )
                  ,
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                     CircleAvatar(
                      radius: 50.r,
                      backgroundImage: const NetworkImage('https://example.com/profile-pic.jpg'), // Replace with actual image URL
                    ),
                    16.verticalSpace,
                    Text(
                      user!.username,
                      style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    16.verticalSpace,
                    Text(
                      'Age: ${user.age}', // Replace with actual age
                      style: theme.textTheme.bodyMedium,
                    ),
                    8.verticalSpace,
                    Text(
                      'Phone: ${user.phoneNumber}', // Replace with actual phone number
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Divider(thickness: 1.5),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Developer Details',
                      style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.blueAccent),
                    ),
                    8.verticalSpace,
                    Text(
                      'Name: Rajarajan', // Replace with developer's name
                      style: theme.textTheme.bodyMedium,
                    ),
                    8.verticalSpace,
                    Text(
                      'Contact: +918428246857', // Replace with developer's contact number
                      style: theme.textTheme.bodyMedium,
                    ),
                    8.verticalSpace,
                    Text(
                      'Email: ap.raja1234@gmail.com', // Replace with developer's email
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
