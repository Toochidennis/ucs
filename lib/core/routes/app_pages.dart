import 'package:get/get.dart';
import 'package:ucs/features/admin/bindings/add_officer_binding.dart';
import 'package:ucs/features/admin/bindings/add_student_binding.dart';
import 'package:ucs/features/admin/views/add_officer_view.dart';
import 'package:ucs/features/admin/views/add_student_view.dart';
import 'package:ucs/features/admin/views/admin_dashboard_view.dart';
import 'package:ucs/features/admin/bindings/admin_dashboard_binding.dart';
import 'package:ucs/features/auth/bindings/auth_binding.dart';
import 'package:ucs/features/auth/controllers/splash_controller.dart';
import 'package:ucs/features/auth/views/login_view.dart';
import 'package:ucs/features/auth/views/splash_view.dart';
import 'package:ucs/features/officer/bindings/officer_binding.dart';
import 'package:ucs/features/officer/views/officer_dashboard_view.dart';
import 'package:ucs/features/student/bindings/clearance_details_binding.dart';
import 'package:ucs/features/student/bindings/student_dashboard_binding.dart';
import 'package:ucs/features/student/views/clearance_details_view.dart';
import 'package:ucs/features/student/views/student_dashboard_view.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = <GetPage>[
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: BindingsBuilder(() {
        Get.put(SplashController());
      }),
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
      binding: AdminDashboardBinding(),
    ),
    GetPage(
      name: AppRoutes.addOfficer,
      page: () => const AddOfficerView(),
      binding: AddOfficerBinding(),
    ),
    GetPage(
      name: AppRoutes.addStudent,
      page: () => const AddStudentView(),
      binding: AddStudentBinding(),
    ),
    GetPage(
      name: AppRoutes.officerDashboard,
      page: () => const OfficerDashboardView(),
      binding: OfficerBinding(),
    ),
    GetPage(
      name: AppRoutes.clearanceDetails,
      page: () => const ClearanceDetailsView(),
      binding: ClearanceDetailsBinding(),
    ),
  ];
}
