import 'package:action_broadcast/action_broadcast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
import 'package:instant_pay/view/widget/bounce_click_widget.dart';
import 'package:instant_pay/view/widget/lottie_ad_widget.dart';
import 'package:provider/provider.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String screenName = "CalculatorScreen";
  bool isFacebookAdsShow = StorageUtils.prefs.getBool(StorageKeyUtils.isShowFacebookAds) ?? false;
  bool isADXAdsShow = StorageUtils.prefs.getBool(StorageKeyUtils.isShowADXAds) ?? false;
  bool isAdmobAdsShow = StorageUtils.prefs.getBool(StorageKeyUtils.isShowAdmobAds) ?? false;
  bool isAdShow = StorageUtils.prefs.getBool(StorageKeyUtils.isAddShowInApp) ?? false;
  // List<String> availableAdsList = [];

  MyAdsIdClass myAdsIdClass = MyAdsIdClass();
  late StreamSubscription receiver;

  bool isCheckScreen = StorageUtils.prefs.getBool(StorageKeyUtils.isCheckScreenForAdInApp) ?? false;

  @override
  void initState() {
    super.initState();
    initReceiver();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (!kDebugMode) {
        await FirebaseAnalytics.instance.logEvent(name: screenName);
      }

      final provider = Provider.of<InterstitialAdsWidgetProvider>(context, listen: false);

      myAdsIdClass = await LoadAdsByApi().isAvailableAds(context: context, screenName: screenName);

      if (myAdsIdClass.availableAdsList.contains("Native")) {
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
        print('screenName $screenName === isCheckScreen -- $isCheckScreen === myAdsIdClass.isFacebook -- ${myAdsIdClass.isFacebook} === isFacebookAdsShow -- $isFacebookAdsShow === myAdsIdClass.isGoogle -- ${myAdsIdClass.isGoogle} === isADXAdsShow -- $isADXAdsShow');
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

  Widget fbNativeBannerAd = const SizedBox();

  _showFBNativeAd({required String isCalledFrom}) {
    bool isFailedTwiceToLoadFbAdId = StorageUtils.prefs.getBool('${StorageKeyUtils.isFailedTwiceToLoadFbAdId}${myAdsIdClass.facebookNativeId}') ?? false;

    if (myAdsIdClass.facebookNativeId.isEmpty || isFailedTwiceToLoadFbAdId) {
      loadAdxNativeAd(isCalledFrom: isCalledFrom);
    } else {
      setState(() {
        fbNativeBannerAd = loadFbNativeAd(myAdsIdClass.facebookNativeId, isCalledFrom: isCalledFrom);
      });
      // updatePrefsResponse(adType: 'Native');
    }
  }

  // _showFBNativeAd() {
  //   setState(() {
  //     fbNativeBannerAd = loadFbNativeAd(myAdsIdClass.facebookNativeId);
  //   });
  //   updatePrefsResponse(adType: 'Native');
  // }

  updatePrefsResponse({required String adType}) {
    Timer(const Duration(seconds: 1), () {
      isFacebookAdsShow = StorageUtils.prefs.getBool(StorageKeyUtils.isShowFacebookAds) ?? false;
      isADXAdsShow = StorageUtils.prefs.getBool(StorageKeyUtils.isShowADXAds) ?? false;
      isAdmobAdsShow = StorageUtils.prefs.getBool(StorageKeyUtils.isShowAdmobAds) ?? false;
      isAdShow = StorageUtils.prefs.getBool(StorageKeyUtils.isAddShowInApp) ?? false;
      setState(() {});
      if (isAdmobAdsShow) {
        setState(() {
          fbNativeBannerAd = const SizedBox();
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
    receiver.cancel();

    if (nativeAd != null) {
      nativeAd!.dispose();
    }
  }

  NativeAd? nativeAd;
  bool _nativeAdIsLoaded = false;

  loadAdxNativeAd({String isCalledFrom = 'init'}) async {
    String nativeAdId = myAdsIdClass.googleNativeId;
    if (nativeAdId != '') {
      setState(() {
        nativeAd = NativeAd(
          adUnitId: nativeAdId,
          nativeAdOptions: NativeAdOptions(),
          factoryId: 'listTileMedium',
          request: const AdRequest(),
          listener: NativeAdListener(
            onAdLoaded: (ad) {
              setState(() {
                _nativeAdIsLoaded = true;
                nativeAd = ad as NativeAd;
              });
            },
            onAdFailedToLoad: (ad, error) {
              ad.dispose();
            },
          ),
        );
        nativeAd!.load();
      });
    }
  }

  ///New Flow
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
      buttonColor: const Color(0xff447D58),
      buttonTitleColor: Colors.white,
      buttonBorderColor: const Color(0xff447D58),
      listener: (result, value) {
        // print('---=- =-= -= -= -= - $result $value');

        if (result == NativeAdResult.ERROR) {
          // loadFBInterstitialAd(
          // myAdsIdClass:myAdsIdClass,);
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

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
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
                  Text(LocaleKeys.Calculator.tr(), style: FontUtils.h20(fontWeight: FWT.bold)),
                  const LottieAdWidget(lottieURL: AssetUtils.icCalculator),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
              const SizedBox(height: 10),
                fbNativeBannerAd,
                nativeAd == null || _nativeAdIsLoaded == false
                    ? const SizedBox()
                    : Container(
                        color: Colors.transparent,
                        height: 275,
                        alignment: Alignment.center,
                        child: AdWidget(ad: nativeAd!),
                      ),
                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: BounceClickWidget(
                    onTap: () {
                      final provider = Provider.of<InterstitialAdsWidgetProvider>(context, listen: false);
                      receiver.cancel();

                      provider.showFbOrAdxOrAdmobInterstitialAd(
                        RouteUtils.eMILoanCalculatorScreen,
                        context,
                        myAdsIdClass: myAdsIdClass,
                        availableAds: myAdsIdClass.availableAdsList,
                        fbInterID: myAdsIdClass.facebookInterstitialId,
                        googleInterID: myAdsIdClass.googleInterstitialId,
                      );
                    },
                    child: Stack(
                      children: [
                        Container(
                          height: screenSize.height * 0.30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [BoxShadow(color: Colors.black, blurRadius: 10, spreadRadius: -7)],
                            color: ColorUtils.themeColor.oxffFFFFFF,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: const Image(
                              image: AssetImage(AssetUtils.icEmiCal),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        // Positioned(
                        //   left: 20,
                        //   top: 60,
                        //   child: Text(
                        //     'EMI\nCALCULATOR',
                        //     textAlign: TextAlign.center,
                        //     style: FontUtils.h26(fontWeight: FWT.bold),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // IconButton(
                //     onPressed: () {
                //       Navigator.pushNamed(context, RouteUtils.dashboardScreen);
                //     },
                //     icon: const Icon(Icons.abc_outlined)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: BounceClickWidget(
                    onTap: () {
                      final provider = Provider.of<InterstitialAdsWidgetProvider>(context, listen: false);
                      receiver.cancel();

                      provider.showFbOrAdxOrAdmobInterstitialAd(
                        RouteUtils.eligibilityLoanCalculatorScreen,
                        context,
                        myAdsIdClass: myAdsIdClass,
                        availableAds: myAdsIdClass.availableAdsList,
                        fbInterID: myAdsIdClass.facebookInterstitialId,
                        googleInterID: myAdsIdClass.googleInterstitialId,
                      );
                    },
                    child: Stack(
                      children: [
                        Container(
                          height: screenSize.height * 0.30,
                          decoration: BoxDecoration(
                            boxShadow: const [BoxShadow(color: Colors.black, blurRadius: 10, spreadRadius: -7)],
                            borderRadius: BorderRadius.circular(20),
                            color: ColorUtils.themeColor.oxffFFFFFF,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: const Image(
                              image: AssetImage(AssetUtils.icEligibility),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 20,
                          top: 80,
                          child: Text(
                            'LOAN\nCALCULATOR',
                            textAlign: TextAlign.center,
                            style: FontUtils.h20(fontWeight: FWT.bold, fontColor: ColorUtils.themeColor.oxff000000),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
