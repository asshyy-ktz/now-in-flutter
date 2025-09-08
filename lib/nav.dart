import 'package:flutter_app_structure/models/login/login_response.dart';
import 'package:flutter_app_structure/utils/components/will_pop_scope.dart';
import 'package:flutter_app_structure/utils/navigation_service.dart';
import 'package:flutter_app_structure/utils/page_transition_helper.dart';
import 'package:flutter_app_structure/utils/routes/routes_name.dart';
import 'package:flutter_app_structure/utils/serialization_util.dart';
import 'package:flutter_app_structure/view/dashboard/dashboard.dart';
import 'package:flutter_app_structure/view/home/home_view.dart';
import 'package:flutter_app_structure/view/profile/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_structure/view/splash/splash_view.dart';
import 'package:go_router/go_router.dart';

const kTransitionInfoKey = '__transition_info__';

class AppStateNotifier extends ChangeNotifier {
  LoginResponse? user;
  bool loggedIn = false;

  bool showSplashImage = false;
  String? _redirectLocation;

  bool notifyOnAuthChange = true;

  bool get loading => showSplashImage;
  bool get shouldRedirect => loggedIn && _redirectLocation != null;

  String getRedirectLocation() => _redirectLocation!;
  bool hasRedirect() => _redirectLocation != null;
  void setRedirectLocationIfUnset(String loc) => _redirectLocation ??= loc;
  void clearRedirectLocation() => _redirectLocation = null;

  /// Mark as not needing to notify on a sign in / out when we intend
  /// to perform subsequent actions (such as navigation) afterwards.
  void updateNotifyOnAuthChange(bool notify) => notifyOnAuthChange = notify;

  void update(LoginResponse newUser) {
    user = newUser;
    if (notifyOnAuthChange) {
      notifyListeners();
    }
    updateNotifyOnAuthChange(true);
  }

  void updateLoginState(bool state) {
    showSplashImage = false;
    loggedIn = state;
    if (notifyOnAuthChange) {
      notifyListeners();
    }
    updateNotifyOnAuthChange(true);
  }

  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners();
  }
}

// used for routing through the app
GoRouter? myRouter;

GoRouter createRouter(AppStateNotifier appStateNotifier) => GoRouter(
  initialLocation: RouteName.splash,
  navigatorKey: NavigationService.navigatorKey,
  debugLogDiagnostics: true,
  refreshListenable: appStateNotifier,
  observers: [HeroController()],
  errorBuilder: (context, _) {
    return Scaffold(body: Center(child: Text('404 Not Found')));
  },
  routes: [
    StatefulShellRoute.indexedStack(
      parentNavigatorKey: NavigationService.navigatorKey,
      restorationScopeId: NavigationService.navigatorKey.toString(),
      builder: (context, state, navigationShell) => MyWillPopScope(
        onWillPop: () async {
          return (true, null);
        },
        child: Dashboard(
          navigationShell: navigationShell,
          appStateNotifier: appStateNotifier,
        ),
      ),
      branches: [
        StatefulShellBranch(
          navigatorKey: NavigationService.homeNavigatorKey,
          initialLocation: RouteName.home,
          preload: true,
          routes: [
            MyRoute(
              name: RouteName.home,
              path: RouteName.home,
              requireTransition: false,
              builder: (context, params) {
                bool isUserLoggedIn =
                    params.getParam('isUserLoggedIn', ParamType.bool) ?? false;
                return HomeView(isUserAlreadyLoggedIn: isUserLoggedIn);
              },
              routes:                         [
                        ]).toRoute(
              appStateNotifier,
              parentNavigatorKey: NavigationService.homeNavigatorKey,
            ),
          ],
        ),

        // StatefulShellBranch(
        //   initialLocation: RouteName.garage,
        //   navigatorKey: NavigationService.garageNavigatorKey,
        //   preload: true,
        //   routes: [
        //     MyRoute(
        //       name: RouteName.garage,
        //       path: RouteName.garage,
        //       builder: (context, _) => MyWillPopScope(
        //         onWillPop: () async => (true, null),
        //         child: GarageView(),
        //       ),
        //     ).toRoute(
        //       appStateNotifier,
        //       parentNavigatorKey: NavigationService.garageNavigatorKey,
        //     ),
        //   ],
        // ),

        // StatefulShellBranch(
        //   initialLocation: RouteName.createAppointment,
        //   navigatorKey: NavigationService.createAppointmentNavigatorKey,
        //   preload: true,
        //   routes: [
        //     MyRoute(
        //       name: RouteName.createAppointment,
        //       path: RouteName.createAppointment,
        //       builder: (context, _) => MyWillPopScope(
        //         onWillPop: () async => (true, null),
        //         child: AppointmentView(),
        //       ),
        //     ).toRoute(
        //       appStateNotifier,
        //       parentNavigatorKey:
        //           NavigationService.createAppointmentNavigatorKey,
        //     ),
        //   ],
        // ),
        StatefulShellBranch(
          navigatorKey: NavigationService.profileNavigatorKey,
          initialLocation: RouteName.profileScreen,
          routes: [
            MyRoute(
              name: RouteName.profileScreen,
              path: RouteName.profileScreen,
              builder: (context, _) => MyWillPopScope(
                onWillPop: () async => (true, null),
                child: ProfileView(),
              ),
            ).toRoute(
              appStateNotifier,
              parentNavigatorKey: NavigationService.profileNavigatorKey,
            ),
          ],
        ),
      ],
    ),
    // MyRoute(
    //   name: RouteName.splash,
    //   path: RouteName.splash,
    //   builder: (context, _) => MyWillPopScope(
    //     onWillPop: () async => (true, null),
    //     child: SplashView(),
    //   ),
    // ).toRoute(
    //   appStateNotifier,
    //   parentNavigatorKey: NavigationService.navigatorKey,
    // ),

    // MyRoute(
    //   name: RouteName.intro,
    //   path: RouteName.intro,
    //   builder: (context, _) => MyWillPopScope(
    //     onWillPop: () async => (true, null),
    //     child: IntroView(),
    //   ),
    // ).toRoute(
    //   appStateNotifier,
    //   parentNavigatorKey: NavigationService.navigatorKey,
    // ),
    // MyRoute(
    //   name: RouteName.login,
    //   path: RouteName.login,
    //   builder: (_, __) => MyWillPopScope(
    //     onWillPop: () async => (true, null),
    //     child: const LoginView(),
    //   ),
    // ).toRoute(
    //   appStateNotifier,
    //   parentNavigatorKey: NavigationService.navigatorKey,
    // ),
  ],
);

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
    entries.where((e) => e.value != null).map((e) => MapEntry(e.key, e.value!)),
  );
}

