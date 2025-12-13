import 'package:flutter/material.dart';

import '../../../../../core/utils/border_radius.dart';
import '../../../../../core/utils/box_constraints.dart';
import '../../../../../core/utils/padding.dart';

class SignButton extends StatelessWidget {
  const SignButton({
    super.key,
    required this.message,
    required this.onPressed,
    required this.isEnabled,
    required this.isLodaing,
  });
  final VoidCallback onPressed;
  final bool isEnabled;
  final String message;
  final bool isLodaing;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Paddings.expandSignButtonPadding,
      child: ConstrainedBox(
        constraints: BoxConstraintses.expandSignButton,
        child: FilledButton(
          onPressed: isEnabled ? onPressed : () {},
          style: FilledButton.styleFrom(
            shape: BorderRadiuses.signBUttonRadius,
            backgroundColor: isEnabled
                ? Theme.of(context).primaryColor
                : Theme.of(context).primaryColor.withOpacity(0.5),
          ),
          child: isLodaing
              ? SizedBox.square(
                  dimension: 30,
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : Text(message, style: Theme.of(context).textTheme.bodyLarge),
        ),
      ),
    );
  }
}
