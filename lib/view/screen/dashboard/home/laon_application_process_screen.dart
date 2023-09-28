import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:action_broadcast/action_broadcast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:instant_pay/l10n/locale_keys.g.dart';
import 'package:instant_pay/utilities/assets/asset_utils.dart';
import 'package:instant_pay/utilities/colors/color_utils.dart';
import 'package:instant_pay/utilities/font/font_utils.dart';
import 'package:instant_pay/utilities/routes/route_utils.dart';
import 'package:instant_pay/utilities/storage/storage.dart';
import 'package:instant_pay/view/screen/dashboard/home/model/available_ads_response.dart';
import 'package:instant_pay/view/widget/ads_widget/fb_native_add.dart';
import 'package:instant_pay/view/widget/ads_widget/interstitial_ads_widget.dart';
import 'package:instant_pay/view/widget/ads_widget/load_ads_by_api.dart';
import 'package:instant_pay/view/widget/center_text_button_widget.dart';
import 'package:provider/provider.dart';

import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/foundation.dart';

class LoanApplicationProcessScreen extends StatefulWidget {
  const LoanApplicationProcessScreen({super.key});

  @override
  State<LoanApplicationProcessScreen> createState() =>
      _LoanApplicationProcessScreenState();
}

class _LoanApplicationProcessScreenState
    extends State<LoanApplicationProcessScreen> {
  String screenName = "LoanProcessAdvice";
  bool isFacebookAdsShow =
      StorageUtils.prefs.getBool(StorageKeyUtils.isShowFacebookAds) ?? false;
  bool isADXAdsShow =
      StorageUtils.prefs.getBool(StorageKeyUtils.isShowADXAds) ?? false;
  bool isAdmobAdsShow =
      StorageUtils.prefs.getBool(StorageKeyUtils.isShowAdmobAds) ?? false;
  bool isAdShow =
      StorageUtils.prefs.getBool(StorageKeyUtils.isAddShowInApp) ?? false;
  // List<String> availableAdsList = [];
  MyAdsIdClass myAdsIdClass = MyAdsIdClass();
  late StreamSubscription receiver;
  bool isCheckScreen =
      StorageUtils.prefs.getBool(StorageKeyUtils.isCheckScreenForAdInApp) ??
          false;

  @override
  void initState() {
    super.initState();
    initReceiver();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final provider =
          Provider.of<InterstitialAdsWidgetProvider>(context, listen: false);

      myAdsIdClass = await LoadAdsByApi()
          .isAvailableAds(context: context, screenName: screenName);
      setState(() {});

      if (myAdsIdClass.availableAdsList.contains("Native")) {
        // if (isFacebookAdsShow) {
        //   _showFBNativeAd();
        // }
        // if (isAdmobAdsShow || isADXAdsShow) {
        //   loadAdxNativeAd();
        //   loadAdxNativeAd1();
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
            loadAdxNativeAd1();
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
          print(
              'myAdsIdClass.isGoogle && isADXAdsShow --> ${myAdsIdClass.isGoogle && isADXAdsShow} myAdsIdClass .isFacebook && isFacebookAdsShow --> ${myAdsIdClass.isFacebook && isFacebookAdsShow}isCheckScreen --> $isCheckScreen myAdsIdClass.availableAdsList.contains("Interstitial") --> ${myAdsIdClass.availableAdsList.contains("Interstitial")}');

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
  Widget fbNativeAd1 = const SizedBox();

  // _showFBNativeAd() {
  //   setState(() {
  //     fbNativeAd = loadFbNativeAd(myAdsIdClass.facebookNativeId);
  //     fbNativeAd1 = loadFbNativeAd(myAdsIdClass.facebookNativeId);
  //   });
  //   updatePrefsResponse(adType: 'Native');
  // }
  _showFBNativeAd({required String isCalledFrom}) {
    bool isFailedTwiceToLoadFbAdId = StorageUtils.prefs.getBool(
            '${StorageKeyUtils.isFailedTwiceToLoadFbAdId}${myAdsIdClass.facebookNativeId}') ??
        false;

    if (myAdsIdClass.facebookNativeId.isEmpty || isFailedTwiceToLoadFbAdId) {
      loadAdxNativeAd(isCalledFrom: isCalledFrom);
      loadAdxNativeAd1(isCalledFrom: isCalledFrom);
    } else {
      setState(() {
        fbNativeAd = loadFbNativeAd(myAdsIdClass.facebookNativeId);
        fbNativeAd1 = loadFbNativeAd(myAdsIdClass.facebookNativeId);
      });
      // updatePrefsResponse(adType: 'Native');
    }
  }

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
          fbNativeAd1 = const SizedBox();
        });
        if (adType == "Native") {
          loadAdxNativeAd();
          loadAdxNativeAd1();
        } else {}
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
    if (adxNativeAd1 != null) {
      adxNativeAd1!.dispose();
    }
  }

  NativeAd? adxNativeAd;
  bool _isAdxNativeAdLoaded = false;

  NativeAd? adxNativeAd1;
  bool _isAdxNativeAdLoaded1 = false;

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

  loadAdxNativeAd1({String isCalledFrom = 'init'}) async {
    print(
        'Screen name loadNativeAd1() ---> $screenName isCalledFrom --> $isCalledFrom ');
    String nativeAdId = myAdsIdClass.googleNativeId;
    // AdsUnitId().getGoogleNativeAdId();
    if (nativeAdId != '') {
      setState(() {
        adxNativeAd1 = NativeAd(
          adUnitId: nativeAdId,
          factoryId: 'adFactory',
          request: const AdRequest(),
          listener: NativeAdListener(
            onAdLoaded: (ad) {
              setState(() {
                _isAdxNativeAdLoaded1 = true;
                adxNativeAd1 = ad as NativeAd;
              });
            },
            onAdFailedToLoad: (ad, error) {
              ad.dispose();
            },
          ),
        );
        adxNativeAd1!.load();
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
    // print(
    // "Is Admob show --> $isADXAdsShow, $isAdmobAdsShow, ${availableAdsList.contains("Native")}");
    return Scaffold(
      appBar: AppBar(
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
          LocaleKeys.LoanApplicationProcessTitle.tr(),
          style: FontUtils.h18(
            fontColor: ColorUtils.themeColor.oxffFFFFFF,
            fontWeight: FWT.semiBold,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      LocaleKeys.LoanApplicationProcess.tr(),
                      style: FontUtils.h14(fontWeight: FWT.medium),
                    ),
                  ),
                  const Divider(thickness: 2),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: loanProcess.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return loanProcess[index]['img'] == '' && index == 9
                            ? Column(
                                children: [
                                  fbNativeAd1,
                                  adxNativeAd1 == null ||
                                          _isAdxNativeAdLoaded1 == false
                                      ? const SizedBox()
                                      : Container(
                                          color: Colors.transparent,
                                          height: 370,
                                          alignment: Alignment.center,
                                          child: AdWidget(ad: adxNativeAd1!),
                                        ),
                                ],
                              )
                            : loanProcess[index]['img'] == '' && index == 4
                                ? isFacebookAdsShow
                                    ? fbNativeAd
                                    : adxNativeAd == null ||
                                            _isAdxNativeAdLoaded == false
                                        ? const SizedBox()
                                        : Container(
                                            color: Colors.transparent,
                                            height: 340,
                                            alignment: Alignment.center,
                                            child: AdWidget(ad: adxNativeAd!),
                                          )
                                : Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 30),
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: ColorUtils
                                                        .themeColor.oxff673AB7,
                                                    width: 2),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 12,
                                                    vertical: 12,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const SizedBox(
                                                          height: 30),
                                                      Text(
                                                        loanProcess[index]
                                                                ['step'] ??
                                                            '',
                                                        style: FontUtils.h16(
                                                            fontWeight:
                                                                FWT.bold,
                                                            fontColor: ColorUtils
                                                                .themeColor
                                                                .oxff101523),
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Text(
                                                        loanProcess[index]
                                                                ['guide'] ??
                                                            '',
                                                        style: FontUtils.h14(
                                                            fontWeight:
                                                                FWT.medium),
                                                      ),
                                                    ],
                                                  )),
                                            ),
                                            Positioned(
                                              top: -20,
                                              left: 20,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color:
                                                      ColorUtils().greyBGColor,
                                                  border: Border.all(
                                                      color: ColorUtils
                                                          .themeColor
                                                          .oxff673AB7,
                                                      width: 2),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 8,
                                                      horizontal: 12),
                                                  child: Text(
                                                    '${LocaleKeys.STEP.tr()} : ${loanProcess[index]['step_count']}',
                                                    style: FontUtils.h14(
                                                        fontWeight:
                                                            FWT.semiBold),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 10,
                                              right: 20,
                                              child: Image(
                                                image: AssetImage(
                                                    loanProcess[index]['img'] ??
                                                        ''),
                                                height: 60,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                      },
                    ),
                  ),
                  CenterTextButtonWidget(
                    title: LocaleKeys.NEXT.tr(),
                    onTap: () {
                      final provider =
                          Provider.of<InterstitialAdsWidgetProvider>(context,
                              listen: false);
                      if (receiver != null) {
                        receiver.cancel();
                      }

                      provider.showFbOrAdxOrAdmobInterstitialAd(
                        myAdsIdClass: myAdsIdClass,
                        availableAds: myAdsIdClass.availableAdsList,
                        RouteUtils.clarificationScreen,
                        context,
                        fbInterID: myAdsIdClass.facebookInterstitialId,
                        googleInterID: myAdsIdClass.googleInterstitialId,
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, String>> loanProcess = [
    {
      'step_count': "1",
      'img': AssetUtils.fillApp,
      'step': LocaleKeys.step1.tr(),
      'guide': LocaleKeys.step1Guide.tr(),
    },
    {
      'step_count': "2",
      'img': AssetUtils.decide,
      'step': LocaleKeys.step2.tr(),
      'guide': LocaleKeys.step2Guide.tr(),
    },
    {
      'step_count': "3",
      'img': AssetUtils.research,
      'step': LocaleKeys.step3.tr(),
      'guide': LocaleKeys.step3Guide.tr(),
    },
    {
      'step_count': "4",
      'img': AssetUtils.gather,
      'step': LocaleKeys.step4.tr(),
      'guide': LocaleKeys.step4Guide.tr(),
    },
    {
      'img': '',
    },
    {
      'step_count': "5",
      'img': AssetUtils.fillApp,
      'step': LocaleKeys.step5.tr(),
      'guide': LocaleKeys.step5Guide.tr(),
    },
    {
      'step_count': "6",
      'img': AssetUtils.submit,
      'step': LocaleKeys.step7.tr(),
      'guide': LocaleKeys.step7Guide.tr(),
    },
    {
      'step_count': "7",
      'img': AssetUtils.decision,
      'step': LocaleKeys.step8.tr(),
      'guide': LocaleKeys.step8Guide.tr(),
    },
    {
      'step_count': "8",
      'img': AssetUtils.receiveFunds,
      'step': LocaleKeys.step9.tr(),
      'guide': LocaleKeys.step9Guide.tr(),
    },
    {
      'step_count': "",
      'img': '',
      'step': LocaleKeys.step1.tr(),
      'guide': LocaleKeys.step1Guide.tr(),
    },
  ];
}
