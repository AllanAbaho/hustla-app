import 'dart:io';

import 'package:active_ecommerce_flutter/custom/app_bar.dart';
import 'package:active_ecommerce_flutter/custom/box_decorations.dart';
import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/custom/input_decorations.dart';
import 'package:active_ecommerce_flutter/custom/page_description.dart';
import 'package:active_ecommerce_flutter/custom/process_completed.dart';
import 'package:active_ecommerce_flutter/custom/resources.dart';
import 'package:active_ecommerce_flutter/custom/useful_elements.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_flutter/presenter/bottom_appbar_index.dart';
import 'package:active_ecommerce_flutter/repositories/add_shop_repository.dart';
import 'package:active_ecommerce_flutter/repositories/auth_repository.dart';
import 'package:active_ecommerce_flutter/screens/home.dart';
import 'package:active_ecommerce_flutter/screens/main.dart';
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
import 'package:validators/validators.dart';

import '../repositories/top_up_repository.dart';

class TopUp extends StatefulWidget {
  TopUp({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _TopUpState createState() => _TopUpState();
}

class _TopUpState extends State<TopUp> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _amountController = TextEditingController();
  BuildContext loadingcontext;
  bool isProcessing = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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

  Widget creditForm() {
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
                  'Amount',
                  style: TextStyle(
                      color: AppColors.appBarColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      height: 36,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: _amountController,
                        autofocus: false,
                        decoration: InputDecorations.buildInputDecoration_1(
                            hint_text: "1000"),
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
                        'Submit',
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

  Widget buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildDescription(widget.title,
                description:
                    'Please enter an amount in the form below to add credit to your wallet'),
            creditForm(),
          ],
        ),
      ),
    );
  }

  onSubmit() async {
    var amount = _amountController.text.toString();
    var serviceName = 'MOMO_TOPUP';
    String transactionId = DateTime.now().millisecondsSinceEpoch.toString();
    transactionId = transactionId + user_name.$;

    if (amount == "") {
      ToastComponent.showDialog('Please enter the amount',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }
    loading('Please wait...');

    var topUpResponse = await PaymentRepository().transactionResponse(
        user_phone.$,
        account_number.$,
        amount,
        serviceName,
        account_number.$,
        user_phone.$,
        user_name.$,
        user_name.$,
        transactionId);

    if (topUpResponse.status != 'PENDING') {
      Navigator.of(loadingcontext).pop();
      ToastComponent.showDialog(topUpResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);
    } else {
      return new Future.delayed(const Duration(seconds: 10), () {
        _checkStatus(transactionId);
      });
    }
  }

  _checkStatus(String transactionId) async {
    var statusResponse =
        await PaymentRepository().transactionStatusResponse(transactionId);
    if (statusResponse.finalStatus == 'SUCCESS') {
      Navigator.of(loadingcontext).pop();
      ToastComponent.showDialog(statusResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return ProcessCompleted(
          description:
              'Congratulations, your transaction was processed successfully!',
        );
      }));
    } else if (statusResponse.finalStatus == 'PROCESSING' ||
        statusResponse.finalStatus == 'PENDING') {
      return new Future.delayed(const Duration(seconds: 10), () {
        _checkStatus(transactionId);
      });
    } else {
      Navigator.of(loadingcontext).pop();
      ToastComponent.showDialog(statusResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);
    }
  }

  loading(String loadingText) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          loadingcontext = context;
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
