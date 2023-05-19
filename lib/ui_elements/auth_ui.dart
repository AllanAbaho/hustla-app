import 'package:hustla/custom/box_decorations.dart';
import 'package:hustla/custom/device_info.dart';
import 'package:hustla/custom/resources.dart';
import 'package:hustla/helpers/shared_value_helper.dart';
import 'package:hustla/my_theme.dart';
import 'package:flutter/material.dart';

class AuthScreen {
  static Widget buildScreen(
      BuildContext context, String headerText, Widget child) {
    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        //key: _scaffoldKey,
        //drawer: MainDrawer(),
        backgroundColor: Colors.white,
        //appBar: buildAppBar(context),
        body: Stack(
          children: [
            Container(
              height: DeviceInfo(context).height,
              width: DeviceInfo(context).width,
              color: AppColors.appBarColor,
              alignment: Alignment.topRight,
              child: Image.asset(
                "assets/background_1.png",
              ),
            ),
            CustomScrollView(
              //controller: _mainScrollController,
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Padding(
                        padding: const EdgeInsets.only(top: 100.0),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 12),
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                  color: MyTheme.white,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Image.asset('assets/app_icon.png'),
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0, top: 10),
                        child: Text(
                          headerText,
                          style: TextStyle(
                              color: MyTheme.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          decoration:
                              BoxDecorations.buildBoxDecoration_1(radius: 16),
                          child: child,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
