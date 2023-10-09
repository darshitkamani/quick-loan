import 'package:action_broadcast/action_broadcast.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instant_pay/utilities/storage/storage.dart';
import 'package:instant_pay/view/screen/dashboard/home/model/available_ads_response.dart';
import 'package:instant_pay/view/widget/ads_widget/app_open_widget.dart';
import 'package:instant_pay/view/widget/ads_widget/interstitial_ads_widget.dart';
import 'package:instant_pay/view/widget/ads_widget/load_ads_by_api.dart';
import 'package:provider/provider.dart';

class InterstitialAdsForDash {
  static bool isInterstitialAdLoaded = false;
  static bool isInterstitialAdLoading = false;
  static late MyAdsIdClass myAdsIdClassForHomeScreen;
  static Future loadHomeScreenIds({required BuildContext context}) async {
    myAdsIdClassForHomeScreen = await LoadAdsByApi().isAvailableAds(context: context, screenName: 'HomeScreen');
    print("myAdsIdClassForHomeScreen --> ${myAdsIdClassForHomeScreen.availableAdsList}  ${myAdsIdClassForHomeScreen.facebookInterstitialId} ");
  }

  static Future<void> loadFBInterstitialAd({required BuildContext context, required String routeFrom, required String screenName, required String? googleID, required MyAdsIdClass myAdsIdClass, required String? fbID}) async {
    final interstitialAdsWidgetProvider = Provider.of<InterstitialAdsWidgetProvider>(context, listen: false);
    String fbInterstitialAdId = fbID ?? '';
    isInterstitialAdLoading = true;

    print('Screen name --> fbInterstitialAdId $screenName $fbInterstitialAdId');
    // AdsUnitId().getFacebookInterstitialAdId();
    if (fbInterstitialAdId == '') {
      isInterstitialAdLoading = false;

      return;
    }
    print('interstitialAdsWidgetProvider.isInterstitialAdLoaded ---> ${interstitialAdsWidgetProvider.isInterstitialAdLoaded}');
    if (interstitialAdsWidgetProvider.isInterstitialAdLoaded == true) {
      isInterstitialAdLoading = false;
      showFBInterstitialAd(context: context, fbID: fbID, googleID: googleID, myAdsIdClass: myAdsIdClass, screenName: 'DashBoardScreen');
    }

    FacebookInterstitialAd.loadInterstitialAd(
        placementId: kDebugMode ? 'IMG_16_9_APP_INSTALL#$fbInterstitialAdId' : fbInterstitialAdId,
        listener: (result, value) {
          debugPrint('DASHBOARD RESULT fbInterstitialAdId - - - -- - - -- - $result ------- $value');
          if (result == InterstitialAdResult.LOADED) {
            isInterstitialAdLoading = false;

            if (screenName == 'HomeScreen') {
              interstitialAdsWidgetProvider.isInterstitialAdLoaded = true;
              return;
            }
            showFBInterstitialAd();
          }
          if (result == InterstitialAdResult.ERROR) {
            isInterstitialAdLoading = false;
            isInterstitialAdLoaded = false;
            StorageUtils.prefs.setBool(StorageKeyUtils.isShowFacebookAds, false);
            StorageUtils.prefs.setBool(StorageKeyUtils.isShowADXAds, true);
            StorageUtils.prefs.setBool(StorageKeyUtils.isShowAdmobAds, true);
            FacebookInterstitialAd.destroyInterstitialAd();
            bool isFacebookAdsShow = StorageUtils.prefs.getBool(StorageKeyUtils.isShowFacebookAds) ?? false;
            bool isADXAdsShow = StorageUtils.prefs.getBool(StorageKeyUtils.isShowADXAds) ?? false;
            bool isAdmobAdsShow = StorageUtils.prefs.getBool(StorageKeyUtils.isShowAdmobAds) ?? false;
            bool isAdShow = StorageUtils.prefs.getBool(StorageKeyUtils.isAddShowInApp) ?? false;
            if (routeFrom == 'SplashScreen') {
              if (isAdShow) {
                if (isAdmobAdsShow || isADXAdsShow) {
                  print('App Open called from facebook inter failed ${myAdsIdClass.googleAppOpenId}');
                  final appOpenProvider = Provider.of<AppOpenAdWidgetProvider>(context, listen: false);

                  appOpenProvider.loadAd(screenName: screenName, isShowAd: true, googleId: myAdsIdClass.googleAppOpenId);
                }
              }
            }
          }
          if (result == InterstitialAdResult.DISMISSED && value["invalidated"] == true) {
            isInterstitialAdLoading = false;
            isInterstitialAdLoaded = false;
            FacebookInterstitialAd.destroyInterstitialAd();
            debugPrint('1 AD CLOSED DISMISSED - - - -- -');
            print('Screen name $screenName }');
            if (screenName == 'HomeScreen') {
              final interstitialAdsWidgetProvider = Provider.of<InterstitialAdsWidgetProvider>(context, listen: false);

              interstitialAdsWidgetProvider.isInterstitialAdLoaded = false;

              return;
            }
            if (screenName == 'DashboardScreen') {
              if (myAdsIdClassForHomeScreen.availableAdsList.contains('Interstitial')) {
                myAdsIdClass = myAdsIdClassForHomeScreen;
                fbInterstitialAdId = myAdsIdClassForHomeScreen.facebookInterstitialId;
                loadFBInterstitialAdForHomeScreen(context: context, myAdsIdClass: myAdsIdClassForHomeScreen, screenName: 'HomeScreen', fbID: myAdsIdClassForHomeScreen.facebookInterstitialId, googleID: myAdsIdClassForHomeScreen.googleInterstitialId);
              }
            }
          }
        });
  }

