import 'dart:io';

import 'package:hustla/custom/app_bar.dart';
import 'package:hustla/custom/box_decorations.dart';
import 'package:hustla/custom/device_info.dart';
import 'package:hustla/custom/input_decorations.dart';
import 'package:hustla/custom/page_description.dart';
import 'package:hustla/custom/resources.dart';
import 'package:hustla/custom/transaction_otp.dart';
import 'package:hustla/custom/useful_elements.dart';
import 'package:hustla/helpers/shimmer_helper.dart';
import 'package:hustla/presenter/bottom_appbar_index.dart';
import 'package:hustla/repositories/add_shop_repository.dart';
import 'package:hustla/repositories/auth_repository.dart';
import 'package:hustla/screens/home.dart';
import 'package:hustla/screens/main.dart';
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
import 'package:validators/validators.dart';

import '../repositories/top_up_repository.dart';

class ShareFunds extends StatefulWidget {
  ShareFunds({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ShareFundsState createState() => _ShareFundsState();
}

class _ShareFundsState extends State<ShareFunds> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _accountController = TextEditingController();
  TextEditingController _saccoController =
      TextEditingController(text: sacco_name.$);
  BuildContext loadingcontext;

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
                  'Sacco Name',
                  style: TextStyle(
                      color: AppColors.appBarColor,
                      fontWeight: FontWeight.w300,
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
                        controller: _saccoController,
                        readOnly: true,
                        decoration: InputDecorations.buildInputDecoration_1(
                            hint_text: "ABC EMPOWERMENT SACCO LIMITED"),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  'Enter Amount',
                  style: TextStyle(
                      color: AppColors.appBarColor,
                      fontWeight: FontWeight.w300,
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
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  'Sacco Account',
                  style: TextStyle(
                      color: AppColors.appBarColor,
                      fontWeight: FontWeight.w300,
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
                        controller: _accountController,
                        autofocus: false,
                        decoration: InputDecorations.buildInputDecoration_1(
                            hint_text: "089008"),
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
                            fontWeight: FontWeight.w300),
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
                description: 'Please fill in the form below to share funds.'),
            creditForm(),
          ],
        ),
      ),
    );
  }

  onSubmit() async {
    var amount = _amountController.text.toString();
    var account = _accountController.text.toString();
    var serviceName = 'SHARE_FUNDS';
    String transactionId = DateTime.now().millisecondsSinceEpoch.toString();
    transactionId = transactionId + user_name.$;

    if (amount == "") {
      ToastComponent.showDialog('Please enter the amount',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else if (account == "") {
      ToastComponent.showDialog(
          'Please enter a sacco account you want to share with',
          gravity: Toast.center,
          duration: Toast.lengthLong);
      return;
    }
    var toAccount = account;
    loading();
    var transactionResponse = await PaymentRepository().transactionResponse(
        account_number.$,
        toAccount,
        amount,
        serviceName,
        account_number.$,
        user_phone.$,
        user_name.$,
        user_name.$,
        transactionId);
    Navigator.of(loadingcontext).pop();

    if (transactionResponse.status != 'RECEIVED') {
      ToastComponent.showDialog(transactionResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);
    } else {
      ToastComponent.showDialog(transactionResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return TransactionOTP(
          title: 'Enter OTP',
          transactionReference: transactionResponse.transactionId,
          tranType: serviceName,
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
