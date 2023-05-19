import 'package:hustla/custom/app_bar.dart';
import 'package:hustla/custom/device_info.dart';
import 'package:hustla/custom/page_description.dart';
import 'package:flutter/material.dart';

class LandsServices extends StatefulWidget {
  LandsServices({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LandsServicesState createState() => _LandsServicesState();
}

class _LandsServicesState extends State<LandsServices> {
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
        "name": "Search For Property",
        "banner":
            "https://bimamtaani.co.ke/wp-content/uploads/2021/04/Land-Seach-Online.jpg",
        "description":
            "Select this option to search for any property in Kenya.",
      },
      {
        "id": 2,
        "name": "Rent Clearance",
        "banner":
            "https://eregulations.invest.go.ke/media/clearance%20certificate.jpg",
        "description":
            "Do you want a rent clearance certificate for your property?",
      },
      {
        "id": 3,
        "name": "Land Clearance",
        "banner":
            "https://urbankenyans.com/wp-content/uploads/2019/04/land.jpg",
        "description":
            "Do you want a land clearance certificate for your property?",
      },
    ];
    setState(() {
      _categories = _list;
    });
  }
}
