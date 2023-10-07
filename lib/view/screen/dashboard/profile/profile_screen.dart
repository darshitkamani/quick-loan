import 'dart:io';

import 'package:action_broadcast/action_broadcast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:instant_pay/l10n/locale_keys.g.dart';
import 'package:instant_pay/utilities/assets/asset_utils.dart';
import 'package:instant_pay/utilities/colors/color_utils.dart';
import 'package:instant_pay/utilities/font/font_utils.dart';
import 'package:instant_pay/utilities/routes/route_utils.dart';
import 'package:instant_pay/utilities/storage/storage.dart';
import 'package:instant_pay/view/screen/dashboard/home/model/available_ads_response.dart';
import 'package:instant_pay/view/widget/ads_widget/interstitial_ads_widget.dart';
import 'package:instant_pay/view/widget/ads_widget/load_ads_by_api.dart';
import 'package:instant_pay/view/widget/lottie_ad_widget.dart';
import 'package:instant_pay/view/widget/profile_button_button_widget.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String screenName = "ProfileScreen";
  bool isFacebookAdsShow = StorageUtils.prefs.getBool(StorageKeyUtils.isShowFacebookAds) ?? false;
  bool isADXAdsShow = StorageUtils.prefs.getBool(StorageKeyUtils.isShowADXAds) ?? false;
  bool isAdmobAdsShow = StorageUtils.prefs.getBool(StorageKeyUtils.isShowAdmobAds) ?? false;
  bool isAdShow = StorageUtils.prefs.getBool(StorageKeyUtils.isAddShowInApp) ?? false;

  bool isCheckScreen = StorageUtils.prefs.getBool(StorageKeyUtils.isCheckScreenForAdInApp) ?? false;

  MyAdsIdClass myAdsIdClass = MyAdsIdClass();
  late StreamSubscription receiver;
  @override
  void initState() {
    super.initState();
    initReceiver();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (!kDebugMode) {
        await FirebaseAnalytics.instance.logEvent(name: screenName);
      }
      final provider = Provider.of<InterstitialAdsWidgetProvider>(context, listen: false);
      int prefferedLanguage = StorageUtils.prefs.getInt(StorageKeyUtils.applicationLanguageState) ?? 0;

      setState(() {
        isLangSwitchValue = (prefferedLanguage == 0) ? false : true;
      });

      myAdsIdClass = await LoadAdsByApi().isAvailableAds(context: context, screenName: screenName);
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
          provider.loadFBInterstitialAd(myAdsIdClass: myAdsIdClass, screenName: screenName, fbID: myAdsIdClass.facebookInterstitialId, googleID: myAdsIdClass.googleInterstitialId);
        } else {
          print("myAdsIdClass.isFacebook && isFacebookAdsShow interstitial screenName --> $screenName --> ${myAdsIdClass.isFacebook} $isFacebookAdsShow");
          if (myAdsIdClass.isFacebook && isFacebookAdsShow) {
            provider.loadFBInterstitialAd(myAdsIdClass: myAdsIdClass, screenName: screenName, fbID: myAdsIdClass.facebookInterstitialId, googleID: myAdsIdClass.googleInterstitialId);
          }
          if (myAdsIdClass.isGoogle && isADXAdsShow) {
            provider.loadAdxInterstitialAd(myAdsIdClass: myAdsIdClass, screenName: screenName, context: context, fbInterID: myAdsIdClass.facebookInterstitialId, googleInterID: myAdsIdClass.googleInterstitialId);
          }
        }
      }
    });
  }

  Widget fbNativeAd = const SizedBox();

  bool isLangSwitchValue = false;

  // _showFBNativeAd() {
  //   setState(() {
  //     fbNativeAd = loadFbNativeAd(myAdsIdClass.facebookNativeId);
  //   });
  //   updatePrefsResponse(adType: 'Native');
  // }
  _showFBNativeAd({required String isCalledFrom}) {
    bool isFailedTwiceToLoadFbAdId = StorageUtils.prefs.getBool('${StorageKeyUtils.isFailedTwiceToLoadFbAdId}${myAdsIdClass.facebookNativeId}') ?? false;

    if (myAdsIdClass.facebookNativeId.isEmpty || isFailedTwiceToLoadFbAdId) {
      loadAdxNativeAd(isCalledFrom: isCalledFrom);
    } else {
      setState(() {
        fbNativeAd = loadFbNativeAd(myAdsIdClass.facebookNativeId);
      });
      // updatePrefsResponse(adType: 'Native');
    }
  }

  Widget loadFbNativeAd(String adId, {String isCalledFrom = 'init'}) {
    print('Screen name loadFbNativeAd() ---> $screenName isCalledFrom -->$isCalledFrom ');

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
          bool isFailedTwiceToLoadFbAdId = StorageUtils.prefs.getBool('${StorageKeyUtils.isFailedTwiceToLoadFbAdId}$adId') ?? false;

          if (!isFailedTwiceToLoadFbAdId) {
            StorageUtils.prefs.setBool('${StorageKeyUtils.isFailedTwiceToLoadFbAdId}$adId', true);
            loadAdxNativeAd(isCalledFrom: 'fbNativeFunction');
          }
        }
      },
      keepExpandedWhileLoading: false,
    );
  }

  updatePrefsResponse({required String adType}) {
    Timer(const Duration(seconds: 1), () {
      isFacebookAdsShow = StorageUtils.prefs.getBool(StorageKeyUtils.isShowFacebookAds) ?? false;
      isADXAdsShow = StorageUtils.prefs.getBool(StorageKeyUtils.isShowADXAds) ?? false;
      isAdmobAdsShow = StorageUtils.prefs.getBool(StorageKeyUtils.isShowAdmobAds) ?? false;
      isAdShow = StorageUtils.prefs.getBool(StorageKeyUtils.isAddShowInApp) ?? false;
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

  Future initReceiver() async {
    receiver = registerReceiver(['LoadAd']).listen((intent) async {
      print('$screenName Data ----> ${intent.extras}');
      switch (intent.action) {
        case 'LoadAd':
          final provider = Provider.of<InterstitialAdsWidgetProvider>(context, listen: false);
          myAdsIdClass = await LoadAdsByApi().isAvailableAds(context: context, screenName: screenName);
          setState(() {});

          if (myAdsIdClass.availableAdsList.contains("Interstitial")) {
            if (isCheckScreen) {
              provider.loadFBInterstitialAd(myAdsIdClass: myAdsIdClass, screenName: screenName, fbID: myAdsIdClass.facebookInterstitialId, googleID: myAdsIdClass.googleInterstitialId);
            } else {
              print("myAdsIdClass.isFacebook && isFacebookAdsShow in receiver interstitial screenName --> $screenName --> ${myAdsIdClass.isFacebook} $isFacebookAdsShow");
              if (myAdsIdClass.isFacebook && isFacebookAdsShow) {
                provider.loadFBInterstitialAd(myAdsIdClass: myAdsIdClass, screenName: screenName, fbID: myAdsIdClass.facebookInterstitialId, googleID: myAdsIdClass.googleInterstitialId);
              }
              if (myAdsIdClass.isGoogle && isADXAdsShow) {
                provider.loadAdxInterstitialAd(myAdsIdClass: myAdsIdClass, screenName: screenName, context: context, fbInterID: myAdsIdClass.facebookInterstitialId, googleInterID: myAdsIdClass.googleInterstitialId);
              }
            }
          }
          break;
        default:
      }
    });
  }

  @override
  void dispose() {
    receiver.cancel();

    super.dispose();
    if (adxNativeAd != null) {
      adxNativeAd!.dispose();
    }
  }

  NativeAd? adxNativeAd;
  bool _isAdxNativeAdLoaded = false;

  loadAdxNativeAd({String isCalledFrom = 'init'}) async {
    print('Screen name loadNativeAd() ---> $screenName isCalledFrom --> $isCalledFrom ');

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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SafeArea(
          child: Container(
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: ColorUtils.themeColor.oxff858494.withOpacity(0.2))), color: Colors.transparent),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LocaleKeys.MyAccount.tr(),
                    style: FontUtils.h16(fontWeight: FWT.semiBold, letterSpacing: 2),
                  ),
                  const LottieAdWidget(lottieURL: AssetUtils.icProfile),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  ProfileButtonWidget(
                    onTap: () {
                      final url = Uri.parse("market://details?id=com.quick_loan_credit_card_advisor");
                      launchUrl(url);
                    },
                    titleWidget: Icon(
                      Icons.new_releases_outlined,
                      color: ColorUtils.themeColor.oxff101523,
                    ),
                    title: LocaleKeys.CheckUpdate.tr(),
                  ),
                  const SizedBox(height: 10),
                  ProfileButtonWidget(
                    onTap: () async {
                      if (Platform.isAndroid) {
                        final url = Uri.parse("market://details?id=com.quick_loan_credit_card_advisor");
                        launchUrl(url);
                      } else if (Platform.isIOS) {}
                    },
                    titleWidget: Icon(
                      Icons.thumb_up_off_alt,
                      color: ColorUtils.themeColor.oxff101523,
                    ),
                    title: LocaleKeys.Evaluation.tr(),
                  ),
                  const SizedBox(height: 10),
                  ProfileButtonWidget(
                    onTap: () {
                      Share.share('Check out this loan APP :\nhttps://play.google.com/store/apps/details?id=com.quick_loan_credit_card_advisor');
                    },
                    titleWidget: Icon(
                      Icons.share_outlined,
                      color: ColorUtils.themeColor.oxff101523,
                    ),
                    title: LocaleKeys.ShareApp.tr(),
                  ),
                  const SizedBox(height: 10),
                  ProfileButtonWidget(
                    onTap: () {
                      Navigator.pushNamed(context, RouteUtils.privacyPoliciesLoanScreen);
                    },
                    titleWidget: Icon(
                      Icons.privacy_tip_outlined,
                      color: ColorUtils.themeColor.oxff101523,
                    ),
                    title: LocaleKeys.PrivacyPolicies.tr(),
                  ),
                  const SizedBox(height: 10),
                  ProfileButtonWidget(
                    onTap: () {
                      Navigator.pushNamed(context, RouteUtils.termsAndConditionScreen);
                    },
                    titleWidget: Icon(
                      Icons.library_books_outlined,
                      color: ColorUtils.themeColor.oxff101523,
                    ),
                    title: LocaleKeys.TermsCondition.tr(),
                  ),
                  const SizedBox(height: 10),
                  ProfileButtonWidget(
                    onTap: () {
                      if (EasyLocalization.of(context)?.currentLocale == const Locale('en', 'US')) {
                        EasyLocalization.of(context)?.setLocale(const Locale('hi', 'IN'));
                        StorageUtils.prefs.setInt(StorageKeyUtils.applicationLanguageState, 1);
                      } else if (EasyLocalization.of(context)?.currentLocale == const Locale('hi', 'IN')) {
                        EasyLocalization.of(context)?.setLocale(const Locale('en', 'US'));
                        StorageUtils.prefs.setInt(StorageKeyUtils.applicationLanguageState, 0);
                      }
                      setState(() {
                        isLangSwitchValue = !isLangSwitchValue;
                      });
                    },
                    trailWidget: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FlutterSwitch(
                          height: 33.0,
                          width: 55.0,
                          toggleSize: 25.0,
                          value: isLangSwitchValue,
                          borderRadius: 30.0,
                          activeColor: const Color(0xff673AB7),
                          inactiveColor: const Color(0xff673AB7),
                          activeIcon: const Image(image: AssetImage(AssetUtils.hinLogo), fit: BoxFit.cover),
                          inactiveIcon: const Image(image: AssetImage(AssetUtils.engLogo), fit: BoxFit.cover),
                          onToggle: (val) {
                            if (EasyLocalization.of(context)?.currentLocale == const Locale('en', 'US')) {
                              EasyLocalization.of(context)?.setLocale(const Locale('hi', 'IN'));
                              StorageUtils.prefs.setInt(StorageKeyUtils.applicationLanguageState, 1);
                            } else if (EasyLocalization.of(context)?.currentLocale == const Locale('hi', 'IN')) {
                              EasyLocalization.of(context)?.setLocale(const Locale('en', 'US'));
                              StorageUtils.prefs.setInt(StorageKeyUtils.applicationLanguageState, 0);
                            }
                            setState(() {
                              isLangSwitchValue = val;
                            });
                          },
                        ),
                      ],
                    ),
                    titleWidget: Icon(
                      Icons.language,
                      color: ColorUtils.themeColor.oxff101523,
                    ),
                    title: LocaleKeys.ChangeLanguage.tr(),
                  ),
                  const SizedBox(height: 10),
                  fbNativeAd,
                  adxNativeAd == null || _isAdxNativeAdLoaded == false
                      ? const SizedBox()
                      : Container(
                          color: Colors.transparent,
                          height: 330,
                          alignment: Alignment.center,
                          child: AdWidget(ad: adxNativeAd!),
                        ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
