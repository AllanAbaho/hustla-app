import 'package:hustla/custom/app_bar.dart';
import 'package:hustla/custom/device_info.dart';
import 'package:hustla/custom/page_description.dart';
import 'package:hustla/screens/banks.dart';
import 'package:hustla/screens/mobile_money.dart';
import 'package:hustla/screens/to_mobile.dart';
import 'package:hustla/screens/to_wallet.dart';
import 'package:flutter/material.dart';

class MobileMoney extends StatefulWidget {
  MobileMoney({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _MobileMoneyState createState() => _MobileMoneyState();
}

class _MobileMoneyState extends State<MobileMoney> {
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
            child: buildBody(context, widget.title, _categories)));
  }

  getCategories() {
    var _list = [
      {
        "id": 9,
        "name": "Airtel",
        "banner":
            "http://flashugnews.com/wp-content/uploads/2022/07/Airtel-Money-Rates-in-Uganda-2022.jpeg",
        "description": "Select this option to send money to an Airtel number",
        "page": ToMobile(
          title: 'To Airtel',
        ),
      },
      {
        "id": 11,
        "name": "MTN",
        "banner":
            "https://www.african-markets.com/images/cache/528da7f993cd2feb85212d9ac6c5a22f_w600_h350_cp.jpg",
        "description": "Select this option to send money to an MTN number",
        "page": ToMobile(
          title: 'To MTN',
        ),
      },
      {
        "id": 16,
        "name": "Safaricom",
        "banner": "https://ik.imagekit.io/tp/20220201-safaricom-kenya-logo.png",
        "description": "Select this option to send money to a Safaricom number",
        "page": ToMobile(
          title: 'To Safaricom',
        ),
      },
    ];
    setState(() {
      _categories = _list;
    });
  }
}
