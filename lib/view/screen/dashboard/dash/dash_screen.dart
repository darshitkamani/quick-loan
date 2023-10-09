import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:instant_pay/l10n/locale_keys.g.dart';
import 'package:instant_pay/utilities/assets/asset_utils.dart';
import 'package:instant_pay/utilities/colors/color_utils.dart';
import 'package:instant_pay/utilities/font/font_utils.dart';
import 'package:instant_pay/utilities/storage/storage.dart';
import 'package:instant_pay/view/screen/dashboard/dash/loans_screen.dart';
import 'package:instant_pay/view/widget/lottie_ad_widget.dart';

class DashScreen extends StatefulWidget {
  const DashScreen({super.key});

  @override
  State<DashScreen> createState() => _DashScreenState();
}

class _DashScreenState extends State<DashScreen> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    if (StorageUtils.prefs.getBool(StorageKeyUtils.isAddShowInApp) ?? false) {
      // final provider = Provider.of<InterstitialAdsWidgetProvider>(context, listen: false);
      // provider.loadInterstitialAd();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SafeArea(
          child: Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        color:
                            ColorUtils.themeColor.oxff858494.withOpacity(0.2))),
                color: Colors.transparent),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(LocaleKeys.ExploreLoans.tr(),
                      style: FontUtils.h20(fontWeight: FWT.bold)),
                  const LottieAdWidget(lottieURL: AssetUtils.icDash),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        const LoansScreen(),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget titleWidget(
      int selectedIndex, index, String value, VoidCallback onTap) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: ColorUtils.themeColor.oxff447D58),
              color: selectedIndex == index
                  ? ColorUtils.themeColor.oxff447D58
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  value,
                  style: FontUtils.h16(
                    fontColor: selectedIndex == index
                        ? ColorUtils.themeColor.oxffFFFFFF
                        : ColorUtils.themeColor.oxff000000,
                    fontWeight: FWT.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
