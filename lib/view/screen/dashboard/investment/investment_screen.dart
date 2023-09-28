import 'package:flutter/material.dart';
import 'package:instant_pay/utilities/assets/asset_utils.dart';
import 'package:instant_pay/utilities/colors/color_utils.dart';
import 'package:instant_pay/utilities/font/font_utils.dart';
import 'package:instant_pay/utilities/routes/routes.dart';
import 'package:instant_pay/utilities/strings/strings_utils.dart';
import 'package:instant_pay/view/screen/dashboard/home/loan_short_description_screen.dart';
import 'package:instant_pay/view/screen/dashboard/home/model/available_ads_response.dart';
import 'package:instant_pay/view/widget/ads_widget/interstitial_ads_widget.dart';
import 'package:instant_pay/view/widget/bounce_click_widget.dart';
import 'package:instant_pay/view/widget/lottie_ad_widget.dart';
import 'package:provider/provider.dart';

class InvestmentScreen extends StatefulWidget {
  const InvestmentScreen({super.key});

  @override
  State<InvestmentScreen> createState() => _InvestmentScreenState();
}

class _InvestmentScreenState extends State<InvestmentScreen> {
  @override
  void initState() {
    super.initState();
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
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FlutterLogo(),
                  LottieAdWidget(lottieURL: AssetUtils.investmentAppbar),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  'Secure Investments',
                  style: FontUtils.h16(fontWeight: FWT.bold),
                ),
                const SizedBox(height: 20),
                GridView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: secureInvestmentsList.length,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 1.2,
                  ),
                  itemBuilder: (context, index) {
                    return loanProductsContainer(
                      secureInvestmentsList[index]['img']!,
                      secureInvestmentsList[index]['name']!,
                    );
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  'InSecure Investments',
                  style: FontUtils.h16(fontWeight: FWT.bold),
                ),
                const SizedBox(height: 20),
                GridView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: inSecureInvestmentsList.length,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 1.2,
                  ),
                  itemBuilder: (context, index) {
                    return loanProductsContainer(
                      inSecureInvestmentsList[index]['img']!,
                      inSecureInvestmentsList[index]['name']!,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  getLoanDetails(String loanName) {
    final provider =
        Provider.of<InterstitialAdsWidgetProvider>(context, listen: false);
    switch (loanName) {
      case savingsAccounts:
        return provider.showAdxInterstitialAd(
          myAdsIdClass: MyAdsIdClass(),
          RouteUtils.investmentDetailsScreen,
          context,
          fbInterID: '',
          googleInterID: '',
          arguments: LoanDescriptionArguments(
            investmentName: loanName,
            investmentSortDetails:
                '''Savings accounts are not typically considered investments in the traditional sense because they do not generate a high rate of return compared to other investment options like stocks, bonds, or mutual funds. 

Instead, savings accounts are considered a safe and secure place to store money while earning a modest interest rate.''',
            investmentDescription1:
                '''○ Most savings accounts do not charge any investment fees, such as management fees or transaction fees. 

○ However, some savings accounts may have monthly maintenance fees or require a minimum balance to avoid fees. 

○ It's important to read the terms and conditions carefully before opening a savings account to understand any fees that may apply.''',
            investmentDescription2:
                '''○ Safety and Security: Savings accounts are considered one of the safest investment options available because they are typically backed by the Federal Deposit Insurance Corporation (FDIC) or the National Credit Union Administration (NCUA), which insures deposits up to a certain limit. 

○ This means that if the bank or credit union were to fail, the account holder would still be able to recover their money, up to the insured limit.

○ Liquidity: Savings accounts are highly liquid, which means that the account holder can easily access their funds at any time without penalty. This makes savings accounts a good option for emergency savings or short-term financial goals.

○ Guaranteed Returns: Unlike other investment options, such as stocks or mutual funds, savings accounts offer a guaranteed rate of return. While the interest rate may be modest, it is typically consistent and reliable.

○ Easy to Open and Manage: Savings accounts are easy to open and manage, with most banks and credit unions offering online account management and mobile banking options.''',
            isFromInvest: true,
            investmentLoanName: savingsAccounts,
            takePoints: [
              'Safety',
              'Convenience',
              'Stability',
              'Tax benefits',
            ],
            take: [
              '''In India, savings accounts are insured by the Deposit Insurance and Credit Guarantee Corporation (DICGC), which provides insurance cover of up to Rs. 5 lakh per depositor per bank. This provides a high level of safety for investors.''',
              '''Savings accounts are widely available in India and can be easily opened and managed. Most banks also offer online banking services, making it easy for investors to access their funds and manage their accounts from anywhere.''',
              '''Savings accounts in India offer a stable return on investment, with interest rates typically ranging from 2% to 4% per annum. This makes them a good option for conservative investors who are looking for a low-risk investment option.''',
              '''Interest earned on savings accounts in India up to Rs. 10,000 per year is exempt from tax under Section 80TTA of the Income Tax Act, 1961. This can be beneficial for investors who are looking to earn tax-free income.''',
            ],
            notTakePoints: [
              'Low returns',
              'Inflation risk',
              'Interest rate risk',
              'Opportunity cost',
            ],
            notTake: [
              '''As mentioned above, savings accounts in India offer a relatively low rate of return compared to other investment options, which may not be sufficient to keep up with inflation and provide significant growth.''',
              '''Inflation in India has historically been higher than the interest rates offered on savings accounts, which means that the real value of your investment may decrease over time.''',
              '''Interest rates on savings accounts in India are subject to change, which means that your returns may be affected if interest rates fall.''',
              '''As with other markets, investors in India may miss out on higher-return opportunities by investing in savings accounts rather than other investment options.''',
            ],
          ),
        );
      case certificatesOfDeposit:
        return provider.showAdxInterstitialAd(
          myAdsIdClass: MyAdsIdClass(),
          RouteUtils.investmentDetailsScreen,
          context,
          fbInterID: '',
          googleInterID: '',
          arguments: LoanDescriptionArguments(
            investmentName: loanName,
            investmentSortDetails:
                '''Certificates of Deposit (CDs) are a type of financial instrument that allows investors to earn a fixed interest rate over a specified period of time. They are considered low-risk investments because they are typically issued by banks and are FDIC-insured, meaning that the investor's principal investment is protected up to the insured limit.''',
            investmentDescription1:
                '''○ CDs generally do not have any investment fees associated with them. However, if an investor chooses to withdraw their funds before the end of the term, they may be subject to penalties or fees.''',
            investmentDescription2:
                '''○ Fixed Rate of Return: CDs offer a fixed interest rate, which means that investors know exactly how much they will earn over the life of the CD.

○ Low Risk: Because CDs are FDIC-insured and issued by banks, they are considered low-risk investments.

○ Choice of Terms: CDs come in a variety of terms, ranging from a few months to several years, allowing investors to choose the term that best meets their financial goals.

○ Predictable Returns: CDs offer predictable returns, which can make them a good option for investors who want to earn a specific amount of interest over a specific period of time.

○ Diversification: CDs can be used as part of a diversified investment portfolio, providing stability and balance alongside other higher-risk investments.

○ No Market Risk: CDs are not subject to market risk, which means that the investor's return is not impacted by fluctuations in the stock market or interest rates.''',
            investmentLoanName: certificatesOfDeposit,
            isFromInvest: true,
            takePoints: [
              'Safety',
              'Fixed interest rates',
              'Flexible term lengths',
              'Higher interest rates',
            ],
            take: [
              '''CDs in India are insured by the Deposit Insurance and Credit Guarantee Corporation (DICGC), which provides insurance cover of up to Rs. 5 lakh per depositor per bank, making them a safe investment option.''',
              '''CDs in India offer a fixed interest rate over a specific period, providing certainty about your return on investment.''',
              '''CDs in India are available in a variety of term lengths, ranging from a few months to several years, allowing investors to choose the term that best fits their investment goals.''',
              '''CDs in India typically offer higher interest rates than savings accounts, which means your money may grow at a faster rate.''',
            ],
            notTakePoints: [
              'Penalties for early withdrawal',
              'Low liquidity',
              'Limited flexibility',
              'Limited availability',
            ],
            notTake: [
              '''If you need to withdraw your money before the CD matures, you may have to pay penalties, which can reduce your returns.''',
              '''CDs are not very liquid in India, which means you cannot easily access your funds without penalty until the CD matures.''',
              '''Once you invest in a CD in India, you cannot withdraw your funds or change the investment term without penalty, which can limit your flexibility.''',
              '''CDs in India are not as widely available as other investment options, which can limit your investment choices.''',
            ],
          ),
        );
      case moneyMarketAccounts:
        return provider.showAdxInterstitialAd(
          myAdsIdClass: MyAdsIdClass(),
          RouteUtils.investmentDetailsScreen,
          context,
          fbInterID: '',
          googleInterID: '',
          arguments: LoanDescriptionArguments(
            investmentName: loanName,
            investmentSortDetails:
                '''A money market account (MMA) is a type of deposit account offered by banks and credit unions that typically offers higher interest rates than traditional savings accounts. They are similar to savings accounts in that they are FDIC-insured and provide a safe place to store cash, but they often require higher minimum balances and may have limited transaction capabilities.''',
            investmentDescription1:
                '''○ Money market accounts may have fees associated with them, such as monthly maintenance fees or fees for exceeding transaction limits. 
            
○ It's important to read the terms and conditions carefully to understand any fees that may apply.''',
            investmentDescription2:
                '''○ Higher Interest Rates: MMAs generally offer higher interest rates than traditional savings accounts, allowing investors to earn more on their cash reserves.

○ FDIC Insurance: Like savings accounts, MMAs are FDIC-insured, which means that the investor's principal is protected up to the insured limit.

○ Access to Funds: While MMAs may have transaction limits, they still offer a level of liquidity and flexibility that can be useful for emergency funds or short-term savings goals.

○ Diversification: MMAs can be used as part of a diversified investment portfolio, providing stability and balance alongside other higher-risk investments.

○ Safety: Because MMAs are typically issued by banks and credit unions, they are considered low-risk investments.

○ Tiered Interest Rates: Some MMAs offer tiered interest rates, which means that the interest rate increases as the account balance grows.''',
            investmentLoanName: moneyMarketAccounts,
            isFromInvest: true,
            takePoints: [
              'Safety',
              'Liquidity',
              'Higher interest rates',
              'Low investment minimums',
            ],
            take: [
              '''Money market accounts in India are generally considered safe because they are invested in short-term, low-risk debt instruments such as treasury bills, commercial paper, and certificates of deposit.''',
              '''Money market accounts in India are relatively liquid, which means that investors can access their funds quickly and easily, making them a good option for emergency funds or short-term savings.''',
              '''Money market accounts in India typically offer higher interest rates than traditional savings accounts, which can help your money grow at a faster rate.''',
              '''Money market accounts in India typically have low minimum investment requirements, which makes them accessible to a wide range of investors.''',
            ],
            notTakePoints: [
              'Limited returns',
              'Fees and charges',
              'Inflation risk',
              'Market risk',
            ],
            notTake: [
              '''While money market accounts in India offer higher interest rates than traditional savings accounts, they typically offer lower returns than other investment options such as stocks or mutual funds.''',
              '''Some money market accounts in India may charge fees or have minimum balance requirements, which can reduce your returns.''',
              '''Money market accounts in India may not provide returns that keep up with inflation, which can erode the purchasing power of your savings over time.''',
              '''Although money market accounts in India are generally considered safe, they are not completely immune to market fluctuations, and investors may still face some level of risk.''',
            ],
          ),
        );
      case bonds:
        return provider.showAdxInterstitialAd(
          myAdsIdClass: MyAdsIdClass(),
          RouteUtils.investmentDetailsScreen,
          context,
          fbInterID: '',
          googleInterID: '',
          arguments: LoanDescriptionArguments(
            investmentName: loanName,
            investmentSortDetails:
                '''Bonds are a type of investment that represents a loan made by an investor to a corporation, government, or other organization. When an investor buys a bond, they are essentially lending money to the issuer in exchange for regular interest payments and the return of the principal investment at the end of the bond's term.''',
            investmentDescription1:
                '''○ Bonds may have fees associated with them, such as brokerage fees, transaction fees, or management fees if they are held in a mutual fund or ETF. 

○ It's important to read the terms and conditions carefully to understand any fees that may apply.''',
            investmentDescription2:
                '''○ Predictable Income: Bonds provide a predictable stream of income in the form of regular interest payments.

○ Fixed Income: Bonds offer a fixed rate of return, which means that investors know exactly how much they will earn over the life of the bond.

○ Diversification: Bonds can be used as part of a diversified investment portfolio, providing stability and balance alongside other higher-risk investments.

○ Lower Risk: Bonds are generally considered lower-risk investments than stocks because they offer a fixed rate of return and are backed by the issuer's ability to repay the loan.

○ Inflation Protection: Some bonds, such as Treasury Inflation-Protected Securities (TIPS), offer protection against inflation by adjusting the bond's principal value based on changes in the Consumer Price Index (CPI).

○ Liquidity: Bonds can be bought and sold on the open market, providing investors with a level of liquidity that can be useful for managing their portfolio.''',
            investmentLoanName: bonds,
            isFromInvest: true,
            takePoints: [
              'Fixed income',
              'Diversification',
              'Higher interest rates',
              'Safety',
            ],
            take: [
              '''Bonds in India offer a fixed income stream, making them a stable investment option for investors looking for a steady return on their investment.''',
              '''Bonds can be a good way to diversify your investment portfolio, as they are typically less volatile than stocks and can provide a buffer against market fluctuations.''',
              '''Bonds in India typically offer higher interest rates than savings accounts, which can help your money grow at a faster rate.''',
              '''Some bonds in India, such as government bonds, are considered safe because they are backed by the government and have a low risk of default.''',
            ],
            notTakePoints: [
              'Interest rate risk',
              'Inflation risk',
              'Default risk',
              'Liquidity risk',
            ],
            notTake: [
              '''Bond prices can be affected by changes in interest rates, which can lead to fluctuations in the value of your investment.'''
                  '''Bonds in India may not provide returns that keep up with inflation, which can erode the purchasing power of your savings over time.'''
                  '''Although government bonds are generally considered safe, bonds issued by private companies or institutions may carry a higher risk of default, which can lead to a loss of investment.'''
                  '''Some bonds in India may not be very liquid, which can make it difficult to sell your investment when you need to.'''
            ],
          ),
        );
      case stocks:
        return provider.showAdxInterstitialAd(
          myAdsIdClass: MyAdsIdClass(),
          RouteUtils.investmentDetailsScreen,
          context,
          fbInterID: '',
          googleInterID: '',
          arguments: LoanDescriptionArguments(
            investmentName: loanName,
            investmentSortDetails:
                '''Stocks, also known as equities or shares, are ownership units of publicly traded companies. When you buy a stock, you become a shareholder and have a stake in the company's future profits and losses.''',
            investmentDescription1:
                '''○ Investment fees for buying and selling stocks can vary depending on the broker and the type of account you have. 
            
○ Some brokers may charge a flat fee per trade, while others may charge a percentage of the trade value. 

○ In addition, there may be other fees associated with holding a stock, such as account maintenance fees or dividend reinvestment fees.''',
            investmentDescription2:
                '''○ One of the major disadvantages of investing in stocks is the potential for volatility and losses. Stock prices can fluctuate widely and can be affected by various factors such as economic conditions, industry trends, and company performance. 

○ Additionally, investing in individual stocks can be risky, as the performance of a single company can have a significant impact on your overall returns. 

○ Therefore, it is important to diversify your portfolio and spread your risk across multiple stocks and asset classes. It's also important to research and understand the companies you are investing in and consider factors such as their financial health, management team, and competitive position before investing.''',
            investmentLoanName: stocks,
            isFromInvest: true,
            takePoints: [
              'Potential for high returns',
              'Long-term growth potential',
              'Diversification',
              'Easy to buy and sell',
            ],
            take: [
              '''Stocks in India have historically offered higher returns than other investment options such as bonds or fixed deposits.''',
              '''Stocks can offer long-term growth potential as the value of the company and its stock price increase over time.''',
              '''Investing in stocks can provide diversification to an investment portfolio, as stocks can perform differently than other asset classes like bonds or real estate.''',
              '''With the growth of online trading platforms, buying and selling stocks in India has become much easier and accessible to individual investors.''',
            ],
            notTakePoints: [
              'Market volatility',
              'Lack of diversification',
              'Market risks',
              'Requires knowledge and research',
            ],
            notTake: [
              '''The stock market in India can be highly volatile, and prices can fluctuate significantly in the short term, making it a riskier investment option.''',
              '''Investing solely in individual stocks can be risky as it can expose you to company-specific risks, and you may not be diversified across multiple companies or sectors.''',
              '''The Indian stock market is subject to various market risks, such as political instability, changes in regulations, and global economic conditions, which can affect the stock prices and returns.''',
              '''Investing in stocks requires knowledge and research to identify profitable companies to invest in, which can be time-consuming and requires a lot of effort.''',
            ],
          ),
        );
      case mutualFunds:
        return provider.showAdxInterstitialAd(
          myAdsIdClass: MyAdsIdClass(),
          RouteUtils.investmentDetailsScreen,
          context,
          fbInterID: '',
          googleInterID: '',
          arguments: LoanDescriptionArguments(
            investmentName: loanName,
            investmentSortDetails:
                '''Mutual funds are investment vehicles that pool money from multiple investors to purchase a diversified portfolio of stocks, bonds, or other securities. Mutual funds are managed by professional fund managers who aim to achieve the fund's investment objective, such as capital appreciation or income generation.''',
            investmentDescription1:
                '''○ Expense Ratio: This is the annual fee that covers the cost of managing the fund. 
            
○ It includes fees such as management fees, administrative fees, and other operating expenses.

○ Sales Load: Some mutual funds charge a sales load, which is a fee that is paid to a broker or financial advisor who sells the fund to investors.

○ Redemption Fee: Some mutual funds may charge a redemption fee if an investor sells their shares before a specified holding period.

○ Exchange Fee: Some mutual fund families allow investors to exchange shares of one fund for shares of another fund in the same family. An exchange fee may be charged for this transaction.''',
            investmentDescription2:
                '''One of the advantages of investing in mutual funds is diversification. By pooling money from multiple investors, mutual funds can invest in a wide range of securities and provide investors with exposure to different asset classes, industries, and geographic regions. Mutual funds are also managed by professional fund managers who have the expertise and resources to research and analyze securities and make investment decisions on behalf of investors.

One of the disadvantages of investing in mutual funds is the potential for high fees. The expense ratio and sales load can reduce returns over time, and some mutual funds may also charge additional fees for other services, such as account maintenance or transaction fees. Additionally, mutual funds are subject to market risk, and their performance can be affected by factors such as economic conditions, interest rates, and geopolitical events.''',
            investmentLoanName: mutualFunds,
            isFromInvest: true,
            take: [
              'Professional management',
              'Diversification',
              'Flexibility',
              'Low minimum investment',
            ],
            takePoints: [
              '''Mutual funds are managed by professional fund managers who have the expertise and experience to manage the investment portfolio effectively, which can help you get higher returns.''',
              '''Investing in mutual funds provides diversification across different stocks, sectors, and asset classes, which can help reduce risk and improve returns.''',
              '''Mutual funds offer various types of investment options such as equity, debt, hybrid, and thematic funds, which provide investors with a wide range of investment choices based on their financial goals and risk appetite.''',
              '''Mutual funds in India have low minimum investment requirements, making it easy for small investors to participate in the stock market.''',
            ],
            notTake: [
              '''Like any other investment, mutual funds are subject to market risks such as volatility and economic downturns, which can negatively affect the returns.''',
              '''Mutual funds charge various fees and expenses, such as management fees, entry/exit loads, and transaction charges, which can reduce the returns and impact the overall performance.''',
              '''When investing in mutual funds, you are delegating the investment decisions to the fund manager, which means you have less control over the investment choices and decisions.''',
              '''Some mutual funds may under perform their benchmarks or fail to meet the expected returns, which can result in lower returns for investors.''',
            ],
            notTakePoints: [
              'Market risks',
              'Fees and expenses',
              'Lack of control',
              'Under Performance',
            ],
          ),
        );
      case exchangeTradedFunds:
        return provider.showAdxInterstitialAd(
          myAdsIdClass: MyAdsIdClass(),
          RouteUtils.investmentDetailsScreen,
          context,
          fbInterID: '',
          googleInterID: '',
          arguments: LoanDescriptionArguments(
            investmentName: loanName,
            investmentSortDetails:
                '''Exchange-traded funds (ETFs) are similar to mutual funds in that they are investment vehicles that pool money from multiple investors to purchase a diversified portfolio of stocks, bonds, or other securities. However, ETFs are traded on stock exchanges like individual stocks, which means that their prices can fluctuate throughout the trading day.''',
            investmentDescription1:
                '''○ Expense Ratio: This is the annual fee that covers the cost of managing the ETF. It includes fees such as management fees, administrative fees, and other operating expenses.

○ Commissions: Just like buying or selling individual stocks, trading ETFs on an exchange typically involves a commission fee.

○ Bid-Ask Spread: The bid-ask spread is the difference between the price at which you can buy an ETF (the ask price) and the price at which you can sell it (the bid price). This spread represents the cost of executing a trade and can impact the returns of the ETF.''',
            investmentDescription2:
                '''○ One of the advantages of investing in ETFs is their flexibility. ETFs can be traded on exchanges throughout the trading day, which means that investors can buy and sell shares at any time. 
            
○ ETFs also offer diversification, as they provide exposure to a wide range of securities and asset classes. Additionally, ETFs typically have lower expense ratios than mutual funds, which can result in lower costs for investors.

○ One of the disadvantages of investing in ETFs is that they are subject to market risk and can experience volatility. In addition, some ETFs may track niche markets or sectors, which can result in higher risk and volatility. 

○ Finally, as with any investment, there are no guarantees that an ETF will perform well, and investors may lose money if the ETF's underlying securities decline in value.''',
            investmentLoanName: exchangeTradedFunds,
            isFromInvest: true,
            take: [
              'Low cost',
              'Diversification',
              'Easy to trade',
              'Tax efficiency',
            ],
            takePoints: [
              '''ETFs have lower expense ratios compared to mutual funds, making them a cost-effective investment option for long-term investors.''',
              '''ETFs provide investors with exposure to a diversified portfolio of stocks or other underlying assets, which helps to reduce risk.''',
              '''ETFs are listed on stock exchanges, making them easy to buy and sell, and they can be traded during market hours like stocks.''',
              '''ETFs are more tax-efficient than mutual funds because of their structure and the way they are traded on exchanges.''',
            ],
            notTake: [
              '''ETFs are subject to market risks and can experience significant volatility, especially during times of market downturns.''',
              '''ETFs are passively managed, which means that investors have limited control over the underlying assets and the investment decisions made by the fund manager.''',
              '''Some ETFs may have a narrow focus and may not provide sufficient diversification across sectors or asset classes.''',
              '''ETFs require some technical knowledge and understanding of the stock market, making them less suitable for novice investors.''',
            ],
            notTakePoints: [
              'Market risks',
              'Limited control',
              'Limited diversification',
              'Technical knowledge required',
            ],
          ),
        );
      case realEstate:
        return provider.showAdxInterstitialAd(
          myAdsIdClass: MyAdsIdClass(),
          RouteUtils.investmentDetailsScreen,
          context,
          fbInterID: '',
          googleInterID: '',
          arguments: LoanDescriptionArguments(
            investmentName: loanName,
            investmentSortDetails:
                '''Real estate investing involves buying and owning physical property such as houses, apartments, commercial buildings, or land with the expectation of generating income or appreciation over time. Real estate investing can be done through direct ownership or through real estate investment trusts (REITs), which are companies that own and manage a portfolio of real estate properties.''',
            investmentDescription1:
                '''○ Investment fees for real estate investing can vary depending on the type of investment and how it is acquired. For direct ownership, fees may include the cost of purchasing the property, property management fees, maintenance and repair costs, property taxes, insurance, and other expenses related to owning and maintaining the property. 

○ For REITs, fees may include management fees, operating expenses, and brokerage fees.''',
            investmentDescription2:
                '''○ One of the advantages of investing in real estate is that it can provide a steady income stream through rental income. 

○ Additionally, real estate can appreciate in value over time, providing potential capital gains when the property is sold. Real estate investing can also provide tax benefits, such as deductions for mortgage interest, property taxes, and depreciation.

○ One of the disadvantages of investing in real estate is that it can require a significant upfront investment and ongoing expenses such as maintenance and repair costs. 

○ Real estate investments can also be illiquid, meaning that it may take time to sell the property and access your investment capital. Additionally, real estate investments can be affected by various factors such as interest rates, economic conditions, and local real estate market trends. 

○ Finally, real estate investing can be time-consuming and require a significant amount of research and due diligence before making an investment decision.''',
            investmentLoanName: realEstate,
            isFromInvest: true,
            take: [
              '''Real estate has historically appreciated in value over the long-term, providing investors with the potential for capital gains.''',
              '''Real estate can provide a regular rental income stream, which can supplement other sources of income and provide a steady cash flow.''',
              '''Real estate is a tangible asset that can provide a hedge against inflation, as the value of property tends to rise with inflation.''',
              '''Real estate provides diversification from traditional investment options like stocks and bonds, and can help to reduce overall portfolio risk.''',
            ],
            takePoints: [
              'Appreciation in value',
              'Rental income',
              'Hedge against inflation',
              'Diversification',
            ],
            notTake: [
              '''Real estate requires a significant upfront investment, including down payments, legal fees, and maintenance costs.''',
              '''Real estate is an illiquid asset, which means that it can be difficult to sell quickly in case of emergencies or financial needs.''',
              '''Real estate values can be affected by factors such as economic conditions, interest rates, and government policies, which can lead to fluctuations in value.''',
              '''Real estate investments require ongoing management and maintenance, which can be time-consuming and expensive.''',
            ],
            notTakePoints: [
              'High upfront costs',
              'Illiquidity',
              'Market risks',
              'Management and maintenance costs',
            ],
          ),
        );
      case cryptocurrencies:
        return provider.showAdxInterstitialAd(
          myAdsIdClass: MyAdsIdClass(),
          RouteUtils.investmentDetailsScreen,
          context,
          fbInterID: '',
          googleInterID: '',
          arguments: LoanDescriptionArguments(
            investmentName: loanName,
            investmentSortDetails:
                '''Cryptocurrencies are digital or virtual tokens that use cryptography to secure and verify transactions and to control the creation of new units. Cryptocurrencies are decentralized, meaning that they are not issued or regulated by governments or financial institutions, but instead operate on a distributed ledger technology called blockchain.''',
            investmentDescription1:
                '''○ Investment fees for cryptocurrencies can vary depending on the platform or exchange used to buy, sell, and hold cryptocurrencies. Fees may include trading fees, deposit and withdrawal fees, and network transaction fees, which are fees paid to miners to process transactions on the blockchain.''',
            investmentDescription2:
                '''○ One of the advantages of investing in cryptocurrencies is that they offer potential for high returns, as the value of cryptocurrencies can fluctuate rapidly and significantly. 

○ Additionally, cryptocurrencies are decentralized and operate on a peer-to-peer network, which can provide increased security and privacy compared to traditional financial transactions. 

○ Cryptocurrencies can also be used for a variety of purposes, including as a means of payment, as a store of value, or as a speculative investment.

○ One of the disadvantages of investing in cryptocurrencies is their volatility and lack of regulation. The value of cryptocurrencies can fluctuate rapidly and significantly, and investors can lose money if they buy at a high price and sell at a low price. 

○ Cryptocurrencies are also not backed by any government or financial institution, which can increase the risk of fraud, hacking, or other security breaches. Additionally, the regulatory environment for cryptocurrencies is still evolving, and there is uncertainty about how cryptocurrencies will be regulated in the future. Finally, cryptocurrencies can be complex and difficult to understand, and investing in them requires a significant amount of research and due diligence.''',
            investmentLoanName: cryptocurrencies,
            isFromInvest: true,
            takePoints: [
              'Potential for high returns',
              'Decentralized nature',
              'Increasing adoption',
              'Lower transaction fees',
            ],
            take: [
              '''Cryptocurrencies have the potential for high returns due to their volatile nature, and investors who are willing to take risks may benefit from this.''',
              '''Cryptocurrencies are decentralized, meaning that they are not controlled by any government or financial institution, which can make them appealing to investors who want to avoid traditional banking systems.''',
              '''Cryptocurrencies are gaining increasing acceptance and adoption in India, with more merchants and businesses accepting them as payment, which can lead to higher demand and potentially higher prices.''',
              '''Cryptocurrencies generally have lower transaction fees compared to traditional banking systems, which can make them attractive to investors who want to save on fees.''',
            ],
            notTakePoints: [
              '''Cryptocurrencies are not yet regulated in India, and the government has expressed concerns about their use in illegal activities. This uncertainty can lead to market volatility and potential risks for investors.''',
              '''Cryptocurrency investments are vulnerable to cyber attacks and hacking, which can result in the loss of investments.''',
              '''While the adoption of cryptocurrencies is increasing in India, they are not yet widely accepted as payment, which can limit their value and demand.''',
              '''Cryptocurrencies do not have any intrinsic value, and their value is solely determined by market demand, which can make them more speculative and risky compared to traditional investments.''',
            ],
            notTake: [
              'Regulatory uncertainty',
              'Lack of security',
              'Limited acceptance',
              'Lack of intrinsic value',
            ],
          ),
        );
    }
  }

  Widget loanProductsContainer(String img, String title) {
    return BounceClickWidget(
      onTap: () {
        getLoanDetails(title);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: ColorUtils().greyBGColor2,
          boxShadow: const [
            BoxShadow(
                blurRadius: 25,
                spreadRadius: -20,
                color: Colors.black,
                offset: Offset(0, 5)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage(img),
              height: 40,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: FontUtils.h10(fontWeight: FWT.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, String>> secureInvestmentsList = [
    {
      'img': AssetUtils.icSaving,
      'name': 'Savings Accounts',
    },
    {
      'img': AssetUtils.icDeposite,
      'name': 'Certificates of Deposit',
    },
    {
      'img': AssetUtils.icMoneyMarket,
      'name': 'Money market Accounts',
    },
    {
      'img': AssetUtils.icBonds,
      'name': 'Bonds',
    },
  ];

  List<Map<String, String>> inSecureInvestmentsList = [
    {
      'img': AssetUtils.icStocks,
      'name': 'Stocks',
    },
    {
      'img': AssetUtils.icMutualFunds,
      'name': 'Mutual funds',
    },
    {
      'img': AssetUtils.icEtf,
      'name': 'Exchange-traded funds',
    },
    {
      'img': AssetUtils.icRealEstate,
      'name': 'Real estate',
    },
    {
      'img': AssetUtils.icCrypto,
      'name': 'Cryptocurrencies',
    },
  ];
}

// class InvestmentDetailsScreenArguments {
//   final String? investmentName;
//   final String? investmentSortDetails;
//   final String? investmentDescription1;
//   final String? investmentDescription2;
//   final String? investmentLoanName;
//   final bool? isFromInvest;
//   final List<String>? investmentTakeOverview;
//   final List<String>? investmentTakePoints;
//   final List<String>? investmentNotTakeOverview;
//   final List<String>? investmentNotTakePoints;

//   InvestmentDetailsScreenArguments({
//     this.investmentTakeOverview,
//     this.investmentTakePoints,
//     this.investmentNotTakeOverview,
//     this.investmentNotTakePoints,
//     this.isFromInvest,
//     this.investmentLoanName,
//     this.investmentName,
//     this.investmentSortDetails,
//     this.investmentDescription1,
//     this.investmentDescription2,
//   });
// }
