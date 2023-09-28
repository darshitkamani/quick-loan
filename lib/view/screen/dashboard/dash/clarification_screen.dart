import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:action_broadcast/action_broadcast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:instant_pay/l10n/locale_keys.g.dart';
import 'package:instant_pay/utilities/colors/color_utils.dart';
import 'package:instant_pay/utilities/font/font_utils.dart';
import 'package:instant_pay/utilities/routes/route_utils.dart';
import 'package:instant_pay/utilities/storage/storage.dart';
import 'package:instant_pay/view/screen/dashboard/dashboard_screen.dart';
import 'package:instant_pay/view/screen/dashboard/home/model/available_ads_response.dart';
import 'package:instant_pay/view/widget/ads_widget/fb_native_add.dart';
import 'package:instant_pay/view/widget/ads_widget/interstitial_ads_widget.dart';
import 'package:instant_pay/view/widget/ads_widget/load_ads_by_api.dart';
import 'package:instant_pay/view/widget/center_text_button_border_widget.dart';
import 'package:instant_pay/view/widget/center_text_button_widget.dart';
import 'package:provider/provider.dart';

import '../../../../utilities/assets/asset_utils.dart';

class ClarificationScreen extends StatefulWidget {
  const ClarificationScreen({super.key});

  @override
  State<ClarificationScreen> createState() => _ClarificationScreenState();
}

String screenName = 'Clarification';

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

class _ClarificationScreenState extends State<ClarificationScreen> {
  // List<String> availableAdsList = [];
  MyAdsIdClass myAdsIdClass = MyAdsIdClass();
  late StreamSubscription receiver;

