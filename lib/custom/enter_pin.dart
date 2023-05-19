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
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class EnterPin extends StatefulWidget {
  EnterPin({Key key, this.title, this.bookingid, this.passengers})
      : super(key: key);

  final String title;
  final int bookingid;
  final List<Passenger> passengers;

  @override
  _EnterPinState createState() => _EnterPinState();
}

class _EnterPinState extends State<EnterPin> {
  final _otpController = TextEditingController();
  BuildContext loadingContext;

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
                    'Please fill in the following form with your password to complete payment'),
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
                  'Enter Password',
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
                        'Enter OTP',
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
    final prefs = await SharedPreferences.getInstance();
    final userPassword = prefs.getString('user_password');

    var otp = _otpController.text.toString();
    if (otp == "") {
      ToastComponent.showDialog('Please enter the otp',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else if (otp != userPassword) {
      ToastComponent.showDialog('The password you entered is incorrect',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else {
      var data = {
        "aerocrs": {
          "parms": {
            "bookingid": widget.bookingid,
            "agentconfirmation": "apiconnector",
            "confirmationemail": "test@test.com",
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
        loading('Requesting Payment...');

        var amount = bookingResponse.topay.split('.')[0];
        var account = '12345';
        var serviceName = 'AIRLINE_PAYMENT';
        String transactionId = DateTime.now().millisecondsSinceEpoch.toString();
        transactionId = transactionId + user_name.$;

        var transactionResponse = await PaymentRepository().transactionResponse(
            account_number.$,
            account,
            amount,
            serviceName,
            account_number.$,
            user_phone.$,
            user_name.$,
            user_name.$,
            transactionId);
        Navigator.of(loadingContext).pop();

        if (transactionResponse.status != 'RECEIVED') {
          ToastComponent.showDialog(transactionResponse.message,
              gravity: Toast.center, duration: Toast.lengthLong);
        } else {
          ToastComponent.showDialog(transactionResponse.message,
              gravity: Toast.center, duration: Toast.lengthLong);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return TransactionOTP(
              title: 'Enter OTP',
              transactionReference: transactionResponse.transactionId,
              tranType: serviceName,
            );
          }));
        }
      }
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
