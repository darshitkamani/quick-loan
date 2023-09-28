// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:instant_pay/view/widget/ads_widget/ads_unit_id.dart';

// class BannerAdWidget extends StatefulWidget {
//   final AdSize? adSize;
//   final bool? isCircularShow;
//   const BannerAdWidget({Key? key, this.adSize = AdSize.fullBanner, this.isCircularShow = false}) : super(key: key);

//   @override
//   State<BannerAdWidget> createState() => _BannerAdWidgetState();
// }

// class _BannerAdWidgetState extends State<BannerAdWidget> {
//   BannerAd? _bannerAd;
//   bool _isBannerAdReady = false;
//   @override
//   void initState() {
//     super.initState();
//     _bannerAd = BannerAd(
//       adUnitId: AdsUnitId().bannerAdUnitId,
//       request: const AdRequest(),
//       size: widget.adSize!,
//       listener: BannerAdListener(
//         onAdLoaded: (_) {
//           setState(() {
//             _isBannerAdReady = true;
//           });
//         },
//         onAdFailedToLoad: (ad, err) {
//           // debugPrint('Failed to load a banner ad: ${err.message}');
//           _isBannerAdReady = false;
//           ad.dispose();
//         },
//       ),
//     );
//     _bannerAd!.load();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _bannerAd!.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Stack(
//         children: [
//           if (_isBannerAdReady) ...{
//             Center(
//               child: SizedBox(
//                 width: double.infinity,
//                 height: _bannerAd!.size.height.toDouble(),
//                 child: AdWidget(
//                   ad: _bannerAd!,
//                 ),
//               ),
//             )
//           }
//         ],
//       ),
//     );
//   }
// }
