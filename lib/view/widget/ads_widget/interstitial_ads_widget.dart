import 'package:action_broadcast/action_broadcast.dart';
import 'package:facebook_audience_network/ad/ad_interstitial.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:instant_pay/utilities/routes/route_utils.dart';
import 'package:instant_pay/utilities/storage/storage.dart';
import 'package:instant_pay/view/screen/dashboard/home/model/available_ads_response.dart';
import 'package:instant_pay/view/widget/ads_widget/interstitial_dash_ads.dart';

enum AdsType {
  admob,
  adx,
  facebook,
}

class InterstitialAdsWidgetProvider extends ChangeNotifier {
  showFbOrAdxOrAdmobInterstitialAd(String routeName, BuildContext context, {required List<String> availableAds, required String? googleInterID, required String? fbInterID, required MyAdsIdClass myAdsIdClass, String? loanType = '', bool isFreeAds = false, var arguments}) async {
    bool isFacebookAdsShow = StorageUtils.prefs.getBool(StorageKeyUtils.isShowFacebookAds) ?? false;
    bool isADXAdsShow = StorageUtils.prefs.getBool(StorageKeyUtils.isShowADXAds) ?? false;
    bool isAdmobAdsShow = StorageUtils.prefs.getBool(StorageKeyUtils.isShowAdmobAds) ?? false;
    bool isShowAds = StorageUtils.prefs.getBool(StorageKeyUtils.isAddShowInApp) ?? false;

    bool isCheckScreenForAdInApp = StorageUtils.prefs.getBool(StorageKeyUtils.isCheckScreenForAdInApp) ?? false;
    print('availableAds screenName --> $routeName ---> myAdsIdClass.isGoogle-->${myAdsIdClass.isGoogle} myAdsIdClass.isFacebook ${myAdsIdClass.isFacebook} isCheckScreenForAdInApp $isCheckScreenForAdInApp $availableAds  isShowAds--> $isShowAds  availableAds.contains("Interstitial") -->${!availableAds.contains("Interstitial")} isAdxAdsShow --> $isADXAdsShow isFacebookAdsShow --> $isFacebookAdsShow');
    if (isCheckScreenForAdInApp) {
      if (isInterstitialAdLoaded || (myAdsIdClass.isFacebook && isFacebookAdsShow)) {
        showFBInterstitialAd(routeName, context, arguments: arguments, isFreeAds: isFreeAds, loanType: loanType, googleInterID: googleInterID, fbInterID: fbInterID, myAdsIdClass: myAdsIdClass);
        return;
      } else if (_firstAdxInterstitialAd != null || (myAdsIdClass.isGoogle && isADXAdsShow)) {
        showAdxInterstitialAd(routeName, context, arguments: arguments, myAdsIdClass: myAdsIdClass, isFreeAds: isFreeAds, loanType: loanType, googleInterID: googleInterID, fbInterID: fbInterID);
        return;
      } else {
        getRoute(routeName, loanType ?? '', context, arguments, googleID: googleInterID, fbID: fbInterID, myAdsIdClass: myAdsIdClass);
        return;
      }
    }

    if (isShowAds == false) {
      getRoute(routeName, loanType ?? '', context, arguments, googleID: googleInterID, fbID: fbInterID, myAdsIdClass: myAdsIdClass);
      return;
    }
    if (!availableAds.contains("Interstitial")) {
      getRoute(routeName, loanType ?? '', context, arguments, googleID: googleInterID, fbID: fbInterID, myAdsIdClass: myAdsIdClass);
      return;
    }
    if (isInterstitialAdLoaded || (myAdsIdClass.isFacebook && isFacebookAdsShow)) {
      showFBInterstitialAd(routeName, context, arguments: arguments, isFreeAds: isFreeAds, loanType: loanType, googleInterID: googleInterID, fbInterID: fbInterID, myAdsIdClass: myAdsIdClass);
      return;
    } else if (_firstAdxInterstitialAd != null || (myAdsIdClass.isGoogle && isADXAdsShow)) {
      showAdxInterstitialAd(routeName, context, arguments: arguments, myAdsIdClass: myAdsIdClass, isFreeAds: isFreeAds, loanType: loanType, googleInterID: googleInterID, fbInterID: fbInterID);
      return;
    } else {
      getRoute(routeName, loanType ?? '', context, arguments, googleID: googleInterID, fbID: fbInterID, myAdsIdClass: myAdsIdClass);
      return;
    }
  }

