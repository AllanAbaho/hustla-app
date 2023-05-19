import 'package:hustla/custom/app_bar.dart';
import 'package:hustla/custom/box_decorations.dart';
import 'package:hustla/custom/device_info.dart';
import 'package:hustla/custom/page_description.dart';
import 'package:hustla/custom/useful_elements.dart';
import 'package:hustla/helpers/shimmer_helper.dart';
import 'package:hustla/presenter/bottom_appbar_index.dart';
import 'package:hustla/screens/book_flight.dart';
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

class Travel extends StatefulWidget {
  Travel({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _TravelState createState() => _TravelState();
}

class _TravelState extends State<Travel> {
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
        "name": "Book Flight",
        "banner":
            "https://www.aa.com/content/images/homepage/mobile-hero/en_US/Airplane-2.png",
        "description":
            "Select this option to book an Air ticket faster and cheaper.",
        "page": BookFlight(title: 'Book Flight')
      },
      {
        "id": 1,
        "name": "Request Cab Ride",
        "banner":
            "https://media-cdn.tripadvisor.com/media/photo-s/1b/49/15/50/caption.jpg",
        "description":
            "Select this option to book get affordable rides quickly.",
      },
      {
        "id": 2,
        "name": "Book Hotel Room",
        "banner":
            "https://www.gannett-cdn.com/-mm-/05b227ad5b8ad4e9dcb53af4f31d7fbdb7fa901b/c=0-64-2119-1259/local/-/media/USATODAY/USATODAY/2014/08/13/1407953244000-177513283.jpg?width=660&height=373&fit=crop&format=pjpg&auto=webp",
        "description":
            "Select this option to book a hotel in any area in Kenya.",
      },
    ];
    setState(() {
      _categories = _list;
    });
  }
}
