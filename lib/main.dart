import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_app_structure/data/network/connectivity_service.dart';
import 'package:flutter_app_structure/injection.dart';
import 'package:flutter_app_structure/nav.dart';
import 'package:flutter_app_structure/utils/routes/routes_name.dart';
import 'package:flutter_app_structure/view/home/home_view.dart';
import 'package:flutter_app_structure/view/profile/profile_view.dart';
import 'package:flutter_app_structure/view_model/home/home_view_models.dart';
import 'package:flutter_app_structure/view_model/profile/profile_view_model.dart';
import 'package:flutter_app_structure/view_model/user_preference/user_preference_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

var screenHeight = 0.0;
var screenWidth = 0.0;
String? userID = "";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _init();
  runApp(const MainApp());
}

Future<void> _init() async {
  await EasyLocalization.ensureInitialized();
  await initializeDateFormatting();

  await setupModules();
  await dotenv.load(fileName: ".env");
  Get.put(ConnectivityService());
  await _getEmployeeID();
}

Future<void> _getEmployeeID() async {
  final UserPreference userPreference = getIt.get<UserPreference>();

  userID = await userPreference.getUserId();
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late GoRouter _router;
  late AppStateNotifier appStateNotifier;
  @override
  void initState() {
    super.initState();
    appStateNotifier = AppStateNotifier();
    _router = createRouter(appStateNotifier);
    myRouter = _router;

    // if (myRouter?.currentRouteName != RouteName.splash) {
    appStateNotifier.clearRedirectLocation();
    myRouter?.goNamed(RouteName.splash);
    // }
  }

  @override
  void dispose() {
    _router.dispose();
    myRouter = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    ScreenUtil.init(context, designSize: Size(screenWidth, screenHeight));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => getIt<HomeViewModel>(),
          child: HomeView(),
        ),
       
        ChangeNotifierProvider(
          create: (context) => getIt<ProfileViewModel>(),
          child: ProfileView(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: true,
        title: 'Expense App',
        theme: ThemeData(
          fontFamily: 'Manrope',
          appBarTheme: const AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.dark,
            ),
          ),
        ),
        routerDelegate: _router.routerDelegate,
        routeInformationParser: _router.routeInformationParser,
        routeInformationProvider: _router.routeInformationProvider,
      ),
    );
  }
}
