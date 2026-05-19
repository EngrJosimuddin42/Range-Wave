import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:range_wave/core/navigation/app_routes.dart';
import 'package:range_wave/presentation/auth/forgot_pass/enter_email_screen.dart';
import 'package:range_wave/presentation/auth/forgot_pass/reset_password_screen.dart';
import 'package:range_wave/presentation/map/map_screen.dart';
import 'package:range_wave/presentation/mechanic/history/mechanic_history_details.dart';
import 'package:range_wave/presentation/mechanic/mechanic_bottom_nav.dart';
import 'package:range_wave/presentation/mechanic/notification/notification_screen.dart';
import 'package:range_wave/presentation/mechanic/profile/payment_history.dart';
import 'package:range_wave/presentation/chat/chat_detail_screen.dart';
import 'package:range_wave/presentation/chat/chat_list_screen.dart';
import 'package:range_wave/presentation/user/history/user_history_screen.dart';
import 'package:range_wave/presentation/user/home/ai_detected_issue_screen.dart';
import 'package:range_wave/presentation/user/payment/make_paymnet_screen.dart';
import 'package:range_wave/presentation/user/home/mechanic_portfolio_screen.dart';
import 'package:range_wave/presentation/user/home/rate_mechanic_screen.dart';
import 'package:range_wave/presentation/user/home/recommmended_matches_screen.dart';
import 'package:range_wave/presentation/user/home/scheduled_service_screen.dart';
import 'package:range_wave/presentation/user/home/user_home_screen.dart';
import 'package:range_wave/presentation/user/payment/payment_successful_screen.dart';
import 'package:range_wave/presentation/user/profile/car_list_screen.dart';
import 'package:range_wave/presentation/user/profile/credit_card_screen.dart';
import 'package:range_wave/presentation/user/profile/set_time_screen.dart';
import 'package:range_wave/presentation/user/profile/user_change_password_screen.dart';
import 'package:range_wave/presentation/user/profile/user_edit_profile.dart';
import 'package:range_wave/presentation/user/profile/user_payment_screen.dart';
import 'package:range_wave/presentation/user/profile/user_privacy_screen.dart';
import 'package:range_wave/presentation/user/profile/user_profile_screen.dart';
import 'package:range_wave/presentation/user/user_bottom_nav_bar.dart';
import '../../presentation/auth/forgot_pass/verify_otp_screen.dart';
import '../../presentation/auth/select_user_screen.dart';
import '../../presentation/auth/signin/sign_in_screen.dart';
import '../../presentation/auth/signup/add_car_screen.dart';
import '../../presentation/auth/signup/enable_location_screen.dart';
import '../../presentation/auth/signup/signup_screen.dart';
import '../../presentation/mechanic/home/mechanic_home_screen.dart';
import '../../presentation/mechanic/profile/mechanic_change_password_screen.dart';
import '../../presentation/mechanic/profile/mechanic_credit_card_screen.dart';
import '../../presentation/mechanic/profile/mechanic_edit_profile.dart';
import '../../presentation/mechanic/profile/mechanic_payment_screen.dart';
import '../../presentation/mechanic/profile/mechanic_profile_screen.dart';
import '../../presentation/user/home/see_all_service_history_screen.dart';
import '../../presentation/user/home/service_in_progress.dart';
import 'package:get/get.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.selectUser, page: () => SelectUserScreen()),
    GetPage(name: AppRoutes.signIn, page: () => SignInScreen()),
    GetPage(name: AppRoutes.signUp, page: () => SignupScreen()),
    GetPage(name: AppRoutes.enterEmail, page: () => EnterEmailScreen()),
    GetPage(name: AppRoutes.verifyOtp, page: () => VerifyOtpScreen()),
    GetPage(name: AppRoutes.resetPass, page: () => ResetPasswordScreen()),
    GetPage(name: AppRoutes.userHome, page: () => UserHomeScreen()),
    GetPage(name: AppRoutes.enableLocation, page: () => EnableLocationScreen()),
    GetPage(name: AppRoutes.addCar, page: () => AddCarScreen()),
    GetPage(
      name: AppRoutes.seeAllServiceHistory,
      page: () => SeeAllServiceHistoryScreen(),
    ),
    GetPage(name: AppRoutes.userProfile, page: () => UserProfileScreen()),
    GetPage(name: AppRoutes.userEditProfile, page: () => UserEditProfile()),
    GetPage(name: AppRoutes.userPayment, page: () => UserPaymentScreen()),
    GetPage(name: AppRoutes.creditCard, page: () => CreditCardScreen()),
    GetPage(name: AppRoutes.carList, page: () => CarListScreen()),
    GetPage(name: AppRoutes.userBottomNav, page: () => UserBottomNavBar()),
    GetPage(
      name: AppRoutes.userChangePassword,
      page: () => UserChangePasswordScreen(),
    ),
    GetPage(name: AppRoutes.userPrivacy, page: () => UserPrivacyScreen()),
    GetPage(name: AppRoutes.userHistory, page: () => UserHistoryScreen()),
    GetPage(
      name: AppRoutes.userScheduleService,
      page: () => ScheduledServiceScreen(),
    ),
    GetPage(
      name: AppRoutes.aiDetectedIssues,
      page: () => AiDetectedIssueScreen(),
    ),
    GetPage(
      name: AppRoutes.recommendedMatches,
      page: () => RecommendedMatchesScreen(),
    ),
    GetPage(
      name: AppRoutes.mechanicPortfolio,
      page: () => MechanicPortfolioScreen(),
    ),
    GetPage(name: AppRoutes.serviceInProgress, page: () => ServiceInProgress()),
    GetPage(name: AppRoutes.makePayment, page: () => MakePaymentScreen()),
    GetPage(name: AppRoutes.rateMechanic, page: () => RateMechanicScreen()),
    GetPage(
      name: AppRoutes.paymentSuccessful,
      page: () => PaymentSuccessfulScreen(),
    ),

    /// ---------------------------------- Mechanic ------------------------------------ ///
    GetPage(name: AppRoutes.mechanicBottomNav, page: () => MechanicBottomNav()),
    GetPage(
      name: AppRoutes.mechanicProfile,
      page: () => MechanicProfileScreen(),
    ),
    GetPage(
      name: AppRoutes.mechanicEditProfile,
      page: () => MechanicEditProfile(),
    ),
    GetPage(
      name: AppRoutes.mechanicPayment,
      page: () => MechanicPaymentScreen(),
    ),
    GetPage(
      name: AppRoutes.mechanicCreditCard,
      page: () => MechanicCreditCardScreen(),
    ),
    GetPage(
      name: AppRoutes.mechanicChangePassword,
      page: () => MechanicChangePasswordScreen(),
    ),
    GetPage(
      name: AppRoutes.mechanicHistoryDetails,
      page: () => MechanicHistoryDetails(),
    ),
    GetPage(name: AppRoutes.setTime, page: () => SetTimeScreen()),
    GetPage(name: AppRoutes.mechanicHome, page: () => MechanicHomeScreen()),
    GetPage(
      name: AppRoutes.mechanicPaymentHistory,
      page: () => PaymentHistory(),
    ),
    GetPage(name: AppRoutes.mapScreen, page: () => MapScreen()),
    GetPage(name: AppRoutes.notification, page: () => NotificationScreen()),

    /// ------------------------------ chat ---------------------------------------- ///
    GetPage(name: AppRoutes.chatListScreen, page: () => ChatListScreen()),
    GetPage(name: AppRoutes.chatDetailScreen, page: () => ChatDetailScreen()),
  ];
}
