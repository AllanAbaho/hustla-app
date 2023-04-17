import 'dart:convert';

import 'package:active_ecommerce_flutter/custom/app_bar.dart';
import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/custom/input_decorations.dart';
import 'package:active_ecommerce_flutter/custom/page_description.dart';
import 'package:active_ecommerce_flutter/custom/resources.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:active_ecommerce_flutter/custom/transaction_otp.dart';
import 'package:active_ecommerce_flutter/data_model/confirm_booking_response.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/repositories/airline_repository.dart';
import 'package:active_ecommerce_flutter/repositories/top_up_repository.dart';
import 'package:active_ecommerce_flutter/screens/choose_payment_method.dart';
import 'package:active_ecommerce_flutter/screens/edit_passenger.dart';
import 'package:active_ecommerce_flutter/screens/main.dart';
import 'package:active_ecommerce_flutter/screens/ticket_otp.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConfirmBooking extends StatefulWidget {
  ConfirmBooking({Key key, this.title, this.bookingid, this.passengers})
      : super(key: key);

  final String title;
  final int bookingid;
  final List<Passenger> passengers;

  @override
  _ConfirmBookingState createState() => _ConfirmBookingState();
}

class _ConfirmBookingState extends State<ConfirmBooking> {
  BuildContext loadingContext;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.passengers);
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
          child: buildBody(),
        ));
  }

  Widget buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildDescription(widget.title,
                description: 'Please confirm the following passenger details'),
            buildList(),
            buildButton(),
          ],
        ),
      ),
    );
  }

  buildList() {
    return ListView.separated(
        shrinkWrap: true,
        separatorBuilder: (context, index) =>
            Divider(color: MyTheme.medium_grey),
        itemCount: widget.passengers.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: Icon(
              Icons.person,
              color: MyTheme.accent_color,
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.edit,
                color: MyTheme.accent_color,
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return EditPassenger(
                      bookingid: widget.bookingid,
                      passengers: widget.passengers,
                      index: index);
                }));
              },
            ),
            title: Text(widget.passengers[index].firstname),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.passengers[index].paxbirthdate),
                Text(widget.passengers[index].paxemail),
                Text(widget.passengers[index].paxnationailty),
              ],
            ),
          );
        });
  }

  buildButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Container(
        height: 45,
        child: FlatButton(
            minWidth: MediaQuery.of(context).size.width,
            disabledColor: MyTheme.grey_153,
            //height: 50,
            color: MyTheme.accent_color,
            shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(Radius.circular(6.0))),
            child: Text(
              'Confirm',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
            onPressed: () {
              onSubmit();
            }),
      ),
    );
  }

  onSubmit() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ChoosePaymentMethod(
        title: 'Choose Payment Method',
        bookingid: widget.bookingid,
        passengers: widget.passengers,
      );
    }));
  }

  loading(String text) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          loadingContext = context;
          return AlertDialog(
              content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(
                width: 10,
              ),
              Text(text),
            ],
          ));
        });
  }
}
