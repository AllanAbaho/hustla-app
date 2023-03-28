import 'package:active_ecommerce_flutter/custom/resources.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:flutter/material.dart';

Widget buildDescription(String title) {
  return Column(
    children: [
      Text(
        title,
        style: TextStyle(
            color: AppColors.dashboardColor,
            fontSize: 25,
            height: 2,
            fontWeight: FontWeight.bold),
      ),
      Padding(
        padding:
            const EdgeInsets.only(top: 20, left: 8.0, bottom: 50, right: 8.0),
        child: Text(
          'Choose our list of customised categories and avail the services in each.',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: MyTheme.font_grey,
              fontSize: 14,
              height: 1.6,
              fontWeight: FontWeight.w600),
        ),
      ),
    ],
  );
}
