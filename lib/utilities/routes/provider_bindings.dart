import 'package:quick_loan/view/screen/splash/provider/splash_provider.dart';
import 'package:quick_loan/view/widget/ads_widget/app_open_widget.dart';
import 'package:quick_loan/view/widget/ads_widget/interstitial_ads_widget.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class ProviderBindings {
  static List<SingleChildWidget> providers = [
    ChangeNotifierProvider<SplashProvider>(create: (_) => SplashProvider()),
    ChangeNotifierProvider<AppOpenAdWidgetProvider>(
        create: (_) => AppOpenAdWidgetProvider()),
    ChangeNotifierProvider<InterstitialAdsWidgetProvider>(
        create: (_) => InterstitialAdsWidgetProvider()),
  ];
}
