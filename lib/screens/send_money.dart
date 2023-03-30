import 'package:active_ecommerce_flutter/custom/app_bar.dart';
import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/custom/page_description.dart';
import 'package:active_ecommerce_flutter/screens/banks.dart';
import 'package:active_ecommerce_flutter/screens/mobile_money.dart';
import 'package:active_ecommerce_flutter/screens/to_wallet.dart';
import 'package:flutter/material.dart';

class SendMoney extends StatefulWidget {
  SendMoney({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _SendMoneyState createState() => _SendMoneyState();
}

class _SendMoneyState extends State<SendMoney> {
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
        "name": "Hustla Wallet",
        "banner":
            "https://img.freepik.com/free-vector/digital-wallet-abstract-concept-illustration_335657-3896.jpg?w=2000",
        "description": "Send via mobile money, your wallet, or bank transfer.",
        "page": ToWallet(title: 'To Wallet'),
      },
      {
        "id": 11,
        "name": "Mobile Money",
        "banner":
            "https://www.dignited.com/wp-content/uploads/2018/12/Mobile-Money-Transfer-And-Mobile-Money-Transfer-Service-1200x800.jpg",
        "description": "Send via mobile money, your wallet, or bank transfer.",
        "page": MobileMoney(title: 'Mobile Money'),
      },
      {
        "id": 16,
        "name": "Bank Account",
        "banner":
            "https://payveda.com/kcfinder/upload/images/Image-1%281%29.png",
        "description": "Send via mobile money, your wallet, or bank transfer.",
        "page": Banks(title: "Banks"),
      },
    ];
    setState(() {
      _categories = _list;
    });
  }
}
