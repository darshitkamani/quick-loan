import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AppOpenAdWidgetProvider extends ChangeNotifier {
  AppOpenAd? _appOpenAd;

  void loadAd(
      {required String screenName,
      required String googleId,
      bool isShowAd = false}) {
    String appOpenAddId = googleId;
    if (kDebugMode) {
      print(
          "appOpenAddId app open load function called screen name $screenName--> $appOpenAddId");
    }
    // AdsUnitId().getGoogleAppOpenAdId();
    if (appOpenAddId != '') {
      AppOpenAd.load(
        adUnitId: appOpenAddId,
        orientation: AppOpenAd.orientationPortrait,
        request: const AdRequest(),
        adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: (ad) {
            _appOpenAd = ad;
            notifyListeners();
            // debugPrint('App Open Ad loaded....................');
            if (isShowAd) {
              showAdIfAvailable();
            }
          },
          onAdFailedToLoad: (error) {
            // log('AppOpenAd failed to load: $error');
            // Handle the error.
          },
        ),
      );
    }
  }

  void showAdIfAvailable() {
    if (kDebugMode) {
      print(
          "appOpenAddId app open show function called --> ${_appOpenAd == null}");
    }
    // debugPrint((_appOpenAd == null).toString());
    if (_appOpenAd == null) {
      return;
    }
    // Set the fullScreenContentCallback and show the ad.
    _appOpenAd!.show();
    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        // print('$ad onAdShowedFullScreenContent');
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        // print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _appOpenAd = null;
      },
      onAdDismissedFullScreenContent: (ad) {
        // print('$ad onAdDismissedFullScreenContent');
        // ad.dispose();
        // _appOpenAd = null;
        // loadAd();
      },
    );
  }
}
