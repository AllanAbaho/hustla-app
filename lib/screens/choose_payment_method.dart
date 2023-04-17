import 'package:active_ecommerce_flutter/custom/app_bar.dart';
import 'package:active_ecommerce_flutter/custom/box_decorations.dart';
import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/custom/enter_pin.dart';
import 'package:active_ecommerce_flutter/custom/page_description.dart';
import 'package:active_ecommerce_flutter/custom/useful_elements.dart';
import 'package:active_ecommerce_flutter/data_model/confirm_booking_response.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_flutter/presenter/bottom_appbar_index.dart';
import 'package:active_ecommerce_flutter/screens/book_flight.dart';
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

class ChoosePaymentMethod extends StatefulWidget {
  ChoosePaymentMethod({Key key, this.title, this.bookingid, this.passengers})
      : super(key: key);

  final String title;
  final int bookingid;
  final List<Passenger> passengers;

  @override
  _ChoosePaymentMethodState createState() => _ChoosePaymentMethodState();
}

class _ChoosePaymentMethodState extends State<ChoosePaymentMethod> {
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
        "name": "Hustla Wallet",
        "banner":
            "https://img.freepik.com/free-vector/digital-wallet-abstract-concept-illustration_335657-3896.jpg?w=2000",
        "description": "Select this option to pay using your wallet",
        "page": EnterPin(
            title: 'Enter Password',
            bookingid: widget.bookingid,
            passengers: widget.passengers)
      },
      {
        "id": 1,
        "name": "Credit Card",
        "banner":
            "https://media-cdn.tripadvisor.com/media/photo-s/1b/49/15/50/caption.jpg",
        "description": "Select this option to pay using credit card",
      },
      {
        "id": 2,
        "name": "Mobile Money",
        "banner":
            "https://www.gannett-cdn.com/-mm-/05b227ad5b8ad4e9dcb53af4f31d7fbdb7fa901b/c=0-64-2119-1259/local/-/media/USATODAY/USATODAY/2014/08/13/1407953244000-177513283.jpg?width=660&height=373&fit=crop&format=pjpg&auto=webp",
        "description": "Select this option to pay using mobile money",
      },
    ];
    setState(() {
      _categories = _list;
    });
  }
}
