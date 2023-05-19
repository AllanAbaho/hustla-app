import 'package:hustla/custom/app_bar.dart';
import 'package:hustla/custom/device_info.dart';
import 'package:hustla/custom/input_decorations.dart';
import 'package:hustla/custom/page_description.dart';
import 'package:hustla/custom/process_completed.dart';
import 'package:hustla/custom/resources.dart';
import 'package:hustla/helpers/shared_value_helper.dart';
import 'package:hustla/repositories/top_up_repository.dart';
import 'package:hustla/screens/main.dart';
import 'package:flutter/material.dart';
import 'package:hustla/my_theme.dart';
import 'package:hustla/custom/toast_component.dart';
import 'package:toast/toast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RequestFunds extends StatefulWidget {
  RequestFunds({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _RequestFundsState createState() => _RequestFundsState();
}

class _RequestFundsState extends State<RequestFunds> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _periodController = TextEditingController();
  TextEditingController _purposeController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _contactController = TextEditingController();
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
                  'Sacco',
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
                  'Amount',
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
                  'Repayment period (months)',
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
                        controller: _periodController,
                        autofocus: false,
                        decoration: InputDecorations.buildInputDecoration_1(
                            hint_text: "6"),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  'Purpose of funds',
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
                        controller: _purposeController,
                        autofocus: false,
                        maxLines: 5,
                        decoration: InputDecorations.buildInputDecoration_1(
                            hint_text: "I want to start a business"),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  'Next of kin name',
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
                        keyboardType: TextInputType.text,
                        controller: _nameController,
                        autofocus: false,
                        decoration: InputDecorations.buildInputDecoration_1(
                            hint_text: "Allan Abaho"),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  'Next of kin contact',
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
                        controller: _contactController,
                        autofocus: false,
                        decoration: InputDecorations.buildInputDecoration_1(
                            hint_text: "+254700454545"),
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
                description: 'Please fill in the form below to request funds.'),
            creditForm(),
          ],
        ),
      ),
    );
  }

  onSubmit() async {
    var amount = _amountController.text.toString();
    var period = _periodController.text.toString();
    var purpose = _purposeController.text.toString();
    var name = _nameController.text.toString();
    var contact = _contactController.text.toString();
    var serviceName = 'REQUEST_FOR_FUNDS';
    String transactionId = DateTime.now().millisecondsSinceEpoch.toString();
    transactionId = transactionId + user_name.$;

    if (amount == "") {
      ToastComponent.showDialog('Please enter the amount',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else if (period == "") {
      ToastComponent.showDialog('Please enter the the repayment period',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else if (purpose == "") {
      ToastComponent.showDialog('Please enter the purpose for the funds',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else if (name == "") {
      ToastComponent.showDialog('Please enter the name of your next of kin',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else if (contact == "") {
      ToastComponent.showDialog('Please enter the contact of your next of kin',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }
    loading();
    var topUpResponse = await PaymentRepository().transactionResponse(
      account_number.$,
      account_number.$,
      amount,
      serviceName,
      account_number.$,
      user_phone.$,
      user_name.$,
      user_name.$,
      transactionId,
      repaymentPeriod: period,
      fundPurpose: purpose,
      nextOfKinName: name,
      nextOfKinContact: contact,
    );

    Navigator.of(loadingcontext).pop();

    if (topUpResponse.status != 'SUCCESS') {
      ToastComponent.showDialog(topUpResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);
    } else {
      ToastComponent.showDialog(topUpResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);
    }
    ToastComponent.showDialog(
        'Your application has been submitted successfully',
        gravity: Toast.center,
        duration: Toast.lengthLong);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return ProcessCompleted(
        description:
            'Congratulations, Your application has been submitted successfully',
      );
    }));
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
