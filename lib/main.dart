import 'package:easy_localization/easy_localization.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:instant_pay/utilities/colors/color.dart';
import 'package:instant_pay/utilities/storage/storage.dart';
import 'package:instant_pay/utilities/storage/storage_utils.dart';
import 'package:instant_pay/view/screen/splash/view/splash_screen.dart';
import 'package:instant_pay/view/widget/internet_connectivity_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'utilities/routes/provider_bindings.dart';
import 'utilities/routes/route_utils.dart';

///
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await dotenv.load(fileName: ".env");

  MobileAds.instance.initialize();
  ColorUtils.themeColor = LightTheme();
  StorageUtils.prefs = await SharedPreferences.getInstance();
  MobileAds.instance.updateRequestConfiguration(RequestConfiguration(
      testDeviceIds: ['294449C3CD34F90F1EA87EF0A43723A7']));
  FacebookAudienceNetwork.init(

      // iOSAdvertiserTrackingEnabled: true //default false
      );

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    return runApp(
      EasyLocalization(
          path: 'assets/translations',
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('hi', 'IN'),
            Locale('gu', 'IN'),
          ],
          startLocale: const Locale('en', 'US'),
          fallbackLocale: const Locale('en', 'US'),
          child: const QuickLoanApp()),
    );
  });
}

class QuickLoanApp extends StatefulWidget {
  const QuickLoanApp({Key? key}) : super(key: key);
  @override
  State<QuickLoanApp> createState() => _QuickLoanAppState();
}

class _QuickLoanAppState extends State<QuickLoanApp>
    with WidgetsBindingObserver {
  late ConnectivityIndicatorWidget indicator;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    indicator = const ConnectivityIndicatorWidget();

    return MultiProvider(
      providers: ProviderBindings.providers,
      child: MaterialApp(
        locale: context.locale,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('hi', 'IN'),
          Locale('gu', 'IN'),
        ],
        builder: _builder,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            scaffoldBackgroundColor: ColorUtils().greyBGColor,
            appBarTheme: AppBarTheme(
              backgroundColor: ColorUtils.themeColor.oxff673AB7,
            )),
        initialRoute: RouteUtils.splashScreen,
        onGenerateRoute: RouteUtils.onGenerateRoute,
        home: const SplashScreen(),
      ),
    );
  }

  Widget _builder(BuildContext context, Widget? child) {
    return Stack(
      children: <Widget>[
        MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: 1.0,
          ),
          child: Stack(
            children: [ 
              ClipRRect(child: child),
              indicator,
            ],
          ),
        ),
      ],
    );
  }
}