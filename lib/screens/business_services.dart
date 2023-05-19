import 'package:hustla/custom/app_bar.dart';
import 'package:hustla/custom/box_decorations.dart';
import 'package:hustla/custom/device_info.dart';
import 'package:hustla/custom/page_description.dart';
import 'package:hustla/custom/useful_elements.dart';
import 'package:hustla/helpers/shimmer_helper.dart';
import 'package:hustla/presenter/bottom_appbar_index.dart';
import 'package:hustla/screens/job_sectors.dart';
import 'package:hustla/screens/post_job.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hustla/my_theme.dart';
import 'package:hustla/ui_sections/drawer.dart';
import 'package:hustla/custom/toast_component.dart';
import 'package:toast/toast.dart';
import 'package:hustla/screens/category_products.dart';
import 'package:hustla/repositories/category_repository.dart';
import 'package:shimmer/shimmer.dart';
import 'package:hustla/app_config.dart';
import 'package:hustla/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BusinessServices extends StatefulWidget {
  BusinessServices({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _BusinessServicesState createState() => _BusinessServicesState();
}

class _BusinessServicesState extends State<BusinessServices> {
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
        "name": "Register Business",
        "banner":
            "https://www.registeryourbusiness.co.za/wp-content/uploads/2021/08/RYBLogoNew.png",
        "description": "Select this option to register your business.",
      },
      {
        "id": 2,
        "name": "Search Business",
        "banner":
            "https://howtostartanllc.com/images/name-search-icons/llc-name-search-h.jpg",
        "description": "Select this option to find any business in Kenya.",
      },
    ];
    setState(() {
      _categories = _list;
    });
  }
}
