import 'package:flutter/material.dart';
import 'package:instant_pay/utilities/assets/asset_utils.dart';
import 'package:instant_pay/utilities/colors/color.dart';
import 'package:instant_pay/utilities/font/font_utils.dart';
import 'package:instant_pay/utilities/routes/routes.dart';
import 'package:instant_pay/view/screen/dashboard/home/loan_short_description_screen.dart';
import 'package:instant_pay/view/screen/dashboard/home/model/available_ads_response.dart';
import 'package:instant_pay/view/widget/ads_widget/interstitial_ads_widget.dart';
import 'package:instant_pay/view/widget/center_text_button_border_widget.dart';
import 'package:provider/provider.dart';

class InsuranceScreen extends StatefulWidget {
  const InsuranceScreen({super.key});

  @override
  State<InsuranceScreen> createState() => _InsuranceScreenState();
}

class _InsuranceScreenState extends State<InsuranceScreen> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Expanded(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: insuranceData.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[350]!),
                      borderRadius: BorderRadius.circular(12),
                      color: ColorUtils.themeColor.oxffFFFFFF,
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: screenSize.width,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                            color: Colors.grey[350],
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                insuranceData[index].name!.toUpperCase(),
                                style: FontUtils.h16(
                                  fontColor: ColorUtils.themeColor.oxff000000,
                                  fontWeight: FWT.bold,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            children: [
                              const SizedBox(height: 15),
                              Image(
                                image: AssetImage(insuranceData[index].img!),
                                height: 100,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '''${insuranceData[index].shortDescription}''',
                                textAlign: TextAlign.center,
                                style: FontUtils.h14(
                                  fontColor: ColorUtils.themeColor.oxff000000,
                                  fontWeight: FWT.medium,
                                ),
                              ),
                              const SizedBox(height: 10),
                              CenterTextButtonBorderWidget(
                                width: screenSize.width * 0.30,
                                height: screenSize.width * 0.10,
                                title: Text('MORE GUIDANCE',
                                    style: FontUtils.h12(
                                        fontWeight: FWT.semiBold)),
                                onTap: () {
                                  final provider = Provider.of<
                                          InterstitialAdsWidgetProvider>(
                                      context,
                                      listen: false);
                                  provider.showAdxInterstitialAd(
                                    myAdsIdClass: MyAdsIdClass(),
                                    RouteUtils.dashboardMoreLoansScreen,
                                    context,
                                    arguments: insuranceData[index].arguments,
                                    fbInterID: '',
                                    googleInterID: '',
                                  );
                                },
                              ),
                              const SizedBox(height: 15),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  List<LoansInsuranceDetailsData> insuranceData = [
    LoansInsuranceDetailsData(
      name: 'Life Insurance',
      img: AssetUtils.icLifeInsurance,
      shortDescription:
          '''Financial protection to the policyholder's family in case of the policyholder's death.''',
      arguments: LoanDescriptionArguments(
        loanName: 'Life Insurance',
        titleList: [
          'Life Insurance Policy',
          'Types of Life Insurance Policies',
          'Coverage Amount',
          'Exclusions and Limitations',
          'Premium Amount',
          'Claims',
          'Renewal and Cancellation',
          'Benefits',
        ],
        titleOverViewList: [
          '''👉 Provides financial security to the insured's beneficiaries in case of their death.
👉 Can be purchased by an individual or provided by an employer as part of a benefits package.
👉 Can be customized to fit the insured's specific needs and financial situation.''',
          '''👉 Term life insurance: provides coverage for a specific term or period, typically ranging from 1 to 30 years.
👉 Offers a lump sum payout to the beneficiaries if the policyholder dies during the term of the policy.
👉 Usually less expensive than whole life insurance.
👉 Whole life insurance: provides lifelong coverage and typically has a cash value component that grows over time.
👉 Offers a guaranteed payout to the beneficiaries upon the policyholder's death.
👉 May be more expensive than term life insurance.''',
          '''👉 Determined by the insured's needs and financial situation.
👉 May be adjusted over time as circumstances change.''',
          '''👉 May include suicide, self-inflicted injuries, or death during the commission of a crime.
👉 May require medical underwriting or a medical exam before approval.''',
          '''👉 Based on the insured's age, health, and coverage amount.
👉 Can be paid monthly or annually.''',
          '''👉 Beneficiaries must file a claim with the insurance company and provide necessary documentation to receive the payout.
👉 The claims process can be lengthy and may require additional documentation or information.''',
          '''👉 Policyholders may be able to renew or convert their policy, or cancel it for a refund, depending on the terms and conditions of the policy.
👉 Cancelling a policy may result in penalties or fees.''',
          '''👉 Provides peace of mind and financial security for the insured's loved ones in case of unexpected events.
👉 Can be a valuable tool for estate planning and transferring wealth to future generations.''',
        ],
      ),
    ),
    LoansInsuranceDetailsData(
      name: 'Health Insurance',
      img: AssetUtils.icHealthInsurance,
      shortDescription:
          '''Provides coverage for medical expenses, hospitalization, and other healthcare costs.''',
      arguments: LoanDescriptionArguments(
        loanName: 'Health Insurance',
        titleList: [
          'Health Insurance Policy',
          'Types of Health Insurance Policies',
          'Coverage Details',
          'Premium Amount',
          'Deductible',
          'Copayment',
          'Coinsurance',
          'Claims',
          'Renewal and Cancellation',
          'Benefits',
        ],
        titleOverViewList: [
          '''👉 Provides financial coverage for medical expenses and treatment to the insured.
👉 Can be purchased by an individual or provided by an employer as part of a benefits package.
👉 Can be customized to fit the insured's specific needs and financial situation.''',
          '''👉 Indemnity Plans: allow the insured to choose their own doctors and hospitals without restriction, but may require higher out-of-pocket costs.
👉 Managed Care Plans: provide access to a network of doctors and hospitals, and may offer lower out-of-pocket costs, but may have more restrictions on choice of providers.
👉 High-deductible Health Plans (HDHPs): have lower premiums but require the insured to pay a high deductible before insurance coverage kicks in.''',
          '''👉 Varies based on the type of policy and the specific plan chosen.
👉 May include hospitalization, surgery, doctor visits, prescription drugs, and other medical services.''',
          '''👉 Based on the insured's age, health status, and coverage amount.
👉 Can be paid monthly or annually.''',
          '''👉 The amount the insured must pay before insurance coverage begins.
👉 May be waived for certain preventive care services.''',
          '''👉 A fixed amount the insured pays for medical services, such as doctor visits or prescription drugs.''',
          '''👉 The percentage of medical expenses the insured must pay after the deductible is met.
👉 Maximum Out-of-Pocket:
👉 The maximum amount the insured must pay for covered medical expenses in a given year.''',
          '''👉 The insured must file a claim with the insurance company to receive reimbursement for medical expenses.
👉 Claims may be subject to review and approval by the insurance company.''',
          '''👉 Policies may be renewed annually or on a multi-year basis.
👉 Policies may be cancelled by the insurer or the insured under certain circumstances.''',
          '''👉 Provides financial security and peace of mind in case of unexpected medical expenses.
👉 Can help the insured receive necessary medical treatment and services without incurring excessive costs.''',
        ],
      ),
    ),
    LoansInsuranceDetailsData(
      name: 'Motor Insurance',
      img: AssetUtils.icMotorInsurance,
      shortDescription:
          '''👉 Provides coverage for damages or loss to vehicles and third-party liability.''',
      arguments: LoanDescriptionArguments(
        loanName: 'Motor Insurance',
        titleList: [
          'Overview',
          'Types of Motor Insurance Policies',
          'Coverage Details',
          'Premium Amount',
          'Deductible',
          'No Claim Bonus',
          'Claims',
          'Renewal and Cancellation',
          'Benefits',
        ],
        titleOverViewList: [
          '''👉 Provides financial protection against damages to the insured's vehicle or third-party property damage or bodily injury due to an accident.
👉 Can be customized to fit the insured's specific needs and financial situation.
👉 Mandatory as per Indian law for all vehicles plying on the roads.''',
          '''👉 Third-party Insurance: Covers third-party liability for damage or injury caused to a third-party by the insured vehicle.
👉 Comprehensive Insurance: Provides coverage for third-party liability as well as own damage to the insured vehicle.
👉 Add-on Covers: Optional additional coverage for specific events such as engine protection, zero depreciation, and roadside assistance.''',
          '''👉 May include accidental damage, theft, fire, natural disasters, and third-party liability.''',
          '''👉 Based on the type of policy, vehicle type, usage, and the insured's driving history.
👉 Can be paid monthly or annually.''',
          '''👉 The amount the insured must pay before insurance coverage begins.''',
          '''👉 A discount on the premium given to the insured for each claim-free year.''',
          '''👉 The insured must file a claim with the insurance company to receive reimbursement for damages.
👉 Claims may be subject to review and approval by the insurance company.''',
          '''👉 Policies may be renewed annually or on a multi-year basis.
👉 Policies may be cancelled by the insurer or the insured under certain circumstances.''',
          '''👉 Provides financial security and peace of mind in case of accidents or damages to the vehicle.
👉 Mandatory as per Indian law for all vehicles plying on the roads.''',
        ],
      ),
    ),
    LoansInsuranceDetailsData(
      name: 'Travel Insurance',
      img: AssetUtils.icTravelInsurance,
      shortDescription:
          '''👉 Provides coverage for travel-related risks like trip cancellation, medical emergencies, and lost baggage.''',
      arguments: LoanDescriptionArguments(
        loanName: 'Travel Insurance',
        titleList: [
          'Overview',
          'Types of Travel Insurance Policies',
          'Coverage Details',
          'Premium Amount',
          'Deductible',
          'Claims',
          'Renewal and Cancellation',
          'Benefits',
        ],
        titleOverViewList: [
          '''👉 Provides financial protection against unforeseen events that may occur while traveling domestically or internationally.
👉 Can be customized to fit the insured's specific needs and financial situation.''',
          '''👉 Single Trip Insurance: Provides coverage for one trip.
👉 Multi-Trip Insurance: Provides coverage for multiple trips within a specified period.
👉 Family Travel Insurance: Provides coverage for the entire family traveling together.''',
          '''👉 May include medical expenses, emergency evacuation, trip cancellation, trip interruption, loss of baggage, and personal liability.''',
          '''👉 Based on the type of policy, coverage amount, destination, duration, and the insured's age.
👉 Can be paid monthly or annually.''',
          '''👉 The amount the insured must pay before insurance coverage begins.''',
          '''👉 The insured must file a claim with the insurance company to receive reimbursement for expenses incurred.
👉 Claims may be subject to review and approval by the insurance company.''',
          '''👉 Policies may be renewed annually or on a multi-year basis.
👉 Policies may be cancelled by the insurer or the insured under certain circumstances.''',
          '''👉 Provides financial security and peace of mind in case of unforeseen events while traveling.
👉 Can cover medical expenses, which can be quite high in foreign countries.
👉 May cover trip cancellation and interruption, which can save the insured money in case of unexpected events.
👉 Can provide emergency evacuation, which can be crucial in case of a medical emergency.
👉 Can provide coverage for loss of baggage and personal liability.''',
        ],
      ),
    ),
    LoansInsuranceDetailsData(
      name: 'Home Insurance',
      img: AssetUtils.icHomeInsurance,
      shortDescription:
          '''👉 Provides coverage for damages or loss to homes and their contents due to natural disasters, theft, or other events.''',
      arguments: LoanDescriptionArguments(
        loanName: 'Home Insurance',
        titleList: [
          'Overview',
          'Types of Home Insurance Policies',
          'Coverage Details',
          'Premium Amount',
          'Deductible',
          'Claims',
          'Renewal and Cancellation',
          'Benefits',
        ],
        titleOverViewList: [
          '''👉 Provides financial protection against damage or loss to the insured's home and belongings.
👉 Can be customized to fit the insured's specific needs and financial situation.''',
          '''👉 Building Insurance: Covers the structure of the house and any permanent fixtures.
👉 Contents Insurance: Covers personal belongings and household items.
👉 Comprehensive Insurance: Covers both building and contents.''',
          '''👉 May include damage or loss due to fire, lightning, explosion, theft, vandalism, storm, flood, and subsidence.
👉 May include liability coverage for any accidents that occur on the property.''',
          '''👉 Based on the type of policy, coverage amount, location, and the insured's claims history.
👉 Can be paid monthly or annually.''',
          '''👉 The amount the insured must pay before insurance coverage begins.''',
          '''👉 The insured must file a claim with the insurance company to receive reimbursement for damage or loss.
👉 Claims may be subject to review and approval by the insurance company.''',
          '''👉 Policies may be renewed annually or on a multi-year basis.
👉 Policies may be cancelled by the insurer or the insured under certain circumstances.''',
          '''👉 Provides financial security and peace of mind in case of damage or loss to the insured's home and belongings.
👉 Can cover the cost of repairs or replacement of damaged or lost items.
👉 May provide liability coverage for any accidents that occur on the property.
👉 Can be customized to fit the insured's specific needs and budget.''',
        ],
      ),
    ),
  ];
}

class LoansInsuranceDetailsData {
  final String? name;
  final String? img;
  final String? shortDescription;
  final LoanDescriptionArguments? arguments;

  LoansInsuranceDetailsData(
      {this.name, this.img, this.shortDescription, this.arguments});
}
