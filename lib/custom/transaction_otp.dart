import 'dart:convert';

import 'package:hustla/custom/app_bar.dart';
import 'package:hustla/custom/device_info.dart';
import 'package:hustla/custom/input_decorations.dart';
import 'package:hustla/custom/page_description.dart';
import 'package:hustla/custom/process_completed.dart';
import 'package:hustla/custom/resources.dart';
import 'package:hustla/custom/toast_component.dart';
import 'package:hustla/helpers/shared_value_helper.dart';
import 'package:hustla/my_theme.dart';
import 'package:hustla/repositories/top_up_repository.dart';
import 'package:hustla/screens/main.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TransactionOTP extends StatefulWidget {
  TransactionOTP(
      {Key key, this.title, this.transactionReference, this.tranType})
      : super(key: key);

  final String title;
  final String transactionReference;
  final String tranType;

  @override
  _TransactionOTPState createState() => _TransactionOTPState();
}

class _TransactionOTPState extends State<TransactionOTP> {
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
    var otp = _otpController.text.toString();
    if (otp == "") {
      ToastComponent.showDialog('Please enter the otp',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }
    var tranReference = widget.transactionReference;
    var tranType = widget.tranType;
    var walletId = account_number.$;
    Map rawData = {
      "otp": otp,
      "walletId": walletId,
      "tranType": tranType,
      "tranReference": tranReference,
      "appVersion": "1.0.0+1",
      "checkoutMode": "HUSTLAZWALLET",
      "osType": "ANDROID"
    };
    var data = jsonEncode(rawData);
    loading();
    var topUpResponse = await PaymentRepository().transactionOTPResponse(data);
    Navigator.of(loadingcontext).pop();

    if (topUpResponse.status != 'SUCCESS') {
      ToastComponent.showDialog(topUpResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);
    } else {
      ToastComponent.showDialog('Transaction was processed successfully',
          gravity: Toast.center, duration: Toast.lengthLong);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return ProcessCompleted(
          description:
              'Congratulations, your transaction was processed successfully!',
        );
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
