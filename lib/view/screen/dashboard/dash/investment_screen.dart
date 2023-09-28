import 'package:flutter/material.dart';
import 'package:instant_pay/utilities/assets/asset_utils.dart';
import 'package:instant_pay/utilities/routes/route_utils.dart';
import 'package:instant_pay/view/screen/dashboard/home/loan_short_description_screen.dart';
import 'package:instant_pay/view/screen/dashboard/home/model/available_ads_response.dart';
import 'package:instant_pay/view/widget/ads_widget/interstitial_ads_widget.dart';
import 'package:instant_pay/view/widget/bounce_click_widget.dart';
import 'package:provider/provider.dart';

class InvestmentDashboardScreen extends StatefulWidget {
  const InvestmentDashboardScreen({super.key});

  @override
  State<InvestmentDashboardScreen> createState() =>
      _InvestmentDashboardScreenState();
}

class _InvestmentDashboardScreenState extends State<InvestmentDashboardScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              const SizedBox(height: 10),
              myWidget(AssetUtils.icMutualFundsDash, () {
                final provider = Provider.of<InterstitialAdsWidgetProvider>(
                    context,
                    listen: false);
                provider.showAdxInterstitialAd(
                  myAdsIdClass: MyAdsIdClass(),
                  RouteUtils.dashboardMoreLoansScreen,
                  context,
                  fbInterID: '',
                  googleInterID: '',
                  arguments: LoanDescriptionArguments(
                    loanName: 'Mutual Funds Guidance',
                    titleList: [
                      'Definition and Types',
                      'Advantages',
                      'Risks',
                      'How to Invest',
                      'Performance',
                    ],
                    titleOverViewList: [
                      '''👉 A mutual fund is a type of investment vehicle that pools money from multiple investors to purchase a diversified portfolio of securities.
👉 There are several types of mutual funds, including equity funds, bond funds, balanced funds, index funds, and specialty funds.''',
                      '''👉 Diversification: Mutual funds offer investors access to a diversified portfolio of securities, which can help mitigate risk.
👉 Professional Management: Mutual funds are managed by professional portfolio managers who have expertise in selecting and managing securities.
👉 Liquidity: Mutual funds are typically very liquid, meaning investors can buy and sell shares on a daily basis.
👉 Accessibility: Mutual funds are widely available to individual investors, with low minimum investment requirements.''',
                      '''👉 Market Risk: Mutual funds are subject to market risk, meaning the value of the fund's portfolio can go up or down based on market conditions.
👉 Management Risk: The performance of a mutual fund is largely dependent on the skills and decisions of the portfolio manager.
👉 Fees and Expenses: Mutual funds charge fees and expenses, including management fees, operating expenses, and sales charges, which can reduce returns.''',
                      '''👉 Research: Investors should research different mutual funds and their performance history before investing.
👉 Investment Goals: Investors should consider their investment goals, risk tolerance, and time horizon when selecting a mutual fund.
👉 Investment Process: Investors can invest in mutual funds through a financial advisor, online brokerage account, or directly through the mutual fund company.''',
                      '''👉 Returns: The performance of a mutual fund is measured by its returns, which can be either positive or negative.,
👉 Benchmark: A mutual fund's performance is often compared to a benchmark, such as a stock index or bond index.
👉 Past Performance: Past performance is not a guarantee of future results, and investors should not rely solely on historical performance when selecting a mutual fund.'''
                    ],
                  ),
                );
              }),
              const SizedBox(height: 10),
              myWidget(AssetUtils.icDigitalGold, () {
                final provider = Provider.of<InterstitialAdsWidgetProvider>(
                    context,
                    listen: false);
                provider.showAdxInterstitialAd(
                  myAdsIdClass: MyAdsIdClass(),
                  RouteUtils.dashboardMoreLoansScreen,
                  context,
                  fbInterID: '',
                  googleInterID: '',
                  arguments: LoanDescriptionArguments(
                    loanName: 'Digital Gold Guidance',
                    titleList: [
                      'Definition',
                      'Advantages',
                      'Low Fees',
                      'Risks',
                      'How to Invest',
                      'Performance',
                    ],
                    titleOverViewList: [
                      '''👉 Digital gold is a form of investment that allows investors to purchase and own gold electronically.
👉 It is not physical gold, but a digital representation of gold ownership.''',
                      '''👉 Convenience: Digital gold can be purchased and traded online, making it a convenient and accessible investment option.
👉 Liquidity: Digital gold can be easily sold or exchanged for cash or other investments.''',
                      '''👉 Compared to physical gold, digital gold typically has lower fees and costs associated with storage, insurance, and transportation.
👉 Diversification: Digital gold can provide investors with a way to diversify their portfolio beyond traditional investments.''',
                      '''👉 Market Risk: The value of digital gold can fluctuate based on market conditions, just like physical gold and other investments.
👉 Technology Risk: Digital gold is reliant on technology and infrastructure, which can be vulnerable to cyber attacks, system failures, and other risks.
👉 Counter party Risk: Digital gold is often held by a third-party custodian, which can introduce counter party risk if the custodian experiences financial distress.''',
                      '''👉 Platforms: Investors can purchase digital gold through various online platforms, such as digital gold exchanges, trading platforms, and brokerages.
👉 Methods: Digital gold can be purchased in different ways, including through a mobile app, website, or by phone.
👉 Storage: Digital gold is often stored in secure vaults and can be accessed through a digital wallet or online account.''',
                      '''👉 Returns: The performance of digital gold can be influenced by factors such as market conditions, global economic trends, and supply and demand dynamics.
👉 Comparison: Digital gold can be compared to physical gold or other investment options, such as stocks, bonds, or cryptocurrencies.
👉 Historical Performance: Like any investment, past performance is not a guarantee of future results, and investors should do their own research and carefully consider the risks and potential returns before investing.''',
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget myWidget(String img, VoidCallback onTap) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child:
          BounceClickWidget(onTap: onTap, child: Image(image: AssetImage(img))),
    );
  }
}
