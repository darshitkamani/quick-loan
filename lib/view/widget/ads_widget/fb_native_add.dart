// import 'package:facebook_audience_network/facebook_audience_network.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:instant_pay/utilities/storage/storage.dart';

// Widget loadFbNativeAd(String adId) {
//   String nativeAdId = adId;
//   // AdsUnitId().getFacebookNativeAdId();
//   if (nativeAdId == '') {
//     return const SizedBox();
//   }

//   if (kDebugMode) {
//     nativeAdId = 'IMG_16_9_APP_INSTALL#$adId';
//     // debugPrint('ID - - - - $nativeAdId');
//   }

//   return FacebookNativeAd(
//     placementId: nativeAdId, // nativeAdId,
//     adType: NativeAdType.NATIVE_AD_VERTICAL,
//     width: double.infinity,
//     height: 300,
//     backgroundColor: const Color(0xFFFFE6C5),
//     titleColor: Colors.black,
//     descriptionColor: Colors.black,
//     buttonColor: const Color(0xff447D58),
//     buttonTitleColor: Colors.white,
//     buttonBorderColor: const Color(0xff447D58),
//     listener: (result, value) {
//       // print('---=- =-= -= -= -= - $result $value');

//       if (result == NativeAdResult.ERROR) {
//         // loadFBInterstitialAd();
//         StorageUtils.prefs.setBool(StorageKeyUtils.isShowFacebookAds, false);
//         StorageUtils.prefs.setBool(StorageKeyUtils.isShowADXAds, true);
//         StorageUtils.prefs.setBool(StorageKeyUtils.isShowAdmobAds, true);
//       }
//     },
//     keepExpandedWhileLoading: true,
//     
//   );
// }

// Widget loadFbNativeBannerAd() {
//   String nativeBannerAdId = AdsUnitId().getFacebookNativeBannerAdId();
//   if (nativeBannerAdId == '') {
//     return const SizedBox();
//   }
//   return FacebookNativeAd(
//     placementId: nativeBannerAdId,
//     adType: NativeAdType.NATIVE_BANNER_AD,
//     width: double.infinity,
//     height: 80,
//     backgroundColor: const Color(0xFFFFE6C5),
//     titleColor: Colors.black,
//     descriptionColor: Colors.black,
//     buttonColor: const Color(0xff447D58),
//     buttonTitleColor: Colors.white,
//     buttonBorderColor: const Color(0xff447D58),
//     listener: (result, value) {
//       print('---=- =-= -= -= -= - $result $value');
//       if (result == NativeAdResult.ERROR) {
//         // loadFBInterstitialAd();
//         StorageUtils.prefs.setBool(StorageKeyUtils.isShowFacebookAds, false);
//         StorageUtils.prefs.setBool(StorageKeyUtils.isShowADXAds, true);
//         StorageUtils.prefs.setBool(StorageKeyUtils.isShowAdmobAds, true);
//       }
//     },
//     keepExpandedWhileLoading: true,
//     
//   );
// }
