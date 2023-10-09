// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:action_broadcast/action_broadcast.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:instant_pay/utilities/colors/color_utils.dart';
// import 'package:instant_pay/utilities/font/font_utils.dart';
// import 'package:instant_pay/utilities/routes/route_utils.dart';
// import 'package:instant_pay/utilities/storage/storage.dart';
// import 'package:instant_pay/view/screen/dashboard/home/model/available_ads_response.dart';
// import 'package:instant_pay/view/widget/ads_widget/fb_native_add.dart';
// import 'package:instant_pay/view/widget/ads_widget/interstitial_ads_widget.dart';
// import 'package:instant_pay/view/widget/ads_widget/load_ads_by_api.dart';
// import 'package:instant_pay/view/widget/bounce_click_widget.dart';
// import 'package:provider/provider.dart';

// class ExploreMoreScreen extends StatefulWidget {
//   const ExploreMoreScreen({super.key});

//   @override
//   State<ExploreMoreScreen> createState() => _ExploreMoreScreenState();
// }

// class _ExploreMoreScreenState extends State<ExploreMoreScreen> {
//   String screenName = 'GetMoreLoan';

//   bool isFacebookAdsShow =
//       StorageUtils.prefs.getBool(StorageKeyUtils.isShowFacebookAds) ?? false;
//   bool isADXAdsShow =
//       StorageUtils.prefs.getBool(StorageKeyUtils.isShowADXAds) ?? false;
//   bool isAdmobAdsShow =
//       StorageUtils.prefs.getBool(StorageKeyUtils.isShowAdmobAds) ?? false;
//   bool isAdShow =
//       StorageUtils.prefs.getBool(StorageKeyUtils.isAddShowInApp) ?? false;

//   // List<String> availableAdsList = [];
//   MyAdsIdClass myAdsIdClass = MyAdsIdClass();

//   BroadcastReceiver receiver = BroadcastReceiver(
//     names: <String>["LoadAd"],
//   );

//   @override
//   void initState() {
//     super.initState();
//     initReceiver();

//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
//       final provider =
//           Provider.of<InterstitialAdsWidgetProvider>(context, listen: false);

//       myAdsIdClass = await LoadAdsByApi()
//           .isAvailableAds(context: context, screenName: screenName);
//       setState(() {});
//       // print("ABC __> $availableAdsList");
//       if (myAdsIdClass.availableAdsList.contains("Native")) {
//         if (isFacebookAdsShow) {
//           _showFBNativeAd();
//         }
//         if (isAdmobAdsShow || isADXAdsShow) {
//           loadAdxNativeAd();
//         }
//       }

//       if (myAdsIdClass.availableAdsList.contains("Interstitial")) {
        // print('screenName $screenName === isCheckScreen -- $isCheckScreen === myAdsIdClass.isFacebook -- ${myAdsIdClass.isFacebook} === isFacebookAdsShow -- $isFacebookAdsShow === myAdsIdClass.isGoogle -- ${myAdsIdClass.isGoogle} === isADXAdsShow -- $isADXAdsShow');
//         if (isFacebookAdsShow) {
//           provider.loadFBInterstitialAd(
//               screenName: screenName,
//               fbID: myAdsIdClass.facebookInterstitialId,
//               googleID: myAdsIdClass.googleInterstitialId);
//         }
//         if (isAdmobAdsShow || isADXAdsShow) {
//           provider.loadAdxInterstitialAd(
//             screenName: screenName,
//             googleInterID: myAdsIdClass.googleInterstitialId,
//             fbInterID: myAdsIdClass.facebookInterstitialId,
//           );
//         }
//       }
//     });
//   }

//   Future initReceiver() async {
//     receiver = registerReceiver(['LoadAd']).listen((intent) async {
//       print('$screenName Data ----> ${intent.extras}');
//       switch (intent.action) {
//         case 'LoadAd':
//           final provider = Provider.of<InterstitialAdsWidgetProvider>(context,
//               listen: false);
//           myAdsIdClass = await LoadAdsByApi()
//               .isAvailableAds(context: context, screenName: screenName);
//           setState(() {});

//           if (myAdsIdClass.availableAdsList.contains("Interstitial")) {
        // print('screenName $screenName === isCheckScreen -- $isCheckScreen === myAdsIdClass.isFacebook -- ${myAdsIdClass.isFacebook} === isFacebookAdsShow -- $isFacebookAdsShow === myAdsIdClass.isGoogle -- ${myAdsIdClass.isGoogle} === isADXAdsShow -- $isADXAdsShow');
//             if (isFacebookAdsShow) {
//               provider.loadFBInterstitialAd(
//                   screenName: screenName,
//                   fbID: myAdsIdClass.facebookInterstitialId,
//                   googleID: myAdsIdClass.googleInterstitialId);
//             }
//             if (isAdmobAdsShow || isADXAdsShow) {
//               provider.loadAdxInterstitialAd(
//                 screenName: screenName,
//                 googleInterID: myAdsIdClass.googleInterstitialId,
//                 fbInterID: myAdsIdClass.facebookInterstitialId,
//               );
//             }
//           }
//           break;
//         default:
//       }
//     });
//     
//   }

//   Widget fbNativeBannerAd = const SizedBox();
//   Widget fbNativeAd = const SizedBox();

