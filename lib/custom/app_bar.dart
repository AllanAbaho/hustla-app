import 'package:hustla/custom/resources.dart';
import 'package:hustla/my_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

AppBar buildAppBar(BuildContext context, String title) {
  return AppBar(
    backgroundColor: AppColors.dashboardColor,
    //centerTitle: true,
    leading: Builder(
      builder: (context) => IconButton(
        icon: Icon(CupertinoIcons.arrow_left, color: MyTheme.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
    ),
    title: Text(
      title,
      style: TextStyle(
          fontSize: 16, color: MyTheme.white, fontWeight: FontWeight.bold),
    ),
    elevation: 0.0,
    titleSpacing: 0,
  );
}
