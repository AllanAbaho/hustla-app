import 'package:active_ecommerce_flutter/custom/app_bar.dart';
import 'package:active_ecommerce_flutter/custom/box_decorations.dart';
import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/custom/page_description.dart';
import 'package:active_ecommerce_flutter/custom/resources.dart';
import 'package:active_ecommerce_flutter/custom/spacers.dart';
import 'package:active_ecommerce_flutter/custom/text.dart';
import 'package:active_ecommerce_flutter/custom/useful_elements.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_flutter/presenter/bottom_appbar_index.dart';
import 'package:active_ecommerce_flutter/screens/join_sacco.dart';
import 'package:active_ecommerce_flutter/screens/repay_funds.dart';
import 'package:active_ecommerce_flutter/screens/request_funds.dart';
import 'package:active_ecommerce_flutter/screens/save_funds.dart';
import 'package:active_ecommerce_flutter/screens/share_funds.dart';
import 'package:active_ecommerce_flutter/screens/top_up.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/ui_sections/drawer.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:toast/toast.dart';
import 'package:active_ecommerce_flutter/screens/category_products.dart';
import 'package:active_ecommerce_flutter/repositories/category_repository.dart';
import 'package:shimmer/shimmer.dart';
import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Sacco extends StatefulWidget {
  Sacco({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _SaccoState createState() => _SaccoState();
}

class _SaccoState extends State<Sacco> {
  final bool isMember = true;
  List _categories = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            child: buildAppBar(context, widget.title),
            preferredSize: Size(
              DeviceInfo(context).width,
              60,
            )),
        body: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: buildBody(context, widget.title, _categories,
                extraWidget:
                    sacco_name.$.isNotEmpty ? balanceWidget() : null)));
  }

  Widget balanceWidget() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0, left: 10, right: 10),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: AppColors.brandColor,
          boxShadow: [
            BoxShadow(
              color: Colors.yellow.withOpacity(.2),
              blurRadius: 20,
              spreadRadius: 00.0,
              offset: Offset(0.0, 10.0), // shadow direction: bottom right
            )
          ],
          borderRadius: BorderRadius.all(Radius.circular(10)),
          // border: Border.all(
          //     color: MyTheme.light_grey, width: 1),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    sacco_name.$,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${sacco_balance.$} (Ksh)',
                    style: TextStyle(
                        color: AppColors.appBarColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  ),
                  SizedBox(
                    height: 30,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return SaveFunds(title: 'Save Funds');
                        }));
                      },
                      // ignore: sort_child_properties_last
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: SmallText(
                          'Save Funds',
                          color: Colors.black,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.yellow,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // <-- Radius
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  getCategories() {
    var _list = [
      {
        "id": 9,
        "name": "Join Sacco",
        "banner":
            "https://www.turlock.k12.ca.us/cms/lib/CA50000453/Centricity/Domain/1539/register.png",
        "description": "Select this option to join one of our Saccos.",
        "page": JoinSacco(
          title: 'Join Sacco',
        ),
      },
      {
        "id": 11,
        "name": "Share Funds",
        "banner":
            "https://st2.depositphotos.com/4232343/7654/i/950/depositphotos_76547573-stock-photo-successful-young-businessmen-is-sharing.jpg",
        "description":
            "Select this option to share funds to another Sacco member.",
        "page": ShareFunds(
          title: 'Share Funds',
        ),
      },
      {
        "id": 16,
        "name": "Request Funds",
        "banner":
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTBBi0koyHLCdXaB_pn08b_wMQV0V5FCJ9axQ&usqp=CAU",
        "description": "Select this option to request funds from your Sacco.",
        "page": RequestFunds(title: 'Request Funds'),
      },
      {
        "id": 17,
        "name": "Repay Funds",
        "banner":
            "https://www.infinitietech.com/assets/images/blog/online-mobile-payments.jpg",
        "description": "Select this option to repay funds to your Sacco.",
        "page": RepayFunds(title: 'Repay Funds'),
      },
      // {
      //   "id": 18,
      //   "name": "Save Funds",
      //   "banner":
      //       "https://www.vacu.org/sites/default/files/styles/max_325x325/public/article-featured-image/2019-06/GettyImages-869577740.jpg?itok=J88hNHrF",
      //   "description":
      //       "Select this option to save funds to your Sacco account.",
      //   "page": SaveFunds(
      //     title: 'Save Funds',
      //   ),
      // },
    ];
    setState(() {
      _categories = _list;
    });
    ;
  }
}
