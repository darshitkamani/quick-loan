import 'package:flutter/material.dart';
import 'package:instant_pay/utilities/colors/color_utils.dart';
import 'package:instant_pay/utilities/font/font_utils.dart';
import 'package:instant_pay/utilities/routes/route_utils.dart';
import 'package:instant_pay/view/screen/dashboard/home/loan_short_description_screen.dart';
import 'package:instant_pay/view/screen/dashboard/home/model/available_ads_response.dart';
import 'package:instant_pay/view/widget/ads_widget/interstitial_ads_widget.dart';
import 'package:instant_pay/view/widget/center_text_button_border_widget.dart';
import 'package:provider/provider.dart';

class LoanApplyScreen extends StatefulWidget {
  final LoanDescriptionArguments arguments;
  const LoanApplyScreen({super.key, required this.arguments});

  @override
  State<LoanApplyScreen> createState() => _LoanApplyScreenState();
}

class _LoanApplyScreenState extends State<LoanApplyScreen> {
  PageController pageController = PageController(initialPage: 0);
  int currentPage = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorUtils.themeColor.oxff447D58,
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
          style: FontUtils.h16(
            fontColor: ColorUtils.themeColor.oxffFFFFFF,
            fontWeight: FWT.semiBold,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),
          Expanded(
            child: PageView.builder(
              controller: pageController,
              itemCount: widget.arguments.titleList!.length,
              onPageChanged: (int page) {
                setState(() {
                  currentPage = page;
                });
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[350]!),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 50),
                        Image(
                          image: AssetImage(widget.arguments.imgList![index]),
                          height: 100,
                        ),
                        const SizedBox(height: 30),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              widget.arguments.titleList![index],
                              style: FontUtils.h18(
                                fontColor: ColorUtils.themeColor.oxff000000,
                                fontWeight: FWT.bold,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              Text(
                                widget.arguments.titleOverViewList![index],
                                style: FontUtils.h14(
                                  fontColor: ColorUtils.themeColor.oxff000000,
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 30,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.arguments.titleList!.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                            color: currentPage == index
                                ? ColorUtils.themeColor.oxff447D58
                                : ColorUtils.themeColor.oxff447D58
                                    .withOpacity(0.4),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(children: [
              Expanded(
                  flex: 1,
                  child: CenterTextButtonBorderWidget(
                    title:
                        const Icon(Icons.keyboard_backspace_rounded, size: 35),
                    onTap: () {
                      pageController.animateToPage(currentPage - 1,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn);
                    },
                  )),
              const SizedBox(width: 10),
              Expanded(
                  flex: 1,
                  child: CenterTextButtonBorderWidget(
                    title: const RotationTransition(
                        turns: AlwaysStoppedAnimation(180 / 360),
                        child:
                            Icon(Icons.keyboard_backspace_rounded, size: 35)),
                    onTap: () {
                      pageController.animateToPage(currentPage + 1,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn);
                    },
                  )),
            ]),
          ),
          const SizedBox(height: 20),
          currentPage == widget.arguments.titleList!.length - 1
              ? CenterTextButtonBorderWidget(
                  title:
                      Text('NEXT', style: FontUtils.h18(fontWeight: FWT.bold)),
                  onTap: () {
                    final provider = Provider.of<InterstitialAdsWidgetProvider>(
                        context,
                        listen: false);
                    provider.showAdxInterstitialAd(
                      myAdsIdClass: MyAdsIdClass(),
                      RouteUtils.clarificationScreen,
                      context,
                      fbInterID: '',
                      googleInterID: '',
                    );
                  },
                )
              : const SizedBox(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
