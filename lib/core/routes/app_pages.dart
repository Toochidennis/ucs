import 'package:get/get.dart';
import 'package:ucs/features/admin/views/add_officer_view.dart';
import 'package:ucs/features/admin/views/add_student_view.dart';
import 'package:ucs/features/admin/views/admin_dashboard_view.dart';
import 'package:ucs/features/admin/bindings/admin_binding.dart';
import 'package:ucs/features/auth/bindings/auth_binding.dart';
import 'package:ucs/features/auth/views/login_view.dart';
import 'package:ucs/features/auth/views/splash_view.dart';
import 'package:ucs/features/student/bindings/student_binding.dart';
import 'package:ucs/features/student/views/student_dashboard_view.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = <GetPage>[
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.studentDashboard,
      page: () => const StudentDashboardView(),
      binding: StudentBinding(),
    ),
    GetPage(
      name: AppRoutes.adminDashboard,
      page: () => const AdminDashboardView(),
      binding: AdminBinding(),
    ),
    GetPage(
      name: AppRoutes.addOfficer,
      page: () => const AddOfficerView(),
      binding: AdminBinding(),
    ),
    GetPage(
      name: AppRoutes.addStudent,
      page: () => const AddStudentView(),
      binding: AdminBinding(),
    ),
    // GetPage(name: AppRoutes.officerDashboard, page: () => const OfficerDashboardView(), binding: OfficerBinding()),
  ];
}
