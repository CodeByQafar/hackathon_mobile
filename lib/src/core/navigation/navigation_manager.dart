import '../../feature/auth/screens/forgot_password_view.dart';
import '../../feature/auth/screens/verify_code_view.dart';
import '../../feature/auth/screens/welcome_view.dart';
import '../../feature/auth/screens/signin_view.dart';
import '../../feature/auth/screens/signup_view.dart';
import '../../feature/home/home_view.dart';
import 'package:flutter/material.dart';

import '../exception/navigation_exception.dart';
part 'navigation_animation.dart';
part 'route_name.dart';
abstract class INavigationManager {
  Future<void> popAndPushToPage(RouteName route, {Object? arguments});
  Future<dynamic> pushToPage(RouteName route, {Object? arguments});
  Future<void> replaceToPage(RouteName route);
  Future<void> pushAndRemoveUntil(RouteName route, {Object? arguments}); 
  void popPage({Object? result});
}

class NavigationManager extends INavigationManager {
  NavigationManager._();

  static NavigationManager instance = NavigationManager._();
  final GlobalKey<NavigatorState> _navigationGlobalKey = GlobalKey();

  GlobalKey<NavigatorState> get navigationGlobalKey => _navigationGlobalKey;

  @override
  Future<dynamic> pushToPage(RouteName route, {Object? arguments}) async {
    return await navigationGlobalKey.currentState?.pushNamed(
      route.withParaf,
      arguments: arguments,
    );
  }

  @override
  void popPage({Object? result}) {
    navigationGlobalKey.currentState?.pop(result);
  }

  @override
  Future<void> replaceToPage(RouteName route) async {
    await navigationGlobalKey.currentState?.pushReplacementNamed(
      route.withParaf,
    );
  }

  @override
  Future<void> popAndPushToPage(RouteName route, {Object? arguments}) async {
    await navigationGlobalKey.currentState?.popAndPushNamed(
      route.withParaf,
      arguments: arguments,
    );
  }

  
  
  
  @override
  Future<void> pushAndRemoveUntil(RouteName route, {Object? arguments}) async {
    await navigationGlobalKey.currentState?.pushNamedAndRemoveUntil(
      route.withParaf,
      (Route<dynamic> route) => false, 
      arguments: arguments,
    );
  }
}
