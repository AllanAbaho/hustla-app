import 'package:active_ecommerce_flutter/custom/app_bar.dart';
import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/custom/page_description.dart';
import 'package:active_ecommerce_flutter/screens/send_money.dart';
import 'package:active_ecommerce_flutter/screens/top_up.dart';
import 'package:active_ecommerce_flutter/screens/withraw.dart';
import 'package:flutter/material.dart';

class Finance extends StatefulWidget {
  Finance({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _FinanceState createState() => _FinanceState();
}

class _FinanceState extends State<Finance> {
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
        "id": 0,
        "name": "Send Money",
        "banner":
            "https://www.dignited.com/wp-content/uploads/2018/12/Mobile-Money-Transfer-And-Mobile-Money-Transfer-Service-1200x800-1024x683.jpg",
        "description": "Send via mobile money, your wallet, or bank transfer.",
        "page": SendMoney(title: 'Send Money'),
      },
      {
        "id": 1,
        "name": "Add Credit",
        "banner":
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTMkJEivNrYTNeSi-vKI0aXoaQViWclE9Ewgw&usqp=CAU",
        "description": "Move money from your mobile money number to wallet.",
        "page": TopUp(title: 'Add Credit'),
      },
      {
        "id": 2,
        "name": "Withdaw Money",
        "banner":
            "https://www.nerdwallet.com/assets/blog/wp-content/uploads/2015/05/atm-eats-deposit-contact-financial-institution-immediately-story.jpg",
        "description":
            "Convert your wallet funds to cash at the nearest agent point.",
        "page": Withdraw(title: 'Withdraw Money'),
      },
    ];
    setState(() {
      _categories = _list;
    });
  }
}
