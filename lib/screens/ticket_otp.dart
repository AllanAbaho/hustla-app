import 'dart:convert';

import 'package:hustla/custom/app_bar.dart';
import 'package:hustla/custom/device_info.dart';
import 'package:hustla/custom/input_decorations.dart';
import 'package:hustla/custom/page_description.dart';
import 'package:hustla/custom/resources.dart';
import 'package:hustla/custom/toast_component.dart';
import 'package:hustla/my_theme.dart';
import 'package:hustla/repositories/airline_repository.dart';
import 'package:hustla/screens/main.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TicketOTP extends StatefulWidget {
  TicketOTP({Key key, this.title, this.bookingid}) : super(key: key);

  final String title;
  final int bookingid;

  @override
  _TicketOTPState createState() => _TicketOTPState();
}

class _TicketOTPState extends State<TicketOTP> {
  final _otpController = TextEditingController();
  BuildContext loadingcontext;

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
                description:
                    'Please fill in the following form with the OTP you received'),
            buildOTPForm(),
          ],
        ),
      ),
    );
  }

  Widget buildOTPForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  'Enter OTP',
                  style: TextStyle(
                      color: AppColors.appBarColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      height: 36,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: _otpController,
                        decoration: InputDecorations.buildInputDecoration_1(),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Container(
                  height: 45,
                  child: FlatButton(
                      minWidth: MediaQuery.of(context).size.width,
                      disabledColor: MyTheme.grey_153,
                      //height: 50,
                      color: MyTheme.accent_color,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(6.0))),
                      child: Text(
                        'Authorize Payment',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                      onPressed: () {
                        onSubmit();
                      }),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  onSubmit() async {
    var otp = _otpController.text.toString();
    if (otp == "") {
      ToastComponent.showDialog('Please enter the otp',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }
    Map rawData = {
      "aerocrs": {
        "parms": {"bookingid": widget.bookingid}
      }
    };
    var data = jsonEncode(rawData);
    loading();
    var ticketResponse = await AirlineRepository().ticketBooking(data);
    Navigator.of(loadingcontext).pop();

    if (ticketResponse.success == false) {
      if (ticketResponse.errors.isNotEmpty) {
        ticketResponse.errors.forEach((error) {
          ToastComponent.showDialog(error,
              gravity: Toast.center, duration: Toast.lengthLong);
          return;
        });
      } else {
        ToastComponent.showDialog(ticketResponse.success.toString(),
            gravity: Toast.center, duration: Toast.lengthLong);
        return;
      }
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Main();
      }));
    }
  }

  loading() {
    showDialog(
        context: context,
        builder: (context) {
          loadingcontext = context;
          return AlertDialog(
              content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(
                width: 10,
              ),
              Text("${AppLocalizations.of(context).loading_text}"),
            ],
          ));
        });
  }
}
