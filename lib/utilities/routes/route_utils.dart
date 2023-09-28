// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import 'package:instant_pay/view/screen/dashboard/calculator/eligibility_calculator_screen%20copy.dart';
import 'package:instant_pay/view/screen/dashboard/calculator/emi_calculator_screen.dart';
import 'package:instant_pay/view/screen/dashboard/dash/clarification_screen.dart';
import 'package:instant_pay/view/screen/dashboard/dash/dashboard_more_loans_details_screen.dart';
import 'package:instant_pay/view/screen/dashboard/dash/loan_advantage_screen.dart';
import 'package:instant_pay/view/screen/dashboard/dash/loan_apply_screen.dart';
import 'package:instant_pay/view/screen/dashboard/dashboard_screen.dart';
import 'package:instant_pay/view/screen/dashboard/home/case_study_screen.dart';
import 'package:instant_pay/view/screen/dashboard/home/loan_full_description.dart';
import 'package:instant_pay/view/screen/dashboard/home/loan_short_description_screen.dart';
import 'package:instant_pay/view/screen/dashboard/investment/investment_details_screen.dart';
import 'package:instant_pay/view/screen/dashboard/profile/privacy_policies.dart';
import 'package:instant_pay/view/screen/dashboard/profile/terms_condition.dart';
import 'package:instant_pay/view/screen/dashboard/regenerate/regenerate_screen.dart';
import 'package:instant_pay/view/screen/help/help_screen.dart';
import 'package:instant_pay/view/screen/help/question_answer_screen.dart';
import 'package:instant_pay/view/screen/splash/view/splash_screen.dart';

import '../../view/screen/dashboard/home/laon_application_process_screen.dart';

class RouteUtils {
  static const String splashScreen = 'SplashScreen';
  static const String introScreen = 'IntroScreen';
  static const String regenerateScreen = 'RegenerateScreen';
  static const String dashboardScreen = 'DashboardScreen';
  // static const String exploreMoreScreen = 'ExploreMoreScreen';

  static const String homeScreen = 'homeScreen';
  static const String loanShortDescriptionScreen = 'LoanShortDescriptionScreen';
  static const String loanFullDescriptionScreen = 'LoanFullDescriptionScreen';
  static const String takingLoanReasonScreen = 'TakingLoanReasonScreen';
  static const String loanApplicationProcess = 'LoanApplicationProcess';

  static const String investmentScreen = 'investmentScreen';
  static const String investmentDetailsScreen = 'investmentDetailsScreen';

  static const String eMILoanCalculatorScreen = 'EMILoanCalculatorScreen';
  static const String eligibilityLoanCalculatorScreen =
      'EligibilityLoanCalculatorScreen';

  static const String dashScreen = 'dashScreen';
  static const String dashboardMoreLoansScreen = 'InsuranceDetailsScreen';
  static const String loanApplyScreen = 'LoanApplyScreen';
  static const String clarificationScreen = 'ClarificationScreen';
  static const String loanAdvantageScreen = 'LoanAdvantageScreen';

  static const String profileScreen = 'profileScreen';

  static const String helpScreen = 'HelpScreen';
  static const String questionAnswerScreen = 'QuestionAnswerScreen';

  static const String privacyPoliciesLoanScreen = 'PrivacyPoliciesLoanScreen';
  static const String termsAndConditionScreen = 'TermsAndConditionScreen';

  static Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteUtils.splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
        break;

      case RouteUtils.regenerateScreen:
        return MaterialPageRoute(builder: (_) => const RegenerateScreen());
        break;
      case RouteUtils.dashboardScreen:
        return MaterialPageRoute(builder: (_) => DashboardScreen());
        break;
      // case RouteUtils.exploreMoreScreen:
      //   return MaterialPageRoute(builder: (_) => const ExploreMoreScreen());
      //   break;
      case RouteUtils.loanShortDescriptionScreen:
        final arguments = settings.arguments as LoanDescriptionArguments;
        return MaterialPageRoute(
            builder: (_) => LoanShortDescriptionScreen(arguments: arguments));
        break;
      case RouteUtils.loanFullDescriptionScreen:
        final arguments = settings.arguments as LoanDescriptionArguments;
        return MaterialPageRoute(
            builder: (_) => LoanFullDescriptionScreen(arguments: arguments));
        break;
      case RouteUtils.takingLoanReasonScreen:
        final arguments = settings.arguments as LoanDescriptionArguments;
        return MaterialPageRoute(
            builder: (_) => CaseStudyScreen(arguments: arguments));
        break;
      case RouteUtils.loanApplicationProcess:
        return MaterialPageRoute(
            builder: (_) => const LoanApplicationProcessScreen());
        break;
      case RouteUtils.investmentDetailsScreen:
        final arguments = settings.arguments as LoanDescriptionArguments;
        return MaterialPageRoute(
            builder: (_) => InvestmentDetailsScreen(arguments: arguments));
        break;
      case RouteUtils.eMILoanCalculatorScreen:
        return MaterialPageRoute(
            builder: (_) => const EMILoanCalculatorScreen());
        break;
      case RouteUtils.eligibilityLoanCalculatorScreen:
        return MaterialPageRoute(
            builder: (_) => const EligibilityCalculatorScreen());
        break;
      case RouteUtils.dashboardMoreLoansScreen:
        final arguments = settings.arguments as LoanDescriptionArguments;
        return MaterialPageRoute(
            builder: (_) =>
                DashboardMoreLoansDetailsScreen(arguments: arguments));
        break;
      case RouteUtils.loanApplyScreen:
        final arguments = settings.arguments as LoanDescriptionArguments;
        return MaterialPageRoute(
            builder: (_) => LoanApplyScreen(arguments: arguments));
        break;
      case RouteUtils.clarificationScreen:
        return MaterialPageRoute(builder: (_) => const ClarificationScreen());
        break;
      case RouteUtils.loanAdvantageScreen:
        final arguments = settings.arguments as LoanDescriptionArguments;
        return MaterialPageRoute(
            builder: (_) => LoanAdvantageScreen(arguments: arguments));
        break;

      // ----------------------------------------------
      case RouteUtils.helpScreen:
        return MaterialPageRoute(builder: (_) => const HelpScreen());
        break;
      case RouteUtils.questionAnswerScreen:
        final arguments = settings.arguments as QuestionAnswerScreenArguments;
        return MaterialPageRoute(
            builder: (_) => QuestionAnswerScreen(arguments: arguments));
        break;

      case RouteUtils.privacyPoliciesLoanScreen:
        return MaterialPageRoute(builder: (_) => const PrivacyPoliciesScreen());
        break;
      case RouteUtils.termsAndConditionScreen:
        return MaterialPageRoute(
            builder: (_) => const TermsAndConditionScreen());
        break;
      default:
        return null;
        break;
    }
  }
}
