import 'package:flutter/material.dart';

class CustomAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBarWidget({this.title = 'What Do Yo Want \nTo Cook Today?', super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 80,
      automaticallyImplyLeading: false,
      surfaceTintColor: Colors.transparent,
      title: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: 25,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF333333),
          ),
          textAlign: TextAlign.start,
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
