import 'dart:convert';

import 'package:hustla/custom/app_bar.dart';
import 'package:hustla/custom/device_info.dart';
import 'package:hustla/custom/input_decorations.dart';
import 'package:hustla/custom/page_description.dart';
import 'package:hustla/custom/resources.dart';
import 'package:hustla/custom/toast_component.dart';
import 'package:hustla/custom/transaction_otp.dart';
import 'package:hustla/data_model/confirm_booking_response.dart';
import 'package:hustla/helpers/shared_value_helper.dart';
import 'package:hustla/my_theme.dart';
import 'package:hustla/repositories/airline_repository.dart';
import 'package:hustla/repositories/top_up_repository.dart';
import 'package:hustla/screens/choose_payment_method.dart';
import 'package:hustla/screens/edit_passenger.dart';
import 'package:hustla/screens/main.dart';
import 'package:hustla/screens/make_airline_payment.dart';
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
  TextEditingController _confirmationEmailController = TextEditingController();

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildDescription(widget.title,
                description: 'Please confirm the following passenger details'),
            buildList(),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 4.0),
              child: Text(
                'Confirmation Email',
                style: TextStyle(
                    color: AppColors.appBarColor,
                    fontWeight: FontWeight.w100,
                    fontSize: 16),
              ),
            ),
            Container(
              height: 36,
              child: TextField(
                keyboardType: TextInputType.text,
                controller: _confirmationEmailController,
                autofocus: false,
                decoration: InputDecorations.buildInputDecoration_1(
                    hint_text: user_email.$),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                'This email will receive the E-ticket(s)',
                style: TextStyle(
                    color: AppColors.appBarColor,
                    fontWeight: FontWeight.w100,
                    fontSize: 10),
              ),
            ),
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
    var data = {
      "aerocrs": {
        "parms": {
          "bookingid": widget.bookingid,
          "agentconfirmation": "apiconnector",
          "confirmationemail": _confirmationEmailController.text.trim(),
          "passenger": widget.passengers
        }
      }
    };
    var postData = jsonEncode(data);
    loading('Please wait...');

    var bookingResponse = await AirlineRepository().confirmBooking(postData);
    Navigator.of(loadingContext).pop();
    if (bookingResponse.success == false) {
      ToastComponent.showDialog(bookingResponse.errorMessage,
          gravity: Toast.center, duration: Toast.lengthLong);
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return MakeAirlinePayment(
          title: 'Make Payment',
          bookingid: widget.bookingid,
        );
      }));
    }
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