//   _showFBNativeAd() {
//     setState(() {
//       fbNativeAd = loadFbNativeAd(myAdsIdClass.facebookNativeId);
//       fbNativeBannerAd = loadFbNativeAd(myAdsIdClass.facebookNativeId);
//     });
//     updatePrefsResponse(adType: 'Native');
//   }

//   updatePrefsResponse({required String adType}) {
//     Timer(const Duration(seconds: 1), () {
//       isFacebookAdsShow =
//           StorageUtils.prefs.getBool(StorageKeyUtils.isShowFacebookAds) ??
//               false;
//       isADXAdsShow =
//           StorageUtils.prefs.getBool(StorageKeyUtils.isShowADXAds) ?? false;
//       isAdmobAdsShow =
//           StorageUtils.prefs.getBool(StorageKeyUtils.isShowAdmobAds) ?? false;
//       isAdShow =
//           StorageUtils.prefs.getBool(StorageKeyUtils.isAddShowInApp) ?? false;
//       setState(() {});
//       if (isAdmobAdsShow) {
//         setState(() {
//           fbNativeBannerAd = const SizedBox();
//           fbNativeAd = const SizedBox();
//         });
//         if (adType == "Native") {
//           loadAdxNativeAd();
//         }
//       }
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     if (receiver != null) {
                      //   receiver.cancel();
                      // }

//     if (adxNativeAd != null) {
//       adxNativeAd!.dispose();
//     }
//   }

//   NativeAd? adxNativeAd;
//   bool _isAdxNativeAdLoaded = false;

//   loadAdxNativeAd() async {
//     String nativeAdId = myAdsIdClass.googleNativeId;
//     // AdsUnitId().getGoogleNativeAdId();
//     if (nativeAdId != '') {
//       setState(() {
//         adxNativeAd = NativeAd(
//           adUnitId: nativeAdId,
//           factoryId: 'listTileMedium',
//           request: const AdRequest(),
//           listener: NativeAdListener(
//             onAdLoaded: (ad) {
//               setState(() {
//                 _isAdxNativeAdLoaded = true;
//                 adxNativeAd = ad as NativeAd;
//               });
//             },
//             onAdFailedToLoad: (ad, error) {
//               ad.dispose();
//             },
//           ),
//         );
//         adxNativeAd!.load();
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: ColorUtils.themeColor.oxff447D58,
//         automaticallyImplyLeading: false,
//         leading: IconButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             icon: Icon(
//               Icons.arrow_back_ios_new_rounded,
//               color: ColorUtils.themeColor.oxffFFFFFF,
//             )),
//         title: Text(
//           'Get More Loan Guidance',
//           style: FontUtils.h16(
//             fontColor: ColorUtils.themeColor.oxffFFFFFF,
//             fontWeight: FWT.semiBold,
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             fbNativeAd,
//             adxNativeAd == null || _isAdxNativeAdLoaded == false
//                 ? const SizedBox()
//                 : Container(
//                     color: Colors.transparent,
//                     height: 275,
//                     alignment: Alignment.center,
//                     child: AdWidget(ad: adxNativeAd!),
//                   ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//               child: StaggeredGridView.countBuilder(
//                   padding: EdgeInsets.zero,
//                   crossAxisCount: 2,
//                   physics: const BouncingScrollPhysics(),
//                   itemCount: loansDataList.length,
//                   crossAxisSpacing: 8,
//                   mainAxisSpacing: 8,
//                   shrinkWrap: true,
//                   staggeredTileBuilder: (index) {
//                     return index % 3 == 0
//                         ? const StaggeredTile.count(2, 0.80)
//                         : const StaggeredTile.count(1, 0.80);
//                   },
//                   itemBuilder: (context, index) {
//                     return BounceClickWidget(
//                       onTap: () {
//                         final provider =
//                             Provider.of<InterstitialAdsWidgetProvider>(context,
//                                 listen: false);
//                         if (receiver != null) {
                      //   receiver.cancel();
                      // }

//                         provider.showFbOrAdxOrAdmobInterstitialAd(
//                           availableAds: myAdsIdClass.availableAdsList,
//                           RouteUtils.loanAdvantageScreen,
//                           context,
//                           arguments: loansDataList[index].arguments,
//                           googleInterID: myAdsIdClass.googleInterstitialId,
//                           fbInterID: myAdsIdClass.facebookInterstitialId,
//                         );
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(12),
//                           color: Colors.accents[index % Colors.accents.length]
//                               .withOpacity(0.4),
//                         ),
//                         child: Center(
//                           child: index % 3 == 0
//                               ? Row(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Image(
//                                       image:
//                                           AssetImage(loansDataList[index].img!),
//                                       height: 60,
//                                     ),
//                                     const SizedBox(width: 20),
//                                     Text(loansDataList[index].name ?? '',
//                                         style: FontUtils.h16(
//                                             fontWeight: FWT.bold)),
//                                   ],
//                                 )
//                               : Column(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Image(
//                                       image:
//                                           AssetImage(loansDataList[index].img!),
//                                       height: 60,
//                                     ),
//                                     const SizedBox(height: 10),
//                                     Text(
//                                       loansDataList[index].name ?? '',
//                                       style:
//                                           FontUtils.h16(fontWeight: FWT.bold),
//                                       textAlign: TextAlign.center,
//                                     ),
//                                   ],
//                                 ),
//                         ),
//                       ),
//                     );
//                   }),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
