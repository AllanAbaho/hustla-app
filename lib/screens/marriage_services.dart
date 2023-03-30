import 'package:active_ecommerce_flutter/custom/app_bar.dart';
import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/custom/page_description.dart';
import 'package:flutter/material.dart';

class MarriageServices extends StatefulWidget {
  MarriageServices({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MarriageServicesState createState() => _MarriageServicesState();
}

class _MarriageServicesState extends State<MarriageServices> {
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
        "id": 1,
        "name": "Notice of Marriage",
        "banner":
            "https://www.julisha.info/hc/article_attachments/4404324198551/Marriage.jpg",
        "description": "Send via mobile money, your wallet, or bank transfer.",
      },
      {
        "id": 2,
        "name": "Marriage Certificate",
        "banner":
            "https://wikitionary254.com/wp-content/uploads/2023/01/How-to-Get-a-Marrage-Certificate-in-Kenya.jpg",
        "description": "Send via mobile money, your wallet, or bank transfer.",
      },
      {
        "id": 3,
        "name": "Solemnization of Marriages",
        "banner":
            "https://cdn03.allafrica.com/download/pic/main/main/csiid/00520642:a00ef052b942f7af17e857da143e259a:arc614x376:w735:us1.jpg",
        "description": "Send via mobile money, your wallet, or bank transfer.",
      },
      {
        "id": 4,
        "name": "Commissioning of Affidavits",
        "banner":
            "https://swkadvocates.com/wp-content/uploads/2018/09/blog-post-6.jpg",
        "description": "Send via mobile money, your wallet, or bank transfer.",
      },
    ];
    setState(() {
      _categories = _list;
    });
  }
}
