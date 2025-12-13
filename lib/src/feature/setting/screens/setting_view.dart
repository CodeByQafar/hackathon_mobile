import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../view model/settings_view_model.dart';

class SettingView extends StatelessWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top;

    final settingsViewModel = Provider.of<SettingsViewModel>(
      context,
      listen: false,
    );
    final currentThemeMode = Provider.of<SettingsViewModel>(context).themeMode;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          // PROFILE HEADER
          Container(
            width: mediaQuery.size.width,
            padding: EdgeInsets.only(top: 20 + topPadding, bottom: 40),
            decoration: BoxDecoration(
              color: scaffoldBackgroundColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    'https://i.pravatar.cc/150?img=12',
                  ),
                ),
                const SizedBox(height: 10),

                Text(
               settingsViewModel.email??"User@gmail.com",   
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
             
                Text(
                      (settingsViewModel.email?? "user@gmail.com").split('@')[0] ,

                  style: const TextStyle(fontSize: 24, color: Colors.grey),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // MENU ITEMS
        

          SettingTile(
            icon: Icons.language,
            title: 'settings.language'.tr(),
            onTap: () => settingsViewModel.changeLanguage(context),
          ),

          SettingTile(
            icon: Icons.dark_mode,
            title: 'settings.theme'.tr(),
            onTap: settingsViewModel.toggleTheme,
          ),  SettingTile(
            icon: Icons.logout_outlined,
            title: 'settings.logout'.tr(),
            onTap: () {
              settingsViewModel.logout(context);
            },
          ),
        ],
      ),
    );
  }
}

class SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const SettingTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(title),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        onTap: onTap,
      ),
    );
  }
}
