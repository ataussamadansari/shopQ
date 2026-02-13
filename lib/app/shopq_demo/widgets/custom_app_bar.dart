import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.centerTitle = false,
    this.actions,
    this.bottom,
  });

  final String title;
  final bool showBackButton;
  final bool centerTitle;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: centerTitle,
      leading: showBackButton
          ? IconButton(
              onPressed: () => Navigator.maybePop(context),
              icon: const Icon(CupertinoIcons.back),
            )
          : null,
      actions: actions,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize {
    final bottomHeight = bottom?.preferredSize.height ?? 0;
    return Size.fromHeight(kToolbarHeight + bottomHeight);
  }
}
