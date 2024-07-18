import 'package:expenseflow/app/modules/home/views/widgets/input_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import '../../../../config/theme/my_theme.dart';
import '../../../../config/theme/theme_extensions/employee_list_item_theme_data.dart';
import '../../../../config/theme/theme_extensions/header_container_theme_data.dart';
import '../../../../config/translations/strings_enum.dart';
import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class LoginView extends GetView<HomeController> {
  LoginView({super.key});
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: SafeArea(
        child: GetBuilder<HomeController>(builder: (_) {
          return Stack(
            fit: StackFit.expand,
            children: [
              //----------------white circles decor----------------//
              Positioned(
                right: 0,
                top: 0,
                child: CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.05),
                  radius: 111,
                ),
              ),
              Positioned(
                right: -7.w,
                top: -160.h,
                child: CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.05),
                  radius: 111,
                ),
              ),
              Positioned(
                right: -21.w,
                top: -195.h,
                child: CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.05),
                  radius: 111,
                ),
              ),
              Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 26.w),
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r)),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12.w),
                                child: Center(
                                    child: Image.asset(
                                  'assets/images/login.png',
                                  height: 150.h,
                                  width: 150.w,
                                )),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: theme
                                        .extension<EmployeeListItemThemeData>()
                                        ?.backgroundColor,
                                    borderRadius: BorderRadius.circular(12.r)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: InkWell(
                                            onTap: () => MyTheme.changeTheme(),
                                            child: Ink(
                                              child: Container(
                                                height: 25.h,
                                                width: 25.h,
                                                decoration: theme
                                                    .extension<
                                                        HeaderContainerThemeData>()
                                                    ?.decoration,
                                                child: SvgPicture.asset(
                                                  Get.isDarkMode
                                                      ? 'assets/vectors/moon.svg'
                                                      : 'assets/vectors/sun.svg',
                                                  fit: BoxFit.none,
                                                  color: Colors.white,
                                                  // height: 10,
                                                  // width: 10,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Center(
                                            child: Padding(
                                          padding: EdgeInsets.only(top: 12.h),
                                          child: Center(
                                              child: Text(
                                            Strings.signup.tr,
                                            style:
                                                const TextStyle(fontSize: 24),
                                          )),
                                        )),
                                      ],
                                    ),
                                    12.verticalSpace,
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 22.w),
                                      child: Text(Strings.username.tr),
                                    ),
                                    4.verticalSpace,
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 22.w),
                                      child: InputTextField(
                                        keyBoardType: TextInputType.text,
                                        textAction: TextInputAction.next,
                                        hint: 'Eg: abc@sample.com',
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Enter an email';
                                          }
                                          return null;
                                        },
                                        controller: _emailController,
                                      ),
                                    ),
                                    8.verticalSpace,
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 22.w),
                                      child: Text(Strings.password.tr),
                                    ),
                                    4.verticalSpace,
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 22.w),
                                      child: InputTextField(
                                        keyBoardType: TextInputType.text,
                                        textAction: TextInputAction.next,
                                        hint: 'Password',
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Enter an password';
                                          }
                                          return null;
                                        },
                                        controller: _passwordController,
                                      ),
                                    ),
                                    8.verticalSpace,
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 22.w),
                                      child: Text(Strings.age.tr),
                                    ),
                                    4.verticalSpace,
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 22.w),
                                      child: InputTextField(
                                        keyBoardType: TextInputType.number,
                                        textAction: TextInputAction.next,
                                        format: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp('[0-9]')),
                                          LengthLimitingTextInputFormatter(2)
                                        ],
                                        hint: 'age',
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Enter age';
                                          }
                                          return null;
                                        },
                                        controller: _ageController,
                                      ),
                                    ),
                                    8.verticalSpace,
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 22.w),
                                      child: Text(Strings.phoneNumber.tr),
                                    ),
                                    4.verticalSpace,
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 22.w),
                                      child: InputTextField(
                                        keyBoardType: TextInputType.number,
                                        textAction: TextInputAction.done,
                                        format: [
                                          FilteringTextInputFormatter.allow(
                                            RegExp('[0-9]'),
                                          ),
                                          LengthLimitingTextInputFormatter(10)
                                        ],
                                        hint: 'Eg: 123456789',
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Enter an phone number';
                                          }
                                          return null;
                                        },
                                        controller: _phoneNumberController,
                                      ),
                                    ),
                                    8.verticalSpace,
                                    Center(
                                        child: ElevatedButton(
                                            style: ButtonStyle(
                                                padding: WidgetStatePropertyAll(
                                                    EdgeInsets.symmetric(
                                                        vertical: 10.h,
                                                        horizontal: 20.w))),
                                            onPressed: () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                controller.registerUser(
                                                    _emailController.text.toLowerCase(),
                                                    _passwordController.text,
                                                    int.parse(
                                                        _ageController.text),
                                                    int.parse(
                                                        _phoneNumberController
                                                            .text));
                                                Get.toNamed(Routes.SIGNUP);
                                              }
                                            },
                                            child: Text(
                                              Strings.signup.tr,
                                              style: TextStyle(
                                                  color: theme.textTheme
                                                      .headlineLarge!.color),
                                            ))),
                                    18.verticalSpace,
                                    Center(child: RichText(text: TextSpan(text: 'Already registered? ',style: theme.textTheme.bodyMedium,children: [TextSpan(text: 'Login',style: theme.textTheme.copyWith(bodyMedium: const TextStyle(decorationStyle: TextDecorationStyle.wavy,decorationThickness: 5)).bodyMedium, recognizer:TapGestureRecognizer()..onTap=()=> Get.toNamed(Routes.SIGNUP) ),]),)),
                                    18.verticalSpace,
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}
