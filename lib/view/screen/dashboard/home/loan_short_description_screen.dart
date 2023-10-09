// ignore_for_file: void_checks

import 'package:action_broadcast/action_broadcast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:instant_pay/l10n/locale_keys.g.dart';
import 'package:instant_pay/utilities/colors/color_utils.dart';
import 'package:instant_pay/utilities/font/font_utils.dart';
import 'package:instant_pay/utilities/routes/route_utils.dart';
import 'package:instant_pay/utilities/storage/storage.dart';
import 'package:instant_pay/view/screen/dashboard/home/model/available_ads_response.dart';
import 'package:instant_pay/view/widget/ads_widget/interstitial_ads_widget.dart';
import 'package:instant_pay/view/widget/ads_widget/load_ads_by_api.dart';
import 'package:instant_pay/view/widget/center_text_button_widget.dart';
import 'package:provider/provider.dart';

class LoanShortDescriptionScreen extends StatefulWidget {
  final LoanDescriptionArguments arguments;
  const LoanShortDescriptionScreen({super.key, required this.arguments});

  @override
  State<LoanShortDescriptionScreen> createState() => _LoanShortDescriptionScreenState();
}

class _LoanShortDescriptionScreenState extends State<LoanShortDescriptionScreen> {
  String screenName = 'LoanKeyFeatures';

  bool isFacebookAdsShow = StorageUtils.prefs.getBool(StorageKeyUtils.isShowFacebookAds) ?? false;
  bool isADXAdsShow = StorageUtils.prefs.getBool(StorageKeyUtils.isShowADXAds) ?? false;
  bool isAdmobAdsShow = StorageUtils.prefs.getBool(StorageKeyUtils.isShowAdmobAds) ?? false;
  bool isAdShow = StorageUtils.prefs.getBool(StorageKeyUtils.isAddShowInApp) ?? false;
  // List<String> availableAdsList = [];
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

