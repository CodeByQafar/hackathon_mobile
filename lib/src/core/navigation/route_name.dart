part of 'navigation_manager.dart';

enum RouteName { home, welcome, signUp, signIn, forgotPassword, verifyCodeView }

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final name = settings.name;
    if (name == RouteName.home.withParaf) {
      return FadeRoute(child: HomeView());
    } else if (name == RouteName.welcome.withParaf) {
      return FadeRoute(child: WelcomeView());
    } else if (name == RouteName.signUp.withParaf) {
      return FadeRoute(child: SignUpView());
    } else if (name == RouteName.signIn.withParaf) {
      return FadeRoute(child: SignInView());
    } else if (name == RouteName.forgotPassword.withParaf) {
      return FadeRoute(child: ForgotPasswordView());
    } else if (name == RouteName.verifyCodeView.withParaf) {
      return FadeRoute(child:VerifyCodeView());
    } else {
      throw NavigationException('No route found for $name');
    }
  }
}

extension RouteNameExtension on RouteName {
  String get withParaf => '/$name';
}
