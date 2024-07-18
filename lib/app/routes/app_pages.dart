import 'package:expenseflow/app/modules/home/views/login_screen.dart';
import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/home/views/signup_screen.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;
  static const NEWLOGIN = Routes.NEWLOGIN;
  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
        name: _Paths.LOGIN,
        page: () =>  LoginView(),
        binding: HomeBinding()),
    GetPage(name: _Paths.SIGNUP, page: ()=> SignUpView())
  ];
}
