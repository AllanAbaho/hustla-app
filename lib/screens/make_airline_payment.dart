import 'dart:convert';

import 'package:active_ecommerce_flutter/custom/app_bar.dart';
import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/custom/input_decorations.dart';
import 'package:active_ecommerce_flutter/custom/page_description.dart';
import 'package:active_ecommerce_flutter/custom/resources.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/repositories/airline_repository.dart';
import 'package:active_ecommerce_flutter/screens/main.dart';
import 'package:active_ecommerce_flutter/screens/travel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

class MakeAirlinePayment extends StatefulWidget {
  MakeAirlinePayment({Key key, this.title, this.bookingid}) : super(key: key);

  final String title;
  final int bookingid;

  @override
  _MakeAirlinePaymentState createState() => _MakeAirlinePaymentState();
}

class _MakeAirlinePaymentState extends State<MakeAirlinePayment> {
  TextEditingController _creditcardpayerController = TextEditingController();
  TextEditingController _creditcardnumberController = TextEditingController();
  TextEditingController _creditcardexpiryController = TextEditingController();
  TextEditingController _creditcardcvvController = TextEditingController();
  BuildContext loadingContext;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> _selectExpiryDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: selectedDate,
      lastDate: DateTime.now().add(
        Duration(days: 365),
      ),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(primary: MyTheme.accent_color),
          ),
          child: child,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      String formattedDate = DateFormat('MM/yy').format(picked);
      setState(() {
        _creditcardexpiryController.text = formattedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          child: buildAppBar(context, widget.title),
          preferredSize: Size(
            DeviceInfo(context).width,
            60,
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.only(top: 8.0), child: buildBody()));
  }

  Widget buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildDescription('Make Payment',
                description:
                    'Please enter the following details below to make payment'),
            buildForm(),
          ],
        ),
      ),
    );
  }

  Widget buildForm() {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Container(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Text(
            'Credit Card Payer',
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
                  keyboardType: TextInputType.text,
                  controller: _creditcardpayerController,
                  autofocus: false,
                  decoration: InputDecorations.buildInputDecoration_1(
                      hint_text: user_name.$),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Text(
            'Credit Card Number',
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
                  controller: _creditcardnumberController,
                  autofocus: false,
                  decoration: InputDecorations.buildInputDecoration_1(
                      hint_text: '5326445577889977'),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Text(
            'Credit Card Expiry',
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
                  keyboardType: TextInputType.text,
                  controller: _creditcardexpiryController,
                  readOnly: true,
                  decoration: InputDecorations.buildInputDecoration_1(
                      hint_text: '25/07'),
                  onTap: () => _selectExpiryDate(context),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Text(
            'Credit Card CVV',
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
                  controller: _creditcardcvvController,
                  autofocus: false,
                  decoration:
                      InputDecorations.buildInputDecoration_1(hint_text: '303'),
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
                    borderRadius: const BorderRadius.all(Radius.circular(6.0))),
                child: Text(
                  'Make payment',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                onPressed: () {
                  _onSubmit();
                }),
          ),
        ),
      ]))
    ]);
  }

  void _onSubmit() async {
    if (_creditcardpayerController.text.isEmpty) {
      ToastComponent.showDialog('Please enter the payer account name',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else if (_creditcardnumberController.text.isEmpty) {
      ToastComponent.showDialog('Please enter the credit card number',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else if (_creditcardexpiryController.text.isEmpty) {
      ToastComponent.showDialog('Please enter the credit card expiry month',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else if (_creditcardcvvController.text.isEmpty) {
      ToastComponent.showDialog('Please enter the credit card CVV',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }
    var data = {
      "aerocrs": {
        "parms": {
          "bookingid": widget.bookingid,
          "creditcardpayer": _creditcardpayerController.text,
          "creditcardnumber": _creditcardnumberController.text,
          "creditcardexpiry":
              _creditcardexpiryController.text.replaceAll('/', ''),
          "creditcardcvv": _creditcardcvvController.text
        }
      }
    };
    var postData = jsonEncode(data);
    loading('Please wait...');

    var paymentResponse =
        await AirlineRepository().makeAirlinePayment(postData);
    Navigator.of(loadingContext).pop();
    print('look at my errors');
    print(paymentResponse.paymentstatusexplanation);
    if (paymentResponse.success == false) {
      if (paymentResponse.errors.isNotEmpty) {
        paymentResponse.errors.forEach((error) {
          ToastComponent.showDialog(error,
              gravity: Toast.center, duration: Toast.lengthLong);
          return;
        });
      } else {
        ToastComponent.showDialog(paymentResponse.paymentstatusexplanation,
            gravity: Toast.center, duration: Toast.lengthLong);
        return;
      }
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Main();
      }));
    }
  }

  loading(String loadingText) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          loadingContext = context;
          return AlertDialog(
              content: Row(
            children: [
              CircularProgressIndicator(color: MyTheme.accent_color),
              SizedBox(
                width: 10,
              ),
              Text(loadingText),
            ],
          ));
        });
  }
}