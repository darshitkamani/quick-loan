// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quick_loan/l10n/locale_keys.g.dart';
import 'package:quick_loan/utilities/colors/color_utils.dart';
import 'package:quick_loan/utilities/font/font_utils.dart';
import 'package:quick_loan/utilities/storage/storage.dart';
import 'package:quick_loan/view/screen/dashboard/calculator/calculator_screen.dart';
import 'package:quick_loan/view/screen/dashboard/dash/dash_screen.dart';
import 'package:quick_loan/view/screen/dashboard/home/home_screen.dart';
import 'package:quick_loan/view/screen/dashboard/home/model/available_ads_response.dart';
import 'package:quick_loan/view/screen/dashboard/profile/profile_screen.dart';
import 'package:quick_loan/view/widget/ads_widget/app_open_widget.dart';
import 'package:quick_loan/view/widget/ads_widget/interstitial_ads_widget.dart';
import 'package:quick_loan/view/widget/ads_widget/interstitial_dash_ads.dart';
import 'package:quick_loan/view/widget/ads_widget/load_ads_by_api.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  final String routeName;
  const DashboardScreen({super.key, this.routeName = ''});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with WidgetsBindingObserver {
  int selectedIndex = 0;
  String screenName = "DashboardScreen";
  bool isFacebookAdsShow =
      StorageUtils.prefs.getBool(StorageKeyUtils.isShowFacebookAds) ?? false;
  bool isADXAdsShow =
      StorageUtils.prefs.getBool(StorageKeyUtils.isShowADXAds) ?? false;
  bool isAdmobAdsShow =
      StorageUtils.prefs.getBool(StorageKeyUtils.isShowAdmobAds) ?? false;
  bool isAdShow =
      StorageUtils.prefs.getBool(StorageKeyUtils.isAddShowInApp) ?? false;
  bool isCheckScreen =
      StorageUtils.prefs.getBool(StorageKeyUtils.isCheckScreenForAdInApp) ??
          false;

  // List<String> availableAdsList = [];
  MyAdsIdClass myAdsIdClass = MyAdsIdClass();
  MyAdsIdClass myAdsIdClassForHomeScreen = MyAdsIdClass();
  MyAdsIdClass myAdsIdClassForHomeTab = MyAdsIdClass();
  MyAdsIdClass myAdsIdClassForCalTab = MyAdsIdClass();
  MyAdsIdClass myAdsIdClassForLoanTab = MyAdsIdClass();
  MyAdsIdClass myAdsIdClassForProfileTab = MyAdsIdClass();
  MyAdsIdClass didChangeAppScreen = MyAdsIdClass();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (!kDebugMode) {
        await FirebaseAnalytics.instance.logEvent(name: screenName);
      }
      WidgetsBinding.instance.addObserver(this);

      // final provider = Provider.of<InterstitialAdsWidgetProvider>(context, listen: false);
      final appOpenProvider =
          Provider.of<AppOpenAdWidgetProvider>(context, listen: false);

      myAdsIdClass = await LoadAdsByApi()
          .isAvailableAds(context: context, screenName: screenName);
      myAdsIdClassForHomeScreen = await LoadAdsByApi()
          .isAvailableAds(context: context, screenName: 'HomeScreen');
      myAdsIdClassForHomeTab = await LoadAdsByApi()
          .isAvailableAds(context: context, screenName: 'HomeBot');
      myAdsIdClassForProfileTab = await LoadAdsByApi()
          .isAvailableAds(context: context, screenName: 'ProfileBot');
      myAdsIdClassForLoanTab = await LoadAdsByApi()
          .isAvailableAds(context: context, screenName: 'LoanBot');
      myAdsIdClassForCalTab = await LoadAdsByApi()
          .isAvailableAds(context: context, screenName: 'CalculatorBot');
      didChangeAppScreen = await LoadAdsByApi()
          .isAvailableAds(context: context, screenName: 'DidChangeApp');
      setState(() {});

      if (isAdShow) {
        if (isCheckScreen) {
          print(
              ' if from isCheckScreen $isCheckScreen --> screenName --> $screenName');
          print(
              'if from  myAdsIdClass.isGoogle screenName --> $screenName --> ${myAdsIdClass.isGoogle}');
          if (myAdsIdClass.isGoogle) {
            appOpenProvider.loadAd(
                screenName: screenName,
                isShowAd: true,
                googleId: myAdsIdClass.googleAppOpenId);
            return;
          }
          print(
              ' if from  myAdsIdClass.isFacebook screenName --> $screenName --> ${myAdsIdClass.isFacebook}');

          if (myAdsIdClass.isFacebook) {
            if (widget.routeName != 'Clarification') {
              InterstitialAdsForDash.loadHomeScreenIds(context: context);
              InterstitialAdsForDash.loadFBInterstitialAd(
                  routeFrom: widget.routeName,
                  context: context,
                  screenName: screenName,
                  googleID: myAdsIdClass.googleInterstitialId,
                  myAdsIdClass: myAdsIdClass,
                  fbID: myAdsIdClass.facebookInterstitialId);
            }
          }
        } else {
          print(
              'else from myAdsIdClass.isGoogle screenName --> $screenName --> myAdsIdClass.isGoogle ${myAdsIdClass.isGoogle} myAdsIdClass.isFacebook --> ${myAdsIdClass.isGoogle}  isAdmob $isADXAdsShow isFacebook $isFacebookAdsShow');

          if (myAdsIdClass.availableAdsList.contains('AppOpen')) {
            if (widget.routeName == 'SplashScreen') {
              if (myAdsIdClass.isGoogle) {
                appOpenProvider.loadAd(
                    screenName: screenName,
                    isShowAd: true,
                    googleId: myAdsIdClass.googleAppOpenId);
                return;
              }
            }
            if (myAdsIdClass.isFacebook && isFacebookAdsShow) {
              print("widget.routeName --> ${widget.routeName}");
              if (widget.routeName != 'Clarification') {
                InterstitialAdsForDash.loadHomeScreenIds(context: context);
                InterstitialAdsForDash.loadFBInterstitialAd(
                    routeFrom: widget.routeName,
                    context: context,
                    screenName: screenName,
                    googleID: myAdsIdClass.googleInterstitialId,
                    myAdsIdClass: myAdsIdClass,
                    fbID: myAdsIdClass.facebookInterstitialId);
              }
            }
          }
        }
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  bool isNeedToCheckAddLoad = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    isFacebookAdsShow =
        StorageUtils.prefs.getBool(StorageKeyUtils.isShowFacebookAds) ?? false;
    isADXAdsShow =
        StorageUtils.prefs.getBool(StorageKeyUtils.isShowADXAds) ?? false;
    isAdmobAdsShow =
        StorageUtils.prefs.getBool(StorageKeyUtils.isShowAdmobAds) ?? false;
    isAdShow =
        StorageUtils.prefs.getBool(StorageKeyUtils.isAddShowInApp) ?? false;
    debugPrint(
        'STATE ----->>>>>> ${state.name} isCheckScreen $isCheckScreen isNeedToCheckAddLoad $isNeedToCheckAddLoad. . . . . . . . . . . .');
    if (state == AppLifecycleState.resumed) {
      if (isAdShow) {
        print(
            "STATE ----->>>>>> isFacebookAdsShow --> $isFacebookAdsShow isAdmobAdsShow || isADXAdsShow --> $isAdmobAdsShow didChangeAppScreen.isGoogle --> ${didChangeAppScreen.isGoogle} didChangeAppScreen.isFacebook --> ${didChangeAppScreen.isFacebook}");
        if (isNeedToCheckAddLoad) {
          if (isCheckScreen) {
            if (didChangeAppScreen.isFacebook) {
              final provider = Provider.of<InterstitialAdsWidgetProvider>(
                  context,
                  listen: false);
              provider.loadFBInterstitialAd(
                  myAdsIdClass: myAdsIdClass,
                  screenName: screenName,
                  context: context,
                  fbID: myAdsIdClass.facebookInterstitialId,
                  googleID: myAdsIdClass.googleInterstitialId);
              // loadFBInterstitialAd(
              //     screenName: '',
              //     fbID: myAdsIdClass.facebookInterstitialId,
              //     googleID: myAdsIdClass.googleInterstitialId);
            }
            if (didChangeAppScreen.isGoogle) {
              final appOpenProvider =
                  Provider.of<AppOpenAdWidgetProvider>(context, listen: false);
              appOpenProvider.loadAd(
                  screenName: screenName,
                  isShowAd: true,
                  googleId: didChangeAppScreen.googleAppOpenId);
              isNeedToCheckAddLoad = false;
            }
          } else {
            if (didChangeAppScreen.availableAdsList.contains('AppOpen')) {
              if ((didChangeAppScreen.isGoogle)) {
                final appOpenProvider = Provider.of<AppOpenAdWidgetProvider>(
                    context,
                    listen: false);
                appOpenProvider.loadAd(
                    screenName: screenName,
                    isShowAd: true,
                    googleId: didChangeAppScreen.googleAppOpenId);
                isNeedToCheckAddLoad = false;
                return;
              }
              if (didChangeAppScreen.isFacebook && isFacebookAdsShow) {
                final provider = Provider.of<InterstitialAdsWidgetProvider>(
                    context,
                    listen: false);
                provider.loadFBInterstitialAd(
                    myAdsIdClass: didChangeAppScreen,
                    screenName: screenName,
                    context: context,
                    fbID: myAdsIdClass.facebookInterstitialId,
                    googleID: myAdsIdClass.googleInterstitialId);
                // loadFBInterstitialAd(
                //     screenName: '',
                //     fbID: myAdsIdClass.facebookInterstitialId,
                //     googleID: myAdsIdClass.googleInterstitialId);
              }
            }
          }
        }
      }
    }
    if (state == AppLifecycleState.inactive) {
      isNeedToCheckAddLoad = false;
    }
    if (state == AppLifecycleState.paused) {
      isNeedToCheckAddLoad = true;
    }
  }

  DateTime? backButtonPressedTime;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        DateTime currentTime = DateTime.now();
        bool backButton = backButtonPressedTime == null ||
            currentTime.difference(backButtonPressedTime!) >
                const Duration(seconds: 1);
        if (backButton) {
          backButtonPressedTime = currentTime;
          Fluttertoast.showToast(
              msg: "Swipe again to exit",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM);
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: ColorUtils().greyBGColor,
        body: getScreen(),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: const Icon(Icons.home_sharp),
                label: LocaleKeys.HOME.tr()),
            BottomNavigationBarItem(
                icon: const Icon(Icons.calculate_rounded),
                label: LocaleKeys.Calculator.tr()),
            BottomNavigationBarItem(
                icon: const Icon(Icons.dashboard),
                label: LocaleKeys.MoreLoans.tr()),
            // BottomNavigationBarItem(icon: Icon(Icons.arrow_outward_rounded), label: 'Invest'),
            BottomNavigationBarItem(
                icon: const Icon(Icons.person), label: LocaleKeys.Profile.tr()),
          ],
          currentIndex: selectedIndex,
          selectedItemColor: ColorUtils.themeColor.oxff673AB7,
          unselectedItemColor:
              ColorUtils.themeColor.oxff000000.withOpacity(0.6),
          unselectedLabelStyle: FontUtils.h12(
              fontColor: ColorUtils.themeColor.oxff000000.withOpacity(0.6),
              fontWeight: FWT.semiBold),
          selectedLabelStyle: FontUtils.h14(
              fontColor: ColorUtils.themeColor.oxff673AB7,
              fontWeight: FWT.bold),
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          onTap: (int value) {
            if (value == selectedIndex) {
              return;
            }
            setState(() {
              selectedIndex = value;
            });
            final provider = Provider.of<InterstitialAdsWidgetProvider>(context,
                listen: false);

            switch (value) {
              case 0:
                provider.showFbOrAdxOrAdmobInterstitialAd(
                  myAdsIdClass: myAdsIdClassForHomeTab,
                  'POPDash',
                  context,
                  availableAds: myAdsIdClassForHomeTab.availableAdsList,
                  fbInterID: myAdsIdClassForHomeTab.facebookInterstitialId,
                  googleInterID: myAdsIdClassForHomeTab.googleInterstitialId,
                );

                break;
              case 1:
                provider.showFbOrAdxOrAdmobInterstitialAd(
                  myAdsIdClass: myAdsIdClassForCalTab,
                  'POPDash',
                  context,
                  availableAds: myAdsIdClassForCalTab.availableAdsList,
                  fbInterID: myAdsIdClassForCalTab.facebookInterstitialId,
                  googleInterID: myAdsIdClassForCalTab.googleInterstitialId,
                );
                break;
              case 2:
                provider.showFbOrAdxOrAdmobInterstitialAd(
                  myAdsIdClass: myAdsIdClassForLoanTab,
                  'POPDash',
                  context,
                  availableAds: myAdsIdClassForLoanTab.availableAdsList,
                  fbInterID: myAdsIdClassForLoanTab.facebookInterstitialId,
                  googleInterID: myAdsIdClassForLoanTab.googleInterstitialId,
                );
                break;
              case 3:
                provider.showFbOrAdxOrAdmobInterstitialAd(
                  myAdsIdClass: myAdsIdClassForProfileTab,
                  'POPDash',
                  context,
                  availableAds: myAdsIdClassForProfileTab.availableAdsList,
                  fbInterID: myAdsIdClassForProfileTab.facebookInterstitialId,
                  googleInterID: myAdsIdClassForProfileTab.googleInterstitialId,
                );
                break;
              default:
            }
          },
          elevation: 10,
        ),
      ),
    );
  }

  getScreen() {
    switch (selectedIndex) {
      case 0:
        return const HomeScreen();
      case 1:
        return const CalculatorScreen();
      case 2:
        return const DashScreen();
      // case 3:
      //   return const InvestmentScreen();
      case 3:
        return const ProfileScreen();
      default:
    }
  }
}
