import 'package:flutter/material.dart';
import 'package:hackathon_mobile/src/core/navigation/navigation_manager.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hackathon_mobile/src/feature/home/home_view.dart';
import '../../core/cache/cache_service.dart';
import '../../core/cache/user_cache.dart';
import '../../core/mixins/navigation_mixin.dart';
import '../auth/screens/welcome_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with NavigatornMixinStateful<SplashView> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    
    await Future.delayed(const Duration(milliseconds: 500));

 

    
    String? token = GlobalUserCache.token;

    RouteName nextPage = (token != null && token.isNotEmpty)
        ?  RouteName.home
        :  RouteName.welcome;

    if (mounted) {

     router.pushAndRemoveUntil(nextPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('')),
    );
  }
}