extension NavigationExtensions on BuildContext {
  void goNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> params = const <String, String>{},
    Map<String, String> queryParams = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) => !mounted
      ? null
      : goNamed(
          name,
          pathParameters: params,
          queryParameters: queryParams,
          extra: extra,
        );

  void pushNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> params = const <String, String>{},
    Map<String, String> queryParams = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) => !mounted
      ? null
      : pushNamed(
          name,
          pathParameters: params,
          queryParameters: queryParams,
          extra: extra,
        );

  void safePop() {
    if (GoRouter.of(this).routerDelegate.currentConfiguration.matches.length <=
        1) {
      go('/');
    } else {
      pop();
    }
  }
}

extension _GoRouterStateExtensions on GoRouterState {
  Map<String, dynamic> get extraMap =>
      extra != null ? extra as Map<String, dynamic> : {};
  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(pathParameters)
    ..addAll(extraMap);

  // TODO:- to be removed
  // TransitionInfo get transitionInfo => extraMap.containsKey(kTransitionInfoKey)
  //     ? extraMap[kTransitionInfoKey] as TransitionInfo
  //     : TransitionInfo.appDefault();

  TransitionInfo getTransitionInfo(String name) {
    switch (name) {
      default:
        return TransitionInfo.appDefault();
    }
  }
}

class StayXRouteParameters {
  StayXRouteParameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};
  bool get isEmpty =>
      state.allParams.isEmpty ||
      (state.extraMap.length == 1 &&
          state.extraMap.containsKey(kTransitionInfoKey));

  bool isAsyncParam(MapEntry<String, dynamic> param) =>
      asyncParams.containsKey(param.key) && param.value is String;
  bool get hasFutures => state.allParams.entries.any(isAsyncParam);
  Future<bool> completeFutures() => Future.wait(
    state.allParams.entries.where(isAsyncParam).map((param) async {
      final doc = await asyncParams[param.key]!(
        param.value,
      ).onError((_, __) => null);
      if (doc != null) {
        futureParamValues[param.key] = doc;
        return true;
      }
      return false;
    }),
  ).onError((_, __) => [false]).then((v) => v.every((e) => e));
  dynamic getParam<T>(
    String paramName,
    ParamType type, [
    bool isList = false,
    List<String>? collectionNamePath,
  ]) {
    if (futureParamValues.containsKey(paramName)) {
      return futureParamValues[paramName];
    }
    if (!state.allParams.containsKey(paramName)) {
      return null;
    }
    final param = state.allParams[paramName];
    if (param is! String) {
      return param;
    }
    return deserializeParam<T>(param, type, isList, collectionNamePath);
  }
}

