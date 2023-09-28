import 'package:flutter/material.dart';
import 'package:instant_pay/utilities/colors/color_utils.dart';
import 'package:instant_pay/utilities/font/font_utils.dart';
import 'package:instant_pay/utilities/routes/route_utils.dart';
import 'package:instant_pay/view/screen/dashboard/home/loan_short_description_screen.dart';
import 'package:instant_pay/view/screen/dashboard/home/model/available_ads_response.dart';
import 'package:instant_pay/view/widget/ads_widget/interstitial_ads_widget.dart';
import 'package:instant_pay/view/widget/center_text_button_widget.dart';
import 'package:provider/provider.dart';

class InvestmentDetailsScreen extends StatefulWidget {
  final LoanDescriptionArguments arguments;
  const InvestmentDetailsScreen({super.key, required this.arguments});

  @override
  State<InvestmentDetailsScreen> createState() =>
      _InvestmentDetailsScreenState();
}

class _InvestmentDetailsScreenState extends State<InvestmentDetailsScreen> {
  @override
  void initState() {
    super.initState();
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
          widget.arguments.investmentName ?? '',
          style: FontUtils.h18(
            fontColor: ColorUtils.themeColor.oxffFFFFFF,
            fontWeight: FWT.semiBold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                widget.arguments.investmentSortDetails ?? '',
                style: FontUtils.h14(fontWeight: FWT.medium),
              ),
            ),
            const Divider(thickness: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Investment fees',
                  style: FontUtils.h16(fontWeight: FWT.bold),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                widget.arguments.investmentDescription1 ?? '',
                style: FontUtils.h14(fontWeight: FWT.medium),
              ),
            ),
            const Divider(thickness: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Advantage',
                  style: FontUtils.h16(fontWeight: FWT.bold),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                widget.arguments.investmentDescription2 ?? '',
                style: FontUtils.h14(fontWeight: FWT.medium),
              ),
            ),
            const Divider(thickness: 2),
            const SizedBox(height: 20),
            CenterTextButtonWidget(
              title: 'NEXT',
              onTap: () {
                getRoute(context);
                // final provider = Provider.of<InterstitialAdsWidgetProvider>(context, listen: false);
                // provider.showInterstitialAd(RouteUtils.clarificationScreen, context);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  getRoute(BuildContext context) {
    final provider =
        Provider.of<InterstitialAdsWidgetProvider>(context, listen: false);
    provider.showAdxInterstitialAd(
      myAdsIdClass: MyAdsIdClass(),
      RouteUtils.takingLoanReasonScreen,
      context,
      arguments: widget.arguments,
      fbInterID: '',
      googleInterID: '',
    );
  }
}
