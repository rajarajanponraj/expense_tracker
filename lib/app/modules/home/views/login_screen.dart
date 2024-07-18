import 'package:expenseflow/app/modules/home/views/widgets/input_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import '../../../../config/theme/my_theme.dart';
import '../../../../config/theme/theme_extensions/employee_list_item_theme_data.dart';
import '../../../../config/theme/theme_extensions/header_container_theme_data.dart';
import '../../../../config/translations/strings_enum.dart';
import '../controllers/home_controller.dart';

class SignUpView extends GetView<HomeController> {
  SignUpView({super.key});
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
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
                                    color: theme.extension<EmployeeListItemThemeData>()?.backgroundColor,
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
                                                    .extension<HeaderContainerThemeData>()
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
                                        Center(child: Padding(
                                          padding:  EdgeInsets.only(top: 12.h),
                                          child: Text(Strings.login.tr,style: const TextStyle(fontSize: 22),),
                                        )),
                                      ],
                                    ),
                                    12.verticalSpace,
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 22.w),
                                      child: Text(Strings.username.tr),
                                    ),
                                    2.verticalSpace,
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 22.w),
                                      child: InputTextField(
                                        hint: 'Eg:abc@sample.com',
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
                                    2.verticalSpace,
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 22.w),
                                      child: InputTextField(
                                        hint: 'password',
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
                                    Center(
                                        child: ElevatedButton(
                                          style: ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 10.h,horizontal: 20.w))),
                                            onPressed: () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                controller.loginUser(
                                                    _emailController.text.toLowerCase(),
                                                    _passwordController.text,
                                                   );
                                              }
                                            },
                                            child: Text(Strings.login.tr,style: TextStyle(color: theme.textTheme.headlineLarge!.color),))),
                                    18.verticalSpace,
                                    Center(child: RichText(text: TextSpan(text: 'Need to register? ',style: theme.textTheme.bodyMedium,children: [TextSpan(text: 'Signup', recognizer:TapGestureRecognizer()..onTap=()=> Get.back() ),]),)),
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
