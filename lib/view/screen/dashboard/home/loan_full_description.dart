import 'package:action_broadcast/action_broadcast.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:instant_pay/utilities/colors/color_utils.dart';
import 'package:instant_pay/utilities/font/font_utils.dart';
import 'package:instant_pay/utilities/routes/route_utils.dart';
import 'package:instant_pay/utilities/storage/storage.dart';
import 'package:instant_pay/view/screen/dashboard/home/loan_short_description_screen.dart';
import 'package:instant_pay/view/screen/dashboard/home/model/available_ads_response.dart';
import 'package:instant_pay/view/widget/ads_widget/interstitial_ads_widget.dart';
import 'package:instant_pay/view/widget/ads_widget/load_ads_by_api.dart';
import 'package:instant_pay/view/widget/center_text_button_widget.dart';
import 'package:provider/provider.dart';

class LoanFullDescriptionScreen extends StatefulWidget {
  final LoanDescriptionArguments arguments;
  const LoanFullDescriptionScreen({super.key, required this.arguments});

  @override
  State<LoanFullDescriptionScreen> createState() => _LoanFullDescriptionScreenState();
}

class _LoanFullDescriptionScreenState extends State<LoanFullDescriptionScreen> {
  String screenName = "LoanDetails";
  // List<String> availableAdsList = [];
  MyAdsIdClass myAdsIdClass = MyAdsIdClass();
  bool isFacebookAdsShow = StorageUtils.prefs.getBool(StorageKeyUtils.isShowFacebookAds) ?? false;
  bool isADXAdsShow = StorageUtils.prefs.getBool(StorageKeyUtils.isShowADXAds) ?? false;
  bool isAdmobAdsShow = StorageUtils.prefs.getBool(StorageKeyUtils.isShowAdmobAds) ?? false;
  bool isAdShow = StorageUtils.prefs.getBool(StorageKeyUtils.isAddShowInApp) ?? false;
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
      setState(() {});
      if (myAdsIdClass.availableAdsList.contains("Native")) {
        // if (isFacebookAdsShow) {
        //   _showFbNativeAd();
        // }
        // if (isAdmobAdsShow || isADXAdsShow) {
        //   loadNativeOrNativeBannerAdsForFile(adsType: "Native");
        // }
        if (isCheckScreen) {
          _showFBNativeAd(isCalledFrom: 'isCheckScreen');
        } else {
          if (myAdsIdClass.isFacebook && isFacebookAdsShow) {
            _showFBNativeAd(isCalledFrom: 'else isCheckScreen ');
          }
          if (myAdsIdClass.isGoogle && isADXAdsShow) {
            loadNativeOrNativeBannerAdsForFile();
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

  @override
  void dispose() {
    print("Receiver stopped");
    receiver.cancel();

    super.dispose();
  }

  Widget fbNativeAd1 = const SizedBox();
  Widget fbNativeAd2 = const SizedBox();
  Widget fbNativeAd3 = const SizedBox();
  Widget fbNativeAd4 = const SizedBox();
  _showFBNativeAd({required String isCalledFrom}) {
    bool isFailedTwiceToLoadFbAdId = StorageUtils.prefs.getBool('${StorageKeyUtils.isFailedTwiceToLoadFbAdId}${myAdsIdClass.facebookNativeId}') ?? false;

    if (myAdsIdClass.facebookNativeId.isEmpty || isFailedTwiceToLoadFbAdId) {
      loadNativeOrNativeBannerAdsForFile();
    } else {
      setState(() {
        fbNativeAd1 = loadFbNativeAd(myAdsIdClass.facebookNativeId);
        fbNativeAd2 = loadFbNativeAd(myAdsIdClass.facebookNativeId);
        fbNativeAd3 = loadFbNativeAd(myAdsIdClass.facebookNativeId);
        fbNativeAd4 = loadFbNativeAd(myAdsIdClass.facebookNativeId);
      });
      // updatePrefsResponse(adType: 'Native');
    }
  }
  // _showFbNativeAd() {
  //   setState(() {
  //     fbNativeAd1 = loadFbNativeAd(myAdsIdClass.facebookNativeId);
  //     fbNativeAd2 = loadFbNativeAd(myAdsIdClass.facebookNativeId);
  //     fbNativeAd3 = loadFbNativeAd(myAdsIdClass.facebookNativeId);
  //     fbNativeAd3 = loadFbNativeAd(myAdsIdClass.facebookNativeId);
  //   });
  //   updatePrefsResponse(adType: 'Native');
  // }

  loadNativeOrNativeBannerAdsForFile({String isCalledFrom = 'init'}) {
    loadAdxNativeAd1(isCalledFrom: isCalledFrom);
    loadAdxNativeAd2(isCalledFrom: isCalledFrom);
    loadAdxNativeAd3(isCalledFrom: isCalledFrom);
    loadAdxNativeAd4(isCalledFrom: isCalledFrom);
  }

  updatePrefsResponse() {
    Timer(const Duration(seconds: 1), () {
      isFacebookAdsShow = StorageUtils.prefs.getBool(StorageKeyUtils.isShowFacebookAds) ?? false;
      isADXAdsShow = StorageUtils.prefs.getBool(StorageKeyUtils.isShowADXAds) ?? false;
      isAdmobAdsShow = StorageUtils.prefs.getBool(StorageKeyUtils.isShowAdmobAds) ?? false;
      isAdShow = StorageUtils.prefs.getBool(StorageKeyUtils.isAddShowInApp) ?? false;
      setState(() {});
      if (isAdmobAdsShow) {
        setState(() {
          fbNativeAd1 = const SizedBox();
          fbNativeAd2 = const SizedBox();
          fbNativeAd3 = const SizedBox();
          fbNativeAd4 = const SizedBox();
        });

        loadNativeOrNativeBannerAdsForFile();
      }
    });
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
            loadNativeOrNativeBannerAdsForFile(isCalledFrom: 'loadFbNativeAd');
          }
        }
      },
      keepExpandedWhileLoading: false,
    );
  }

  NativeAd? adxNativeAd1;
  bool _isAdxNativeAd1Loaded = false;

  NativeAd? adxNativeAd2;
  bool _isAdxNativeAd2Loaded = false;

  NativeAd? adxNativeAd3;
  bool _isAdxNativeAd3Loaded = false;

  NativeAd? adxNativeAd4;
  bool _isAdxNativeAd4Loaded = false;

  loadAdxNativeAd1({String isCalledFrom = 'init'}) async {
    print('Screen name loadNativeAd() ---> $screenName isCalledFrom --> $isCalledFrom ');

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
                adxNativeAd1 = ad as NativeAd;
                _isAdxNativeAd1Loaded = true;
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

  loadAdxNativeAd2({String isCalledFrom = 'init'}) async {
    print('Screen name loadNativeAd2() ---> $screenName isCalledFrom --> $isCalledFrom ');

    String nativeAdId = myAdsIdClass.googleNativeId;
    // AdsUnitId().getGoogleNativeAdId();
    if (nativeAdId != '') {
      setState(() {
        adxNativeAd2 = NativeAd(
          adUnitId: nativeAdId,
          factoryId: 'listTileMedium',
          request: const AdRequest(),
          listener: NativeAdListener(
            onAdLoaded: (ad) {
              setState(() {
                _isAdxNativeAd2Loaded = true;
                adxNativeAd2 = ad as NativeAd;
              });
            },
            onAdFailedToLoad: (ad, error) {
              ad.dispose();
            },
          ),
        );
        adxNativeAd2!.load();
      });
    }
  }

  loadAdxNativeAd3({String isCalledFrom = 'init'}) async {
    print('Screen name loadNativeAd3() ---> $screenName isCalledFrom --> $isCalledFrom');

    String nativeAdId = myAdsIdClass.googleNativeId;
    // AdsUnitId().getGoogleNativeAdId();
    if (nativeAdId != '') {
      setState(() {
        adxNativeAd3 = NativeAd(
          adUnitId: nativeAdId,
          factoryId: 'listTileMedium',
          request: const AdRequest(),
          listener: NativeAdListener(
            onAdLoaded: (ad) {
              setState(() {
                _isAdxNativeAd3Loaded = true;
                adxNativeAd3 = ad as NativeAd;
              });
            },
            onAdFailedToLoad: (ad, error) {
              ad.dispose();
            },
          ),
        );
        adxNativeAd3!.load();
      });
    }
  }

  loadAdxNativeAd4({String isCalledFrom = 'init'}) async {
    print('Screen name loadNativeAd4() ---> $screenName isCalledFrom --> $isCalledFrom ');

    String nativeAdId = myAdsIdClass.googleNativeId;
    // AdsUnitId().getGoogleNativeAdId();
    if (nativeAdId != '') {
      setState(() {
        adxNativeAd4 = NativeAd(
          adUnitId: nativeAdId,
          factoryId: 'listTileMedium',
          request: const AdRequest(),
          listener: NativeAdListener(
            onAdLoaded: (ad) {
              setState(() {
                _isAdxNativeAd4Loaded = true;
                adxNativeAd4 = ad as NativeAd;
              });
            },
            onAdFailedToLoad: (ad, error) {
              ad.dispose();
            },
          ),
        );
        adxNativeAd4!.load();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
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
          widget.arguments.loanName ?? '',
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
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Image(
                    image: AssetImage(widget.arguments.imgURl ?? ''),
                    width: screenSize.width,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 10),
                  fbNativeAd4,
                  _isAdxNativeAd4Loaded == false
                      ? const SizedBox()
                      : Container(
                          color: Colors.transparent,
                          height: 275,
                          alignment: Alignment.center,
                          child: AdWidget(ad: adxNativeAd4!),
                        ),
                  const SizedBox(height: 20),
                  loanWidget(widget.arguments.lable1 ?? '', widget.arguments.description1 ?? ''),
                  sizedBox5(),
                  const SizedBox(height: 10),
                  fbNativeAd1,
                  _isAdxNativeAd1Loaded == false
                      ? const SizedBox()
                      : Container(
                          color: Colors.transparent,
                          height: 275,
                          alignment: Alignment.center,
                          child: AdWidget(ad: adxNativeAd1!),
                        ),
                  sizedBox5(),
                  loanWidget(widget.arguments.lable2 ?? '', widget.arguments.description2 ?? ''),
                  sizedBox5(),
                  const SizedBox(height: 10),
                  fbNativeAd2,
                  _isAdxNativeAd2Loaded == false
                      ? const SizedBox()
                      : Container(
                          color: Colors.transparent,
                          height: 275,
                          alignment: Alignment.center,
                          child: AdWidget(ad: adxNativeAd2!),
                        ),
                  sizedBox5(),
                  loanWidget(widget.arguments.lable3 ?? '', widget.arguments.description3 ?? ''),
                  sizedBox5(),
                  const SizedBox(height: 10),
                  fbNativeAd3,
                  _isAdxNativeAd3Loaded == false
                      ? const SizedBox()
                      : Container(
                          color: Colors.transparent,
                          height: 275,
                          alignment: Alignment.center,
                          child: AdWidget(ad: adxNativeAd3!),
                        ),
                  sizedBox5(),
                  loanWidget(widget.arguments.lable4 ?? '', widget.arguments.description4 ?? ''),
                  sizedBox5(),
                  // fbNativeAd4,
                  // adxNativeAd4 == null || _isAdxNativeAd4Loaded == false
                  //     ? const SizedBox()
                  //     : Container(
                  //         color: Colors.transparent,
                  //         height: 275,
                  //         alignment: Alignment.center,
                  //         child: AdWidget(ad: adxNativeAd4!),
                  //       ),
                  CenterTextButtonWidget(
                    title: widget.arguments.buttonLable ?? '',
                    onTap: () {
                      receiver.cancel();
                      getRoute();
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  getRoute() {
    final provider = Provider.of<InterstitialAdsWidgetProvider>(context, listen: false);
    return provider.showFbOrAdxOrAdmobInterstitialAd(
      availableAds: myAdsIdClass.availableAdsList,
      myAdsIdClass: myAdsIdClass,
      RouteUtils.takingLoanReasonScreen,
      context,
      arguments: widget.arguments,
      fbInterID: myAdsIdClass.facebookInterstitialId,
      googleInterID: myAdsIdClass.googleInterstitialId,
    );
  }

  Widget loanWidget(String title, String subTitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: ColorUtils.themeColor.oxff000000),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                title,
                style: FontUtils.h16(fontColor: ColorUtils.themeColor.oxff447D58, fontWeight: FWT.bold),
              ),
              const SizedBox(height: 10),
              Text(
                subTitle,
                style: FontUtils.h14(fontColor: ColorUtils.themeColor.oxff101523, fontWeight: FWT.medium),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget sizedBox5() {
    return const SizedBox(height: 5);
  }
}
