import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quick_loan/utilities/assets/asset_utils.dart';
import 'package:quick_loan/utilities/colors/color.dart';
import 'package:quick_loan/utilities/font/font_utils.dart';
import 'package:provider/provider.dart';
import 'package:quick_loan/view/screen/splash/provider/splash_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (!kDebugMode) {
        await FirebaseAnalytics.instance.logEvent(name: 'SplashScreen');
      }
      FocusScope.of(context).unfocus();
    });
    final provider = Provider.of<SplashProvider>(context, listen: false);

    provider.getRoutes(context: context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(const AssetImage(AssetUtils.skyMountainBG), context);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          Container(
            height: screenSize.height,
            width: screenSize.width,
            color: Colors.white,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 100),
              const Image(
                image: AssetImage(AssetUtils.logoFullPng),
                height: 300,
                width: 300,
              ),
              const SizedBox(height: 100),
              Text(
                'Simplify your financial needs and access instant solutions today.',
                textAlign: TextAlign.center,
                style: FontUtils.h14(
                  fontColor: ColorUtils.themeColor.oxff673AB7,
                  fontWeight: FWT.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