extension GoRouterExtensions on GoRouter {
  AppStateNotifier get appState => (routerDelegate.state as AppStateNotifier);
  void prepareAuthEvent([bool ignoreRedirect = false]) =>
      appState.hasRedirect() && !ignoreRedirect
      ? null
      : appState.updateNotifyOnAuthChange(false);
  bool shouldRedirect(bool ignoreRedirect) =>
      !ignoreRedirect && appState.hasRedirect();
  void clearRedirectLocation() => appState.clearRedirectLocation();

  String get currentRouteName =>
      routerDelegate.currentConfiguration.last.route.name ?? "";

  String getMainRoute(int index) {
    switch (index) {
      case 0:
        return RouteName.home;
      case 1:
        return RouteName.profileScreen;
      case 2:
      default:
        return RouteName.home;
    }
  }

  void popUntil(String routeName) {
    var _currentRouteName = currentRouteName;
    while (_currentRouteName != routeName &&
        _currentRouteName.isNotEmpty &&
        canPop()) {
      pop();
      _currentRouteName = currentRouteName;
    }
  }

  void pushNamedAndRemoveUntil(String path, {Object? extra = null}) {
    while (canPop() == true &&
        routerDelegate.currentConfiguration.matches.length > 1) {
      pop();
    }
    pushReplacementNamed(path, extra: extra);
  }

  void pushNamedSafe(String path, {Object? extra = null}) {
    if (currentRouteName != path) {
      pushNamed(path, extra: extra);
    }
  }
}

class MyRoute {
  const MyRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireTransition = true,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final bool requireTransition;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, StayXRouteParameters) builder;
  final List<GoRoute> routes;

  GoRoute toRoute(
    AppStateNotifier appStateNotifier, {
    GlobalKey<NavigatorState>? parentNavigatorKey,
  }) => GoRoute(
    name: name,
    path: path,
    parentNavigatorKey: parentNavigatorKey,
    redirect: ((context, state) {
      // todo: implement redirect
      // }
      return null;
    }),
    pageBuilder: (context, state) {
      final stayXRouteParams = StayXRouteParameters(state, asyncParams);
      final page = stayXRouteParams.hasFutures
          ? FutureBuilder(
              future: stayXRouteParams.completeFutures(),
              builder: (context, _) => builder(context, stayXRouteParams),
            )
          : builder(context, stayXRouteParams);
      final child = appStateNotifier.loading ? SplashView() : page;

      // final transitionInfo = state.transitionInfo;
      final transitionInfo = state.getTransitionInfo(path);
      return requireTransition && transitionInfo.hasTransition
          ? CustomTransitionPage(
              key: state.pageKey,
              child: child,
              opaque: transitionInfo.opaque,
              maintainState: transitionInfo.maintainState,
              transitionDuration: transitionInfo.duration,
              fullscreenDialog: transitionInfo.fullscreenDialog,
              transitionsBuilder: PageTransition(
                key: state.pageKey,
                type: transitionInfo.transitionType,
                duration: transitionInfo.duration,
                alignment: transitionInfo.alignment,
                child: child,
              ).transitionsBuilder,
            )
          : MaterialPage(
              key: state.pageKey,
              child: child,
              maintainState: transitionInfo.maintainState,
              fullscreenDialog: transitionInfo.fullscreenDialog,
            );
    },
    routes: routes,
  );
}

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.leftToRight,
    this.duration = const Duration(milliseconds: 450),
    this.opaque = true,
    this.maintainState = true,
    this.fullscreenDialog = false,
    this.alignment,
  });

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;
  final opaque;
  final maintainState;
  final fullscreenDialog;

  static TransitionInfo appDefault() => TransitionInfo(
    hasTransition: true,
    transitionType: PageTransitionType.fade,
    duration: Duration(milliseconds: 400),
  );

  static TransitionInfo leftToRightTransition() => TransitionInfo(
    hasTransition: true,
    transitionType: PageTransitionType.leftToRight,
    duration: Duration(milliseconds: 400),
  );
}
