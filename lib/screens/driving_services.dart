import 'package:active_ecommerce_flutter/custom/app_bar.dart';
import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/custom/page_description.dart';
import 'package:flutter/material.dart';

class DrivingServices extends StatefulWidget {
  DrivingServices({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _DrivingServicesState createState() => _DrivingServicesState();
}

class _DrivingServicesState extends State<DrivingServices> {
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
        "name": "Provisional Driving License",
        "banner":
            "http://flashugnews.com/wp-content/uploads/2022/07/ugandan-driving-permit-1.jpeg",
        "description":
            "Select this option to get a provisional driving license.",
      },
      {
        "id": 2,
        "name": "Driving Test Booking",
        "banner":
            "https://media-blog.zutobi.com/wp-content/uploads/sites/2/2021/11/26170241/Driving-test_01_Remember-the-basics.jpg?w=2560&auto=format&ixlib=next&fit=max",
        "description": "Please select this option to book a driving test.",
      },
      {
        "id": 3,
        "name": "Interim Driving License",
        "banner":
            "https://live.staticflickr.com/8120/29216678934_08820448ec_b.jpg",
        "description": "Select this option to get an interim driving license.",
      },
      {
        "id": 4,
        "name": "Driving Class Endorsement",
        "banner":
            "http://driving-tests.org/wp-content/uploads/2021/04/cdl-license-types.jpeg",
        "description": "Select this option to get a driving class endorsement.",
      },
      {
        "id": 5,
        "name": "Driving License Renewal (1 Year)",
        "banner":
            "https://www.godigit.com/content/dam/godigit/directportal/en/contenthm/telangana-driving-licence.jpg",
        "description": "Select this option to renew your driving license.",
      },
      {
        "id": 6,
        "name": "Duplicate Driving License",
        "banner":
            "https://nairobiwire.com/wp-content/uploads/2022/04/How-To-Apply-for-a-Lost-Smart-Driving-License-in-Kenya.jpg",
        "description": "Select this option to duplicate your driving license.",
      },
      {
        "id": 7,
        "name": "Driving License Corrections",
        "banner":
            "https://www.godigit.com/content/dam/godigit/directportal/en/contenthm/how-to-change-name-on-driving-licence.jpg",
        "description": "Select this option to correct your driving license.",
      },
    ];
    setState(() {
      _categories = _list;
    });
  }
}
