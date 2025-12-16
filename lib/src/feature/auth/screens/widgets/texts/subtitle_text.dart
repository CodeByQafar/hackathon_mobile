import '../../../../../core/utils/padding.dart';
import 'package:flutter/material.dart';

class SubtitleText extends StatelessWidget {
  const SubtitleText({super.key,required this.text});
  final String text ;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Paddings.subtitleHorizontalPadding,
      child: Text(
        textAlign: TextAlign.center,
        text,
      
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}
