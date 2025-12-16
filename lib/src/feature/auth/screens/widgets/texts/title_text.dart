import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  const TitleText({super.key ,required this.text});
final String text;
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: text[0],
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).primaryColor,
            ),
          ),
          TextSpan(
            text:text.substring(1),
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }
}