  @override
  void initState() {
    super.initState();
    initReceiver();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final provider =
          Provider.of<InterstitialAdsWidgetProvider>(context, listen: false);

      myAdsIdClass = await LoadAdsByApi()
          .isAvailableAds(context: context, screenName: screenName);
      // print("ABC __> $availableAdsList");
      if (myAdsIdClass.availableAdsList.contains("Native")) {
        // if (isFacebookAdsShow) {
        //   _showFBNativeAd();
        // }
        // if (isAdmobAdsShow || isADXAdsShow) {
        //   loadAdxNativeAd();
        // }
        ///New Code
        if (isCheckScreen) {
          _showFBNativeAd(isCalledFrom: 'isCheckScreen');
        } else {
          if (myAdsIdClass.isFacebook && isFacebookAdsShow) {
            _showFBNativeAd(isCalledFrom: 'else isCheckScreen ');
          }
          if (myAdsIdClass.isGoogle && isADXAdsShow) {
            loadAdxNativeAd();
          }
        }
      }

      if (myAdsIdClass.availableAdsList.contains("Interstitial")) {
        if (isCheckScreen) {
          provider.loadFBInterstitialAd(
              myAdsIdClass: myAdsIdClass,
              screenName: screenName,
              fbID: myAdsIdClass.facebookInterstitialId,
              googleID: myAdsIdClass.googleInterstitialId);
        } else {
          print(
              "myAdsIdClass.isFacebook && isFacebookAdsShow interstitial screenName --> $screenName --> ${myAdsIdClass.isFacebook} $isFacebookAdsShow");
          if (myAdsIdClass.isFacebook && isFacebookAdsShow) {
            provider.loadFBInterstitialAd(
                myAdsIdClass: myAdsIdClass,
                screenName: screenName,
                fbID: myAdsIdClass.facebookInterstitialId,
                googleID: myAdsIdClass.googleInterstitialId);
          }
          if (myAdsIdClass.isGoogle && isADXAdsShow) {
            provider.loadAdxInterstitialAd(
                myAdsIdClass: myAdsIdClass,
                screenName: screenName,
                context: context,
                fbInterID: myAdsIdClass.facebookInterstitialId,
                googleInterID: myAdsIdClass.googleInterstitialId);
          }
        }
      }
    });
  }

  Future initReceiver() async {
    receiver = registerReceiver(['LoadAd']).listen((intent) async {
      print('$screenName Data ----> ${intent.extras}');
      switch (intent.action) {
        case 'LoadAd':
          final provider = Provider.of<InterstitialAdsWidgetProvider>(context,
              listen: false);
          myAdsIdClass = await LoadAdsByApi()
              .isAvailableAds(context: context, screenName: screenName);
          setState(() {});
          if (myAdsIdClass.availableAdsList.contains("Interstitial")) {
            if (isCheckScreen) {
              provider.loadFBInterstitialAd(
                  myAdsIdClass: myAdsIdClass,
                  screenName: screenName,
                  fbID: myAdsIdClass.facebookInterstitialId,
                  googleID: myAdsIdClass.googleInterstitialId);
            } else {
              print(
                  "myAdsIdClass.isFacebook && isFacebookAdsShow in receiver interstitial screenName --> $screenName --> ${myAdsIdClass.isFacebook} $isFacebookAdsShow");
              if (myAdsIdClass.isFacebook && isFacebookAdsShow) {
                provider.loadFBInterstitialAd(
                    myAdsIdClass: myAdsIdClass,
                    screenName: screenName,
                    fbID: myAdsIdClass.facebookInterstitialId,
                    googleID: myAdsIdClass.googleInterstitialId);
              }
              if (myAdsIdClass.isGoogle && isADXAdsShow) {
                provider.loadAdxInterstitialAd(
                    myAdsIdClass: myAdsIdClass,
                    screenName: screenName,
                    context: context,
                    fbInterID: myAdsIdClass.facebookInterstitialId,
                    googleInterID: myAdsIdClass.googleInterstitialId);
              }
            }
          }
          break;
        default:
      }
    });
  }

  Widget fbNativeAd = const SizedBox();

  ///Replace this function
  _showFBNativeAd({required String isCalledFrom}) {
    bool isFailedTwiceToLoadFbAdId = StorageUtils.prefs.getBool(
            '${StorageKeyUtils.isFailedTwiceToLoadFbAdId}${myAdsIdClass.facebookNativeId}') ??
        false;

    if (myAdsIdClass.facebookNativeId.isEmpty || isFailedTwiceToLoadFbAdId) {
      loadAdxNativeAd(isCalledFrom: isCalledFrom);
    } else {
      setState(() {
        fbNativeAd = loadFbNativeAd(myAdsIdClass.facebookNativeId);
      });
      // updatePrefsResponse(adType: 'Native');
    }
  }
  // _showFBNativeAd() {
  //   setState(() {
  //     fbNativeAd = loadFbNativeAd(myAdsIdClass.facebookNativeId);
  //   });
  //   updatePrefsResponse(adType: 'Native');
  // }

  updatePrefsResponse({required String adType}) {
    Timer(const Duration(seconds: 1), () {
      isFacebookAdsShow =
          StorageUtils.prefs.getBool(StorageKeyUtils.isShowFacebookAds) ??
              false;
      isADXAdsShow =
          StorageUtils.prefs.getBool(StorageKeyUtils.isShowADXAds) ?? false;
      isAdmobAdsShow =
          StorageUtils.prefs.getBool(StorageKeyUtils.isShowAdmobAds) ?? false;
      isAdShow =
          StorageUtils.prefs.getBool(StorageKeyUtils.isAddShowInApp) ?? false;
      setState(() {});
      if (isAdmobAdsShow) {
        setState(() {
          fbNativeAd = const SizedBox();
        });
        if (adType == "Native") {
          loadAdxNativeAd();
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (receiver != null) {
      receiver.cancel();
    }

    if (adxNativeAd != null) {
      adxNativeAd!.dispose();
    }
  }

  NativeAd? adxNativeAd;
  bool _isAdxNativeAdLoaded = false;

  loadAdxNativeAd({String isCalledFrom = 'init'}) async {
    print(
        'Screen name loadNativeAd() ---> $screenName isCalledFrom --> $isCalledFrom ');

    String nativeAdId = myAdsIdClass.googleNativeId;
    // AdsUnitId().getGoogleNativeAdId();
    if (nativeAdId != '') {
      setState(() {
        adxNativeAd = NativeAd(
          adUnitId: nativeAdId,
          factoryId: 'adFactory',
          request: const AdRequest(),
          listener: NativeAdListener(
            onAdLoaded: (ad) {
              setState(() {
                _isAdxNativeAdLoaded = true;
                adxNativeAd = ad as NativeAd;
              });
            },
            onAdFailedToLoad: (ad, error) {
              ad.dispose();
            },
          ),
        );
        adxNativeAd!.load();
      });
    }
  }

  Widget loadFbNativeAd(String adId, {String isCalledFrom = 'init'}) {
    print(
        'Screen name loadFbNativeAd() ---> $screenName isCalledFrom -->$isCalledFrom ');

    String nativeAdId = adId;
    // AdsUnitId().getFacebookNativeAdId();
    if (nativeAdId == '') {
      return const SizedBox();
    }

    if (kDebugMode) {
      nativeAdId = 'IMG_16_9_APP_INSTALL#$adId';
      // debugPrint('ID - - - - $nativeAdId');
    }

    return FacebookNativeAd(
      placementId: nativeAdId, // nativeAdId,
      adType: NativeAdType.NATIVE_AD_VERTICAL,
      width: double.infinity,
      height: 300,
      backgroundColor: const Color(0xFFFFE6C5),
      titleColor: Colors.black,
      descriptionColor: Colors.black,
      buttonColor: const Color(0xff673AB7),
      buttonTitleColor: Colors.white,
      buttonBorderColor: const Color(0xff673AB7),
      listener: (result, value) {
        // print('---=- =-= -= -= -= - $result $value');

        if (result == NativeAdResult.ERROR) {
          // loadFBInterstitialAd();
          StorageUtils.prefs.setBool(StorageKeyUtils.isShowFacebookAds, false);
          StorageUtils.prefs.setBool(StorageKeyUtils.isShowADXAds, true);
          StorageUtils.prefs.setBool(StorageKeyUtils.isShowAdmobAds, true);
          bool isFailedTwiceToLoadFbAdId = StorageUtils.prefs.getBool(
                  '${StorageKeyUtils.isFailedTwiceToLoadFbAdId}$adId') ??
              false;

          if (!isFailedTwiceToLoadFbAdId) {
            StorageUtils.prefs.setBool(
                '${StorageKeyUtils.isFailedTwiceToLoadFbAdId}$adId', true);
            loadAdxNativeAd(isCalledFrom: 'fbNativeFunction');
          }
        }
      },
      keepExpandedWhileLoading: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorUtils.themeColor.oxff673AB7,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: ColorUtils.themeColor.oxffFFFFFF,
            )),
        title: Text(
          'Clarification',
          style: FontUtils.h16(
            fontColor: ColorUtils.themeColor.oxffFFFFFF,
            fontWeight: FWT.semiBold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            fbNativeAd,
            adxNativeAd == null || _isAdxNativeAdLoaded == false
                ? const SizedBox()
                : Container(
                    color: Colors.transparent,
                    height: 370,
                    alignment: Alignment.center,
                    child: AdWidget(ad: adxNativeAd!),
                  ),
            Lottie.asset(
              AssetUtils.appliedLottie,
              height: 200,
            ),
            const SizedBox(height: 10),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.redAccent),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Text(
                    LocaleKeys.CLARIFICATION2.tr(),
                    style: FontUtils.h14(
                        fontColor: Colors.redAccent, fontWeight: FWT.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.green),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        LocaleKeys.CLARIFICATION1.tr().toUpperCase(),
                        style: FontUtils.h14(
                          fontColor: Colors.green,
                          fontWeight: FWT.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            CenterTextButtonWidget(
              onTap: () {
                if (receiver != null) {
                  receiver.cancel();
                }
                final provider = Provider.of<InterstitialAdsWidgetProvider>(
                    context,
                    listen: false);
                provider.showFbOrAdxOrAdmobInterstitialAd(
                  myAdsIdClass: myAdsIdClass,
                  availableAds: myAdsIdClass.availableAdsList,
                  RouteUtils.regenerateScreen,
                  context,
                  fbInterID: myAdsIdClass.facebookInterstitialId,
                  googleInterID: myAdsIdClass.googleInterstitialId,
                );

                // Navigator.pushNamed(context, RouteUtils.regenerateScreen);
              },
              title: LocaleKeys.NEXT.tr(),
            ),
            CenterTextButtonBorderWidget(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            DashboardScreen(routeName: 'Clarification')),
                    (route) => false);
                // Navigator.pushNamedAndRemoveUntil(
                //     context, RouteUtils.dashboardScreen, (route) => false,
                //     arguments: 'Clarification');
              },
              title: Center(
                child: Text(
                  LocaleKeys.HOME.tr(),
                  style: FontUtils.h16(
                      fontColor: ColorUtils.themeColor.oxff673AB7,
                      fontWeight: FWT.semiBold),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
