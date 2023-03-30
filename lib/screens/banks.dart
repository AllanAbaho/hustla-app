import 'package:active_ecommerce_flutter/custom/app_bar.dart';
import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/custom/page_description.dart';
import 'package:active_ecommerce_flutter/screens/banks.dart';
import 'package:active_ecommerce_flutter/screens/mobile_money.dart';
import 'package:active_ecommerce_flutter/screens/to_bank.dart';
import 'package:active_ecommerce_flutter/screens/to_mobile.dart';
import 'package:active_ecommerce_flutter/screens/to_wallet.dart';
import 'package:flutter/material.dart';

class Banks extends StatefulWidget {
  Banks({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _BanksState createState() => _BanksState();
}

class _BanksState extends State<Banks> {
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
        "name": "KCB",
        "banner":
            "https://financialallianceforwomen.org/wp-content/uploads/2016/11/kcb-e1480436893425.jpg",
        "description": "Send via mobile money, your wallet, or bank transfer.",
        "page": ToBank(title: 'To KCB'),
      },
      {
        "id": 11,
        "name": "Equity Bank",
        "banner":
            "https://equitygroupholdings.com/ug/templates/equity/assets/img/equity-bank-logo.png",
        "description": "Send via mobile money, your wallet, or bank transfer.",
        "page": ToBank(title: 'To Equity Bank'),
      },
      {
        "id": 16,
        "name": "ABSA",
        "banner":
            "https://upload.wikimedia.org/wikipedia/commons/thumb/d/de/ABSA_Group_Limited_Logo.svg/1200px-ABSA_Group_Limited_Logo.svg.png",
        "description": "Send via mobile money, your wallet, or bank transfer.",
        "page": ToBank(title: 'To ABSA'),
      },
      {
        "id": 1,
        "name": "Standard Chartered Bank",
        "banner":
            "https://av.sc.com/corp-en/content/images/Lockup-MonoBlack-thumbnail-278x220.jpg",
        "description": "Send via mobile money, your wallet, or bank transfer.",
        "page": ToBank(title: 'To Standard Chartered Bank'),
      },
      {
        "id": 2,
        "name": "National Bank",
        "banner": "https://images.africanfinancials.com/ke-nbk-logo-min.png",
        "description": "Send via mobile money, your wallet, or bank transfer.",
        "page": ToBank(title: 'National Bank'),
      },
      {
        "id": 3,
        "name": "Diamond Trust Bank",
        "banner": "https://images.africanfinancials.com/ke-dtk-logo-min.png",
        "description": "Send via mobile money, your wallet, or bank transfer.",
        "page": ToBank(title: 'Diamond Trust Bank'),
      },
      {
        "id": 4,
        "name": "Stanbic Bank",
        "banner":
            "https://www.tenderyetu.com/wp-content/uploads/2022/01/STANBIC-BANK-KENYA-LIMITED-tender-2022.png",
        "description": "Send via mobile money, your wallet, or bank transfer.",
        "page": ToBank(title: 'Stanbic Bank'),
      },
      {
        "id": 5,
        "name": "Commercial Bank of Africa",
        "banner":
            "https://res.cloudinary.com/crunchbase-production/image/upload/c_lpad,h_170,w_170,f_auto,b_white,q_auto:eco,dpr_1/v1494424636/xgezxjd9ogjxwwrhozps.png",
        "description": "Send via mobile money, your wallet, or bank transfer.",
        "page": ToBank(title: 'Commercial Bank of Africa'),
      },
      {
        "id": 6,
        "name": "Bank of Africa",
        "banner":
            "https://fresherjobsuganda.com/wp-content/uploads/2022/02/Bank-of-Africa.jpg",
        "description": "Send via mobile money, your wallet, or bank transfer.",
        "page": ToBank(title: "Bank of Africa"),
      },
      {
        "id": 7,
        "name": "Prime Bank",
        "banner":
            "https://www.businesslist.co.ke/img/ke/j/1656409333-25-prime-bank-ltd-head-office.png",
        "description": "Send via mobile money, your wallet, or bank transfer.",
        "page": ToBank(title: "Prime Bank"),
      },
      {
        "id": 8,
        "name": "Trans National Bank",
        "banner":
            "http://covered.co.ke/blog/wp-content/uploads/2017/02/welcomeP.jpg",
        "description": "Send via mobile money, your wallet, or bank transfer.",
        "page": ToBank(title: "Trans National Bank"),
      },
      {
        "id": 10,
        "name": "I & M Bank",
        "banner":
            "https://res.cloudinary.com/crunchbase-production/image/upload/c_lpad,f_auto,q_auto:eco,dpr_1/v1465885047/jxgzemkhfpwn2f684fr5.png",
        "description": "Send via mobile money, your wallet, or bank transfer.",
        "page": ToBank(title: "I & M Bank"),
      },
    ];
    setState(() {
      _categories = _list;
    });
  }
}
