import 'package:active_ecommerce_flutter/custom/app_bar.dart';
import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/custom/page_description.dart';
import 'package:flutter/material.dart';

class ImmigrationServices extends StatefulWidget {
  ImmigrationServices({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ImmigrationServicesState createState() => _ImmigrationServicesState();
}

class _ImmigrationServicesState extends State<ImmigrationServices> {
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
        "name": "Passport for Adult",
        "banner":
            "https://techweez.com/wp-content/uploads/2015/11/Passport.jpg",
        "description": "Send via mobile money, your wallet, or bank transfer.",
      },
      {
        "id": 2,
        "name": "Children Passport",
        "banner":
            "https://www.kenyabuzz.com/lifestyle/wp-content/uploads/2017/10/IMG_4027-233x175.jpg",
        "description": "Send via mobile money, your wallet, or bank transfer.",
      },
      {
        "id": 3,
        "name": "Apply for Visa",
        "banner":
            "https://netstorage-tuko.akamaized.net/images/0fgjhs16ekveb9474o.jpg?imwidth=900",
        "description": "Send via mobile money, your wallet, or bank transfer.",
      },
    ];
    setState(() {
      _categories = _list;
    });
  }
}
