import 'package:flutter/material.dart';
import '../../core/app_export.dart';

class AppbarTitle extends StatelessWidget {
  final String text;
  final EdgeInsetsGeometry? margin;
  final Function? onTap;

  const AppbarTitle({
    Key? key,
    required this.text,
    this.margin,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap?.call();
      },
      child: Padding(
        padding: margin ?? EdgeInsets.zero,
        child: Text(
          text,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: appTheme.black900,
              ),
        ),
      ),
    );
  }
}