  InterstitialAd? _firstAdxInterstitialAd;
  bool isFirstAdmobOrAdxInterstitialAdLoaded = false;

  void loadAdxInterstitialAd({required String? googleInterID, required String? fbInterID, required String screenName, required MyAdsIdClass myAdsIdClass, BuildContext? context}) {
    String interstitialAdId = kDebugMode ? 'ca-app-pub-3940256099942544/1033173712' : googleInterID ?? '';
    // AdsUnitId().getGoogleInterstitialAdId();
    print("Load function called while  interstitialAdIdn $interstitialAdId $screenName");

    if (interstitialAdId != '') {
      if (isFirstAdmobOrAdxInterstitialAdLoaded == true) {
        return;
      }
      print("Load function called while $screenName");
      InterstitialAd.load(
        adUnitId: interstitialAdId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            isFirstAdmobOrAdxInterstitialAdLoaded = true;
            _firstAdxInterstitialAd = ad;
            notifyListeners();
            if (screenName == 'Dashboard') {
              showAdxInterstitialAd('POP', context!, googleInterID: googleInterID, fbInterID: fbInterID, myAdsIdClass: myAdsIdClass);
            }
          },
          onAdFailedToLoad: (LoadAdError error) {
            isFirstAdmobOrAdxInterstitialAdLoaded = false;
            // loadInterstitialAd();
          },
        ),
      );
    }
  }

  showAdxInterstitialAd(String routeName, BuildContext context, {String? loanType = '', bool isFreeAds = false, var arguments, required MyAdsIdClass myAdsIdClass, required String? googleInterID, required String? fbInterID}) async {
    bool isShowAds = StorageUtils.prefs.getBool(StorageKeyUtils.isAddShowInApp) ?? false;

    if (isShowAds == false) {
      getRoute(routeName, loanType ?? '', context, arguments, isFrom: AdsType.admob, googleID: googleInterID, fbID: fbInterID, myAdsIdClass: myAdsIdClass);
      return;
    }
    if (isFreeAds == true) {
      getRoute(routeName, loanType ?? '', context, arguments, isFrom: AdsType.admob, googleID: googleInterID, fbID: fbInterID, myAdsIdClass: myAdsIdClass);
      return;
    }

    if (_firstAdxInterstitialAd == null) {
      getRoute(routeName, loanType ?? '', context, arguments, isFrom: AdsType.admob, googleID: googleInterID, fbID: fbInterID, myAdsIdClass: myAdsIdClass);
      return;
    }

    _firstAdxInterstitialAd!.show().then((value) {
      isFirstAdmobOrAdxInterstitialAdLoaded = false;
    });
    _firstAdxInterstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) async {
        isFirstAdmobOrAdxInterstitialAdLoaded = false;

        /// LOAD AD AFTER THE SHOW ADS
        // loadAdxInterstitialAd(
        //     screenName: routeName,
        //     context: context,
        //     googleInterID: googleInterID,
        //     fbInterID: fbInterID);
        _firstAdxInterstitialAd = null;
        ad.dispose();
        notifyListeners();
        await getRoute(routeName, loanType ?? '', context, arguments, isFrom: AdsType.admob, googleID: googleInterID, fbID: fbInterID, myAdsIdClass: myAdsIdClass);
      },
      onAdDismissedFullScreenContent: (ad) async {
        isFirstAdmobOrAdxInterstitialAdLoaded = false;

        _firstAdxInterstitialAd = null;
        ad.dispose();
        notifyListeners();
      },
      onAdFailedToShowFullScreenContent: (ad, error) async {
        _firstAdxInterstitialAd = null;
        ad.dispose();
        notifyListeners();
      },
    );
  }

  int loadingCount = 0;

  bool isInterstitialAdLoaded = false;
  bool isInterstitialAdLoading = false;

  Future<void> loadFBInterstitialAd({required String? googleID, required MyAdsIdClass myAdsIdClass, required String? fbID, String screenName = '', BuildContext? context}) async {
    String fbInterstitialAdId = fbID ?? '';
    // AdsUnitId().getFacebookInterstitialAdId();
    bool isFailedTwiceToLoadFbAdId = StorageUtils.prefs.getBool('${StorageKeyUtils.isFailedTwiceToLoadFbAdId}$fbID') ?? false;
    print('InterstitialAdsForDash.isInterstitialAdLoaded --> ${InterstitialAdsForDash.isInterstitialAdLoaded} isInterstitialAdLoaded --> $isInterstitialAdLoaded isInterstitialAdLoading --> $isInterstitialAdLoading  InterstitialAdsForDash.isInterstitialAdLoading ${InterstitialAdsForDash.isInterstitialAdLoading} Screen name --> isFailedTwiceToLoadFbAdId--> $isFailedTwiceToLoadFbAdId while loading  --. $screenName');

    print('Screen name --> isFailedTwiceToLoadFbAdId--> $isFailedTwiceToLoadFbAdId while loading  --. $screenName');
    if (isFailedTwiceToLoadFbAdId) {
      loadAdxInterstitialAd(myAdsIdClass: myAdsIdClass, screenName: 'Error', googleInterID: googleID, fbInterID: fbID);
      return;
    }
    if (InterstitialAdsForDash.isInterstitialAdLoaded) {
      return;
    }

    if (InterstitialAdsForDash.isInterstitialAdLoading) {
      return;
    }

    if (fbInterstitialAdId == '') {
      return;
    }

    if (kDebugMode) {
      fbInterstitialAdId = 'IMG_16_9_APP_INSTALL#$fbID';
      // debugPrint('ID INTER -- $screenName - - - - $fbInterstitialAdId');
    }

    if (isInterstitialAdLoaded == true) {
      return;
    }

    if (isInterstitialAdLoading == true) {
      loadingCount = loadingCount++;
      if (loadingCount == 2) {
        loadingCount = 0;
        isInterstitialAdLoading = false;
        FacebookInterstitialAd.destroyInterstitialAd();
      } else {
        return;
      }
    }

    isInterstitialAdLoading = true;
    print('Load Fb Ad Function ');
    FacebookInterstitialAd.loadInterstitialAd(
        placementId: fbInterstitialAdId,
        listener: (result, value) {
          debugPrint('INTER LISTENER $screenName =-=-=-=-=-=-=-=-=-=-=-=- $result, $value');
          if (result == InterstitialAdResult.LOADED) {
            // debugPrint('screenName INTER - - - - $screenName');
            isInterstitialAdLoaded = true;
            isInterstitialAdLoading = false;
            if (screenName == 'DashboardScreen') {
              showFBInterstitialAd('POP', context!, googleInterID: googleID, fbInterID: fbID, myAdsIdClass: myAdsIdClass);
            }
          }
          if (result == InterstitialAdResult.ERROR) {
            // print("Load Error --> $result #error $value");
            isInterstitialAdLoaded = false;
            isInterstitialAdLoading = false;

            // loadFBInterstitialAd();
            FacebookInterstitialAd.destroyInterstitialAd();
            StorageUtils.prefs.setBool(StorageKeyUtils.isShowFacebookAds, false);
            StorageUtils.prefs.setBool(StorageKeyUtils.isShowADXAds, true);
            StorageUtils.prefs.setBool(StorageKeyUtils.isShowAdmobAds, true);
            StorageUtils.prefs.setBool('${StorageKeyUtils.isFailedTwiceToLoadFbAdId}$fbID', true);

            loadAdxInterstitialAd(myAdsIdClass: myAdsIdClass, screenName: 'Error', googleInterID: googleID, fbInterID: fbID);
          }
          if (result == InterstitialAdResult.DISMISSED && value["invalidated"] == true) {
            isInterstitialAdLoading = false;
            print('screenName while dismissed--> $screenName');
            isInterstitialAdLoaded = false;
            FacebookInterstitialAd.destroyInterstitialAd();

            sendBroadcast("LoadAd");
          }
        });
  }

  showFBInterstitialAd(String routeName, BuildContext context, {String? loanType = '', required String? googleInterID, required String? fbInterID, required MyAdsIdClass myAdsIdClass, bool isFreeAds = false, var arguments}) async {
    print('fb isInterstitialAdLoaded -->$isInterstitialAdLoaded');
    if (isInterstitialAdLoaded == true) {
      FacebookInterstitialAd.showInterstitialAd().then((value) async {
        await getRoute(routeName, loanType ?? '', myAdsIdClass: myAdsIdClass, context, arguments, isFrom: AdsType.facebook, googleID: googleInterID, fbID: fbInterID);
        // loadFBInterstitialAd();
      });
    } else {
      print('_firstAdxInterstitialAd != null -->${_firstAdxInterstitialAd != null}');
      if (_firstAdxInterstitialAd != null) {
        showAdxInterstitialAd(routeName, context, myAdsIdClass: myAdsIdClass,arguments: arguments, googleInterID: googleInterID, fbInterID: fbInterID);
        return;
      }
      await getRoute(routeName, loanType ?? '', context, arguments, isFrom: AdsType.facebook, googleID: googleInterID, fbID: fbInterID, myAdsIdClass: myAdsIdClass);
    }
  }

  getRoute(
    String routeName,
    String loanType,
    BuildContext context,
    var arguments, {
    AdsType? isFrom,
    required String? googleID,
    required String? fbID,
    required MyAdsIdClass myAdsIdClass,
  }) {
    // debugPrint("isFrom - - - - - - - - - - - - - - > $isFrom");
    switch (routeName) {
      case 'POP':
        if (isFrom == null) {
        } else if (isFrom == AdsType.admob || isFrom == AdsType.adx) {
          loadAdxInterstitialAd(myAdsIdClass: myAdsIdClass, screenName: 'POP', googleInterID: googleID, fbInterID: fbID);
        } else {
          // loadFBInterstitialAd();
        }
        break;
      case 'POPDash':
        if (isFrom == null) {
        } else if (isFrom == AdsType.admob || isFrom == AdsType.adx) {
          loadAdxInterstitialAd(myAdsIdClass: myAdsIdClass, screenName: 'POP', googleInterID: googleID, fbInterID: fbID);
        } else {
          loadFBInterstitialAd(myAdsIdClass: myAdsIdClass, context: context, screenName: 'POP', googleID: googleID, fbID: fbID);
        }
        break;
      case RouteUtils.dashboardScreen:
        Navigator.pushNamed(context, RouteUtils.dashboardScreen, arguments: arguments).then((value) {
          if (isFrom == AdsType.admob || isFrom == AdsType.adx) {
            // loadInterstitialAd();
          } else {
            // loadFBInterstitialAd();
          }
        });
        break;
      // case RouteUtils.exploreMoreScreen:
      //   Navigator.pushNamed(context, RouteUtils.exploreMoreScreen)
      //       .then((value) {
      //     if (isFrom == AdsType.admob || isFrom == AdsType.adx) {
      //       // loadInterstitialAd();
      //     } else {
      //       // loadFBInterstitialAd();
      //     }
      //   });
      //   break;

      case RouteUtils.loanShortDescriptionScreen:
        Navigator.pushNamed(context, RouteUtils.loanShortDescriptionScreen, arguments: arguments).then((value) {
          if (isFrom == AdsType.admob || isFrom == AdsType.adx) {
            // loadInterstitialAd();
          } else {
            // loadFBInterstitialAd();
          }
        });
        break;
      case RouteUtils.loanFullDescriptionScreen:
        Navigator.pushNamed(context, RouteUtils.loanFullDescriptionScreen, arguments: arguments).then((value) {
          if (isFrom == AdsType.admob || isFrom == AdsType.adx) {
            // loadInterstitialAd();
          } else {
            // loadFBInterstitialAd();
          }
        });
        break;
      case RouteUtils.takingLoanReasonScreen:
        Navigator.pushNamed(context, RouteUtils.takingLoanReasonScreen, arguments: arguments).then((value) {
          if (isFrom == AdsType.admob || isFrom == AdsType.adx) {
            // loadInterstitialAd();
          } else {
            // loadFBInterstitialAd();
          }
        });
        break;
      case RouteUtils.loanApplicationProcess:
        Navigator.pushNamed(context, RouteUtils.loanApplicationProcess).then((value) {
          if (isFrom == AdsType.admob || isFrom == AdsType.adx) {
            // loadInterstitialAd();
          } else {
            // loadFBInterstitialAd();
          }
        });
        break;
      case RouteUtils.investmentDetailsScreen:
        Navigator.pushNamed(context, RouteUtils.investmentDetailsScreen, arguments: arguments).then((value) {
          if (isFrom == AdsType.admob || isFrom == AdsType.adx) {
            // loadInterstitialAd();
          } else {
            // loadFBInterstitialAd();
          }
        });
        break;
      case RouteUtils.eMILoanCalculatorScreen:
        Navigator.pushNamed(context, RouteUtils.eMILoanCalculatorScreen, arguments: arguments).then((value) {
          if (isFrom == AdsType.admob || isFrom == AdsType.adx) {
            // loadInterstitialAd();
          } else {
            // loadFBInterstitialAd();
          }
        });
        break;
      case RouteUtils.eligibilityLoanCalculatorScreen:
        Navigator.pushNamed(context, RouteUtils.eligibilityLoanCalculatorScreen, arguments: arguments).then((value) {
          if (isFrom == AdsType.admob || isFrom == AdsType.adx) {
            // loadInterstitialAd();
          } else {
            // loadFBInterstitialAd();
          }
        });
        break;
      case RouteUtils.dashboardMoreLoansScreen:
        Navigator.pushNamed(context, RouteUtils.dashboardMoreLoansScreen, arguments: arguments).then((value) {
          if (isFrom == AdsType.admob || isFrom == AdsType.adx) {
            // loadInterstitialAd();
          } else {
            // loadFBInterstitialAd();
          }
        });
        break;
      case RouteUtils.loanApplyScreen:
        Navigator.pushNamed(context, RouteUtils.loanApplyScreen, arguments: arguments).then((value) {
          if (isFrom == AdsType.admob || isFrom == AdsType.adx) {
            // loadInterstitialAd();
          } else {
            // loadFBInterstitialAd();
          }
        });
        break;
      case RouteUtils.clarificationScreen:
        Navigator.pushNamed(context, RouteUtils.clarificationScreen).then((value) {
          if (isFrom == AdsType.admob || isFrom == AdsType.adx) {
            // loadInterstitialAd();
          } else {
            // loadFBInterstitialAd();
          }
        });
        break;
      case RouteUtils.loanAdvantageScreen:
        Navigator.pushNamed(context, RouteUtils.loanAdvantageScreen, arguments: arguments).then((value) {
          if (isFrom == AdsType.admob || isFrom == AdsType.adx) {
            // loadInterstitialAd();
          } else {
            // loadFBInterstitialAd();
          }
        });
        break;

      // -----------------
      case RouteUtils.helpScreen:
        Navigator.pushNamed(context, RouteUtils.helpScreen).then((value) {
          if (isFrom == AdsType.admob || isFrom == AdsType.adx) {
            // loadInterstitialAd();
          } else {
            // loadFBInterstitialAd();
          }
        });
        break;
      case RouteUtils.questionAnswerScreen:
        Navigator.pushNamed(context, RouteUtils.questionAnswerScreen, arguments: arguments).then((value) {
          if (isFrom == AdsType.admob || isFrom == AdsType.adx) {
            // loadInterstitialAd();
          } else {
            // loadFBInterstitialAd();
          }
        });
        break;

      case RouteUtils.regenerateScreen:
        Navigator.pushNamed(context, RouteUtils.regenerateScreen, arguments: arguments).then((value) {
          if (isFrom == AdsType.admob || isFrom == AdsType.adx) {
            // loadInterstitialAd();
          } else {
            // loadFBInterstitialAd();
          }
        });
        break;
      default:
    }
  }
}
