import 'package:country_flags/country_flags.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'language_list.dart';






void showLanguageSelectionDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      final currentLocale = context.locale;

      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Center(
          child: Text(
            "settings.select_language".tr(),
            style: Theme.of(context).textTheme.displayMedium!.copyWith(
              color: Theme.of(context).textTheme.bodyMedium!.color,
              fontSize: 34,
            ),
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: Languages.languages.length,
            itemBuilder: (BuildContext context, int index) {
              final language = Languages.languages[index];
              final isSelected = currentLocale == language.locale;

              return Container(
                margin: EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(16), 
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15), 
                      blurRadius: 10, 
                      spreadRadius: 1, 
                      offset: Offset(0, 4), 
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),

                  child: ListTile(
                    leading: CountryFlag.fromCountryCode(
                      language.countryCode,
                      theme: const ImageTheme(
                        width: 42,
                        height: 42,
                        shape: Circle(), 
                      ),
                    ),
                    title: Text(
                      language.name,
                      style: Theme.of(context).textTheme.displayMedium!
                          .copyWith(
                            color: Theme.of(
                              context,
                            ).textTheme.bodyMedium!.color,
                          ),
                    ),
                    trailing: isSelected
                        ? Icon(
                            Icons.check,
                            color: Theme.of(context).primaryColor,
                          )
                        : null,
                    onTap: () {
                      context.setLocale(language.locale);

                    },
                  ),
                ),
              );
            },
          ),
        ),
      );
    },
  );
}
