import 'package:action_broadcast/action_broadcast.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:instant_pay/utilities/assets/asset_utils.dart';
import 'package:instant_pay/utilities/colors/color_utils.dart';
import 'package:instant_pay/utilities/font/font_utils.dart';
import 'package:instant_pay/utilities/routes/routes.dart';
import 'package:instant_pay/utilities/storage/storage.dart';
import 'package:instant_pay/view/screen/dashboard/home/loan_short_description_screen.dart';
import 'package:instant_pay/view/screen/dashboard/home/model/available_ads_response.dart';
import 'package:instant_pay/view/widget/ads_widget/interstitial_ads_widget.dart';
import 'package:instant_pay/view/widget/ads_widget/load_ads_by_api.dart';
import 'package:instant_pay/view/widget/center_text_button_widget.dart';
import 'package:provider/provider.dart';

class CaseStudyScreen extends StatefulWidget {
  final LoanDescriptionArguments arguments;
  const CaseStudyScreen({super.key, required this.arguments});

  @override
  State<CaseStudyScreen> createState() => _CaseStudyScreenState();
}

class _CaseStudyScreenState extends State<CaseStudyScreen> {
  String screenName = "CaseStudy";
  late StreamSubscription receiver;

  String appBarTitle = "CaseStudy";
  String reasonToTakeLoan = "CaseStudy";
  String reasonToNotTakeLoan = "CaseStudy";

  bool isFacebookAdsShow = StorageUtils.prefs.getBool(StorageKeyUtils.isShowFacebookAds) ?? false;
  bool isADXAdsShow = StorageUtils.prefs.getBool(StorageKeyUtils.isShowADXAds) ?? false;
  bool isAdmobAdsShow = StorageUtils.prefs.getBool(StorageKeyUtils.isShowAdmobAds) ?? false;
  bool isAdShow = StorageUtils.prefs.getBool(StorageKeyUtils.isAddShowInApp) ?? false;

  bool isCheckScreen = StorageUtils.prefs.getBool(StorageKeyUtils.isCheckScreenForAdInApp) ?? false;

  // List<String> availableAdsList = [];
  MyAdsIdClass myAdsIdClass = MyAdsIdClass();

