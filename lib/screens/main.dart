import 'dart:async';
import 'dart:io';

import 'package:hustla/custom/common_functions.dart';
import 'package:hustla/custom/resources.dart';
import 'package:hustla/my_theme.dart';
import 'package:hustla/presenter/bottom_appbar_index.dart';
import 'package:hustla/presenter/cart_counter.dart';
import 'package:hustla/repositories/cart_repository.dart';
import 'package:hustla/screens/cart.dart';
import 'package:hustla/screens/category_list.dart';
import 'package:hustla/screens/home.dart';
import 'package:hustla/screens/login.dart';
import 'package:hustla/screens/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:hustla/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:badges/badges.dart';
import 'package:route_transitions/route_transitions.dart';

class Main extends StatefulWidget {
  Main({Key key, go_back = true}) : super(key: key);

  bool go_back;

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  int _currentIndex = 0;
  //int _cartCount = 0;

  BottomAppbarIndex bottomAppbarIndex = BottomAppbarIndex();

  CartCounter counter = CartCounter();

  var _children = [];

  fetchAll() {
    getCartCount();
  }

  void onTapped(int i) {
    fetchAll();
    if (!is_logged_in.$ && (i == 3 || i == 2)) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
      return;
    }

    if (i == 3) {
      app_language_rtl.$
          ? slideLeftWidget(newPage: Profile(), context: context)
          : slideRightWidget(newPage: Profile(), context: context);
      return;
    }

    setState(() {
      _currentIndex = i;
    });
    //print("i$i");
  }

  getCartCount() async {
    var res = await CartRepository().getCartCount();

    counter.controller.sink.add(res.count);
  }

  void initState() {
    print(account_number.$);
    _children = [
      Home(
        counter: counter,
      ),
      CategoryList(
        is_base_category: true,
      ),
      Cart(
        has_bottomnav: true,
        from_navigation: true,
        counter: counter,
      ),
      Profile()
    ];
    fetchAll();
    // TODO: implement initState
    //re appear statusbar in case it was not there in the previous page
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        //print("_currentIndex");
        if (_currentIndex != 0) {
          fetchAll();
          setState(() {
            _currentIndex = 0;
          });
          return false;
        } else {
          CommonFunctions(context).appExitDialog();
        }
        return widget.go_back;
      },
      child: Directionality(
        textDirection:
            app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
          extendBody: true,
          body: _children[_currentIndex],
          bottomNavigationBar: BottomAppBar(
            color: Colors.transparent,
            clipBehavior: Clip.antiAlias,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
              child: SizedBox(
                height: 83,
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  onTap: onTapped,
                  currentIndex: _currentIndex,
                  backgroundColor: AppColors.appBarColor,
                  unselectedItemColor: Colors.white,
                  selectedItemColor: MyTheme.accent_color,
                  selectedLabelStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: MyTheme.accent_color,
                      fontSize: 12),
                  unselectedLabelStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(168, 175, 179, 1),
                      fontSize: 12),
                  items: [
                    BottomNavigationBarItem(
                        icon: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Image.asset(
                            "assets/home.png",
                            color: _currentIndex == 0
                                ? MyTheme.accent_color
                                : Colors.white,
                            height: 16,
                          ),
                        ),
                        label: AppLocalizations.of(context)
                            .main_screen_bottom_navigation_home),
                    BottomNavigationBarItem(
                        icon: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Image.asset(
                            "assets/categories.png",
                            color: _currentIndex == 1
                                ? MyTheme.accent_color
                                : Colors.white,
                            height: 16,
                          ),
                        ),
                        label: 'Marketplace'),
                    BottomNavigationBarItem(
                        icon: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Badge(
                            toAnimate: false,
                            shape: BadgeShape.circle,
                            badgeColor: MyTheme.accent_color,
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              "assets/cart.png",
                              color: _currentIndex == 2
                                  ? MyTheme.accent_color
                                  : Colors.white,
                              height: 16,
                            ),
                            padding: EdgeInsets.all(4),
                            badgeContent: StreamBuilder<int>(
                                stream: counter.controller.stream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData)
                                    return Text(snapshot.data.toString() + "",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 8));
                                  return Text("0",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 8));
                                }),
                          ),
                        ),
                        label: AppLocalizations.of(context)
                            .main_screen_bottom_navigation_cart),
                    BottomNavigationBarItem(
                      icon: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Image.asset(
                          "assets/profile.png",
                          color: _currentIndex == 3
                              ? MyTheme.accent_color
                              : Colors.white,
                          height: 20,
                        ),
                      ),
                      label: 'Profile',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
