import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      toolbarHeight: kToolbarHeight,
      // backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            decoration: BoxDecoration(
              color: Colors.black12,
              shape: BoxShape.circle
            ),
            child: Icon(
              Icons.person,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
          onPressed: () {
          },
        ),
      ],
      title: _buildAddress(context),
      // flexibleSpace: _buildAddress(context),
    );
  }

  Widget _buildAddress(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'DELIVERY IN',
              maxLines: 1,
              style: TextStyle(fontSize: 16),
            ),
            Text(
              ' 9 Minutes',
              maxLines: 1,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        Text(
          'HOME- Floor 4, The Dunkirk House',
          maxLines: 1,
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
        ),
        // Add more Text widgets as needed
      ],
    );
  }
}