  static Future<void> loadFBInterstitialAdForHomeScreen({required BuildContext context, required String screenName, required String? googleID, required MyAdsIdClass myAdsIdClass, required String? fbID}) async {
    String fbInterstitialAdId = fbID ?? '';
    print('Screen name --> fbInterstitialAdId $screenName $fbInterstitialAdId');

    // AdsUnitId().getFacebookInterstitialAdId();
    if (fbInterstitialAdId == '') {
      isInterstitialAdLoading = false;
      isInterstitialAdLoaded = false;
      return;
    }

    isInterstitialAdLoading = true;
    FacebookInterstitialAd.loadInterstitialAd(
        placementId: kDebugMode ? 'IMG_16_9_APP_INSTALL#$fbInterstitialAdId' : fbInterstitialAdId,
        listener: (result, value) {
          debugPrint('Home screen result RESULT fbInterstitialAdId - - - -- - - -- - $result ------- $value');
          if (result == InterstitialAdResult.LOADED) {
            if (screenName == 'HomeScreen') {
              isInterstitialAdLoading = false;
              final interstitialAdsWidgetProvider = Provider.of<InterstitialAdsWidgetProvider>(context, listen: false);
              interstitialAdsWidgetProvider.isInterstitialAdLoaded = true;
              return;
            }
            showFBInterstitialAd();
          }
          if (result == InterstitialAdResult.ERROR) {
            isInterstitialAdLoading = false;
            isInterstitialAdLoaded = false;
            FacebookInterstitialAd.destroyInterstitialAd();

            StorageUtils.prefs.setBool(StorageKeyUtils.isShowFacebookAds, false);
            StorageUtils.prefs.setBool(StorageKeyUtils.isShowADXAds, true);
            StorageUtils.prefs.setBool(StorageKeyUtils.isShowAdmobAds, true);
          }
          if (result == InterstitialAdResult.DISMISSED && value["invalidated"] == true) {
            FacebookInterstitialAd.destroyInterstitialAd();

            isInterstitialAdLoading = false;
            isInterstitialAdLoaded = false;

            debugPrint('1 AD CLOSED DISMISSED - - - -- -');
            print('Screen name $screenName }');
            if (screenName == 'HomeScreen') {
              final interstitialAdsWidgetProvider = Provider.of<InterstitialAdsWidgetProvider>(context, listen: false);

              interstitialAdsWidgetProvider.isInterstitialAdLoaded = false;
              // interstitialAdsWidgetProvider.loadFBInterstitialAd(
              //     fbID: fbID,
              //     googleID: googleID,
              //     context: context,
              //     screenName: screenName);
              sendBroadcast("LoadAd");

              return;
            }
          }
        });
  }

  static showFBInterstitialAd({BuildContext? context, String? screenName, String? googleID, String? fbID, MyAdsIdClass? myAdsIdClass, bool needToReLoadAd = false}) async {
    FacebookInterstitialAd.showInterstitialAd().then((value) async {
      if (needToReLoadAd) {
        loadFBInterstitialAd(routeFrom: '', context: context!, screenName: screenName!, googleID: googleID, myAdsIdClass: myAdsIdClass!, fbID: fbID);
      }
      print("==================>>>> Called Show Interstitial");
    });
  }
}
