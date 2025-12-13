import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hackathon_mobile/src/feature/auth/screens/welcome_view.dart';
import 'package:hackathon_mobile/src/feature/home/home_view.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import 'src/core/cache/cache_service.dart';
import 'src/core/cache/user_cache.dart';
import 'src/core/init/theme/theme.dart';
import 'src/core/navigation/navigation_manager.dart';
import 'src/feature/auth/view model/auth_view_model.dart';
import 'src/feature/auth/view model/verify_code_view_model.dart';
import 'src/feature/pages/home_page.dart';
import 'src/feature/pages/third_page.dart';
import 'src/feature/setting/view model/settings_view_model.dart';
import 'src/feature/splash/splash_view.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Hive.initFlutter();
  await CacheService.instance.init();
  await GlobalUserCache.loadFromCache();
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.top],
  );
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('az'), Locale('tr')],
      path: 'assets/lang',
      fallbackLocale: const Locale('az'),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => VerifyCodeViewModel()),
          ChangeNotifierProvider(create: (_) => SettingsViewModel()),
          ChangeNotifierProvider(create: (_) => AuthViewModel()),
  
     
        ChangeNotifierProvider(create: (_) => ReservationProvider()), 
        
        // 2. OrderProvider ƏLAVƏ EDİLMƏLİDİR
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        // 2. Tarix, Saat və Masa seçimini idarə edir
        ChangeNotifierProvider(
          create: (_) => ReservationProvider(),
        ),
        ],
        child: const MainApp(),
      ),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    final settingsViewModel = Provider.of<SettingsViewModel>(context);
    return MaterialApp(
      navigatorKey: NavigationManager.instance.navigationGlobalKey,
      onGenerateRoute: RouteGenerator.generateRoute,
      debugShowCheckedModeBanner: false,
      darkTheme: AppTheme().darkTheme,
      theme: AppTheme().lightTheme,
      themeMode: settingsViewModel.themeMode,
      home: SplashView(),
      title: "Hackathon Mobile",
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}