      myAdsIdClass = await LoadAdsByApi().isAvailableAds(context: context, screenName: screenName);
      setState(() {});
      if (myAdsIdClass.availableAdsList.contains("Native")) {
        // if (isFacebookAdsShow) {
        //   _showFBNativeAd();
        // }
        // if (isAdmobAdsShow || isADXAdsShow) {
        //   loadAdxNativeAd();
        //   loadAdxNativeAd1();
        // }

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
            print('screenName $screenName === isCheckScreen -- $isCheckScreen === myAdsIdClass.isFacebook -- ${myAdsIdClass.isFacebook} === isFacebookAdsShow -- $isFacebookAdsShow === myAdsIdClass.isGoogle -- ${myAdsIdClass.isGoogle} === isADXAdsShow -- $isADXAdsShow');
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
    bool isFailedTwiceToLoadFbAdId = StorageUtils.prefs.getBool('${StorageKeyUtils.isFailedTwiceToLoadFbAdId}${myAdsIdClass.facebookNativeId}') ?? false;

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
      isFacebookAdsShow = StorageUtils.prefs.getBool(StorageKeyUtils.isShowFacebookAds) ?? false;
      isADXAdsShow = StorageUtils.prefs.getBool(StorageKeyUtils.isShowADXAds) ?? false;
      isAdmobAdsShow = StorageUtils.prefs.getBool(StorageKeyUtils.isShowAdmobAds) ?? false;
      isAdShow = StorageUtils.prefs.getBool(StorageKeyUtils.isAddShowInApp) ?? false;
      setState(() {});
      if (isAdmobAdsShow) {
        setState(() {
          fbNativeAd = const SizedBox();
          fbNativeAd1 = const SizedBox();
        });
        if (adType == "Native") {
          loadAdxNativeAd();
          loadAdxNativeAd1();
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    receiver.cancel();

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
    print('Screen name loadNativeAd() ---> $screenName isCalledFrom --> $isCalledFrom ');

    String nativeAdId = myAdsIdClass.googleNativeId;
    // AdsUnitId().getGoogleNativeAdId();
    if (nativeAdId != '') {
      setState(() {
        adxNativeAd = NativeAd(
          adUnitId: nativeAdId,
          factoryId: 'listTileMedium',
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
    print('Screen name loadNativeAd1() ---> $screenName isCalledFrom --> $isCalledFrom ');

    String nativeAdId = myAdsIdClass.googleNativeId;
    // AdsUnitId().getGoogleNativeAdId();
    if (nativeAdId != '') {
      setState(() {
        adxNativeAd1 = NativeAd(
          adUnitId: nativeAdId,
          factoryId: 'listTileMedium',
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

  @override
  Widget build(BuildContext context) {
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
          LocaleKeys.KeyFeatures.tr(),
          // 'Key Features',
          style: FontUtils.h18(fontColor: ColorUtils.themeColor.oxffFFFFFF, fontWeight: FWT.semiBold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      widget.arguments.subTitle ?? '',
                      style: FontUtils.h14(
                        fontWeight: FWT.semiBold,
                        fontColor: ColorUtils.themeColor.oxff858494,
                      ),
                    ),
                  ),
                  const Divider(thickness: 2),
                  const SizedBox(height: 10),
                  fbNativeAd1,
                  adxNativeAd1 == null || _isAdxNativeAdLoaded1 == false
                      ? const SizedBox()
                      : Container(
                          color: Colors.transparent,
                          height: 275,
                          alignment: Alignment.center,
                          child: AdWidget(ad: adxNativeAd1!),
                        ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        const Icon(Icons.document_scanner_outlined),
                        const SizedBox(width: 10),
                        Text(
                          // 'Documents',
                          LocaleKeys.Documents.tr(),
                          style: FontUtils.h16(
                            fontWeight: FWT.semiBold,
                            fontColor: ColorUtils.themeColor.oxff101523,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      widget.arguments.documents ?? '',
                      style: FontUtils.h14(
                        fontWeight: FWT.semiBold,
                        fontColor: ColorUtils.themeColor.oxff858494,
                      ),
                    ),
                  ),
                  const Divider(thickness: 2),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        const Icon(Icons.thumb_up_off_alt),
                        const SizedBox(width: 10),
                        Text(
                          // 'Criteria',
                          LocaleKeys.Criteria.tr(),
                          style: FontUtils.h16(
                            fontWeight: FWT.semiBold,
                            fontColor: ColorUtils.themeColor.oxff101523,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      widget.arguments.eligibilityCriteria ?? '',
                      style: FontUtils.h14(
                        fontWeight: FWT.semiBold,
                        fontColor: ColorUtils.themeColor.oxff858494,
                      ),
                    ),
                  ),
                  const Divider(thickness: 2),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        const Icon(Icons.thumb_up_off_alt),
                        const SizedBox(width: 10),
                        Text(
                          // 'Tenure',
                          LocaleKeys.Tenure.tr(),
                          style: FontUtils.h16(
                            fontWeight: FWT.semiBold,
                            fontColor: ColorUtils.themeColor.oxff101523,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      widget.arguments.tenureDescription ?? '',
                      style: FontUtils.h14(
                        fontWeight: FWT.semiBold,
                        fontColor: ColorUtils.themeColor.oxff858494,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  fbNativeAd,
                  adxNativeAd == null || _isAdxNativeAdLoaded == false
                      ? const SizedBox()
                      : Container(
                          color: Colors.transparent,
                          height: 275,
                          alignment: Alignment.center,
                          child: AdWidget(ad: adxNativeAd!),
                        ),
                  const Divider(thickness: 2),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        const Icon(Icons.percent),
                        const SizedBox(width: 10),
                        Text(
                          // 'Interest',
                          LocaleKeys.Interest.tr(),
                          style: FontUtils.h16(
                            fontWeight: FWT.semiBold,
                            fontColor: ColorUtils.themeColor.oxff101523,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      widget.arguments.interest ?? '',
                      style: FontUtils.h14(
                        fontWeight: FWT.semiBold,
                        fontColor: ColorUtils.themeColor.oxff858494,
                      ),
                    ),
                  ),
                  const Divider(thickness: 2),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        const Icon(Icons.money),
                        const SizedBox(width: 10),
                        Text(
                          // 'Loan Amount',
                          LocaleKeys.LoanAmount.tr(),
                          style: FontUtils.h16(
                            fontWeight: FWT.semiBold,
                            fontColor: ColorUtils.themeColor.oxff101523,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      widget.arguments.loanAmount ?? '',
                      style: FontUtils.h14(
                        fontWeight: FWT.semiBold,
                        fontColor: ColorUtils.themeColor.oxff858494,
                      ),
                    ),
                  ),
                  const Divider(thickness: 2),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        const Icon(Icons.feed_sharp),
                        const SizedBox(width: 10),
                        Text(
                          // 'Processing Fees',
                          LocaleKeys.ProcessingFees.tr(),
                          style: FontUtils.h16(
                            fontWeight: FWT.semiBold,
                            fontColor: ColorUtils.themeColor.oxff101523,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      widget.arguments.processingFees ?? '',
                      style: FontUtils.h14(
                        fontWeight: FWT.semiBold,
                        fontColor: ColorUtils.themeColor.oxff858494,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Align(
                    alignment: Alignment.center,
                    child: CenterTextButtonWidget(
                      title: LocaleKeys.ContinueApplication.tr(),
                      onTap: () {
                        final provider = Provider.of<InterstitialAdsWidgetProvider>(context, listen: false);
                        receiver.cancel();

                        return provider.showFbOrAdxOrAdmobInterstitialAd(
                          myAdsIdClass: myAdsIdClass,
                          availableAds: myAdsIdClass.availableAdsList,
                          RouteUtils.loanFullDescriptionScreen,
                          context,
                          arguments: widget.arguments,
                          fbInterID: myAdsIdClass.facebookInterstitialId,
                          googleInterID: myAdsIdClass.googleInterstitialId,
                        );
                      },
                    ),
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
}

class LoanDescriptionArguments {
  final String? subTitle;
  final String? documents;
  final String? eligibilityCriteria;
  final String? loanAmount;
  final String? tenureDescription;
  final String? interest;
  final String? processingFees;
  final String? imgURl;
  final String? lable1;
  final String? description1;
  final String? lable2;
  final String? description2;
  final String? lable3;
  final String? description3;
  final String? lable4;
  final String? description4;
  final String? buttonLable;
  final String? loanName;
  final List<String>? takePoints;
  final List<String>? take;
  final List<String>? notTakePoints;
  final List<String>? notTake;
  final bool? isFromInvest;
  final List<String>? imgList;
  final List<String>? titleList;
  final List<String>? titleOverViewList;
  final bool? isAdvantage;
  final String? investmentName;
  final String? investmentSortDetails;
  final String? investmentDescription1;
  final String? investmentDescription2;
  final String? investmentLoanName;

  LoanDescriptionArguments({
    this.subTitle,
    this.documents,
    this.eligibilityCriteria,
    this.loanAmount,
    this.tenureDescription,
    this.interest,
    this.processingFees,
    this.imgURl,
    this.lable1,
    this.description1,
    this.lable2,
    this.description2,
    this.lable3,
    this.description3,
    this.lable4,
    this.description4,
    this.buttonLable,
    this.loanName,
    this.takePoints,
    this.take,
    this.notTakePoints,
    this.notTake,
    this.isFromInvest,
    this.imgList,
    this.titleList,
    this.titleOverViewList,
    this.isAdvantage,
    this.investmentName,
    this.investmentSortDetails,
    this.investmentDescription1,
    this.investmentDescription2,
    this.investmentLoanName,
  });
}