  @override
  void initState() {
    initReceiver();
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (!kDebugMode) {
        await FirebaseAnalytics.instance.logEvent(name: screenName);
      }
      int prefferedLanguage = StorageUtils.prefs.getInt(StorageKeyUtils.applicationLanguageState) ?? 0;
      if (prefferedLanguage == 0) {
        appBarTitle = 'Case Study On ${widget.arguments.loanName}';
        reasonToTakeLoan = 'Benefits of taking a ${widget.arguments.loanName}';
        reasonToNotTakeLoan = 'Disadvantages of taking a ${widget.arguments.loanName}';
      } else {
        appBarTitle = '${widget.arguments.loanName} पर केस स्टडी';
        reasonToTakeLoan = '${widget.arguments.loanName} लेने के फायदे';
        reasonToNotTakeLoan = '${widget.arguments.loanName} लेने के नुकसान';
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

  Widget fbNativeBannerAd = const SizedBox();
  Widget fbNativeAd1 = const SizedBox();
  _showFBNativeAd({required String isCalledFrom}) {
    bool isFailedTwiceToLoadFbAdId = StorageUtils.prefs.getBool('${StorageKeyUtils.isFailedTwiceToLoadFbAdId}${myAdsIdClass.facebookNativeId}') ?? false;

    if (myAdsIdClass.facebookNativeId.isEmpty || isFailedTwiceToLoadFbAdId) {
      loadAdxNativeAd(isCalledFrom: isCalledFrom);
    } else {
      setState(() {
        fbNativeAd1 = loadFbNativeAd(myAdsIdClass.facebookNativeId);
        // fbNativeBannerAd = loadFbNativeAd(myAdsIdClass.facebookNativeId);
      });
      // updatePrefsResponse(adType: 'Native');
    }
  }

  // _showFBNativeAd() {
  //   setState(() {
  //     fbNativeAd1 = loadFbNativeAd(myAdsIdClass.facebookNativeId);
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
          fbNativeAd1 = const SizedBox();
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
            appBarTitle,
            style: FontUtils.h18(
              fontColor: ColorUtils.themeColor.oxffFFFFFF,
              fontWeight: FWT.semiBold,
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // fbNativeBannerAd,
                    // adxNativeBannerAd == null ||  _isAdxNativeBannerAdLoaded == false
                    //     ? const SizedBox()
                    //     : Container(
                    //         color: Colors.transparent,
                    //         height: 140,
                    //         alignment: Alignment.center,
                    //         child: AdWidget(ad: adxNativeBannerAd!),
                    //       ),
                    const SizedBox(height: 10),
                    Text(
                      reasonToTakeLoan,
                      style: FontUtils.h14(fontColor: ColorUtils.themeColor.oxff000000, fontWeight: FWT.bold),
                      textAlign: TextAlign.center,
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        const Positioned(
                          child: Opacity(
                            opacity: 0.2,
                            child: Image(
                              image: AssetImage(AssetUtils.greenCheck),
                              height: 200,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: DottedBorder(
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(20),
                            dashPattern: const [10, 10],
                            padding: EdgeInsets.zero,
                            color: Colors.green,
                            strokeWidth: 2,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: widget.arguments.take!.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    child: RichText(
                                      text: TextSpan(
                                        text: widget.arguments.takePoints![index],
                                        style: FontUtils.h16(fontWeight: FWT.bold, fontColor: Colors.green),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: ' : ',
                                            style: FontUtils.h16(fontWeight: FWT.bold, fontColor: Colors.green),
                                          ),
                                          TextSpan(
                                            text: widget.arguments.take![index],
                                            style: FontUtils.h12(fontWeight: FWT.medium),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    fbNativeAd1,
                    adxNativeAd == null || _isAdxNativeAdLoaded == false
                        ? const SizedBox()
                        : Container(
                            color: Colors.transparent,
                            height: 275,
                            alignment: Alignment.center,
                            child: AdWidget(ad: adxNativeAd!),
                          ),
                    const SizedBox(height: 10),
                    Text(
                      reasonToNotTakeLoan,
                      style: FontUtils.h14(fontColor: ColorUtils.themeColor.oxff000000, fontWeight: FWT.bold),
                      textAlign: TextAlign.center,
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        const Positioned(
                          child: Opacity(
                            opacity: 0.2,
                            child: Image(
                              image: AssetImage(AssetUtils.cancelCheck),
                              height: 200,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: DottedBorder(
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(20),
                            dashPattern: const [10, 10],
                            padding: EdgeInsets.zero,
                            color: Colors.red,
                            strokeWidth: 2,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: widget.arguments.notTake!.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    child: RichText(
                                      text: TextSpan(
                                        text: widget.arguments.notTakePoints![index],
                                        style: FontUtils.h16(fontWeight: FWT.bold, fontColor: Colors.red),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: ' : ',
                                            style: FontUtils.h16(fontWeight: FWT.bold, fontColor: Colors.red),
                                          ),
                                          TextSpan(
                                            text: widget.arguments.notTake![index],
                                            style: FontUtils.h12(fontWeight: FWT.medium),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                    CenterTextButtonWidget(
                      title: 'NEXT',
                      onTap: () {
                        if (widget.arguments.isFromInvest == true) {
                          final provider = Provider.of<InterstitialAdsWidgetProvider>(context, listen: false);
                          receiver.cancel();

                          provider.showFbOrAdxOrAdmobInterstitialAd(
                            myAdsIdClass: myAdsIdClass,
                            availableAds: myAdsIdClass.availableAdsList,
                            RouteUtils.clarificationScreen,
                            context,
                            fbInterID: myAdsIdClass.facebookInterstitialId,
                            googleInterID: myAdsIdClass.googleInterstitialId,
                          );
                        } else {
                          final provider = Provider.of<InterstitialAdsWidgetProvider>(context, listen: false);
                          receiver.cancel();

                          provider.showFbOrAdxOrAdmobInterstitialAd(
                            myAdsIdClass: myAdsIdClass,
                            availableAds: myAdsIdClass.availableAdsList,
                            RouteUtils.loanApplicationProcess,
                            context,
                            fbInterID: myAdsIdClass.facebookInterstitialId,
                            googleInterID: myAdsIdClass.googleInterstitialId,
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

// class TakingLoanReasonScreenArguments {
//   final String? loanName;
//   final List<String>? takePoints;
//   final List<String>? take;
//   final List<String>? notTakePoints;
//   final List<String>? notTake;
//   final bool? isFromInvest;
//   TakingLoanReasonScreenArguments({this.takePoints, this.notTakePoints, this.loanName, this.take, this.notTake, this.isFromInvest = false});
// }
