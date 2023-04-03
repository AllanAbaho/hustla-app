import 'package:active_ecommerce_flutter/custom/app_bar.dart';
import 'package:active_ecommerce_flutter/custom/box_decorations.dart';
import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/custom/page_description.dart';
import 'package:active_ecommerce_flutter/custom/useful_elements.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_flutter/presenter/bottom_appbar_index.dart';
import 'package:active_ecommerce_flutter/screens/business_services.dart';
import 'package:active_ecommerce_flutter/screens/driving_services.dart';
import 'package:active_ecommerce_flutter/screens/immigration_services.dart';
import 'package:active_ecommerce_flutter/screens/lands_services.dart';
import 'package:active_ecommerce_flutter/screens/marriage_services.dart';
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

class Government extends StatefulWidget {
  Government({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _GovernmentState createState() => _GovernmentState();
}

class _GovernmentState extends State<Government> {
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
        "name": "Business Services",
        "banner":
            "https://i0.wp.com/ugtechmag.com/wp-content/uploads/2023/01/Untitled-design-6-1.png?fit=1200%2C675&ssl=1",
        "description": "Select this to search for a business or register one.",
        "page": BusinessServices(
          title: 'Business Services',
        )
      },
      {
        "id": 1,
        "name": "Lands Services",
        "banner":
            "https://mwc.legal/wp-content/uploads/2020/08/The-Land-Registration-Electronic-Transactions-Regulations-770x514.png",
        "description":
            "Select this to search for a property or clear land / rent.",
        "page": LandsServices(
          title: 'Lands Services',
        )
      },
      {
        "id": 2,
        "name": "Immigration",
        "banner":
            "https://www.dignited.com/wp-content/uploads/2017/08/Kenyan-e-Passport.jpg",
        "description": "Apply for a passport or visa for you or your child.",
        "page": ImmigrationServices(title: 'Immigration Services')
      },
      {
        "id": 3,
        "name": "Marriage Services",
        "banner":
            "https://domf5oio6qrcr.cloudfront.net/medialibrary/9030/iStock_72610687_MEDIUM.jpg",
        "description":
            "Apply for a marriage certificate and other related documents.",
        "page": MarriageServices(title: 'Marriage Services')
      },
      {
        "id": 4,
        "name": "Driving Services",
        "banner":
            "http://flashugnews.com/wp-content/uploads/2022/07/ugandan-driving-permit-1.jpeg",
        "description":
            "Apply for a driving license and other related documents.",
        "page": DrivingServices(
          title: 'Driving Services',
        )
      },
    ];
    setState(() {
      _categories = _list;
    });
  }
}
