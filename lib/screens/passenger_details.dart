import 'dart:convert';

import 'package:active_ecommerce_flutter/custom/app_bar.dart';
import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/custom/input_decorations.dart';
import 'package:active_ecommerce_flutter/custom/page_description.dart';
import 'package:active_ecommerce_flutter/custom/resources.dart';
import 'package:active_ecommerce_flutter/screens/confirm_booking.dart';
import 'package:active_ecommerce_flutter/screens/ticket_otp.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:active_ecommerce_flutter/data_model/confirm_booking_response.dart';
import 'package:active_ecommerce_flutter/data_model/create_booking_response.dart';
import 'package:active_ecommerce_flutter/data_model/destination_response.dart';
import 'package:active_ecommerce_flutter/data_model/flights_response.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/repositories/airline_repository.dart';
import 'package:active_ecommerce_flutter/screens/make_airline_payment.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

class PassengerDetails extends StatefulWidget {
  PassengerDetails(
      {Key key,
      this.flight,
      this.adults,
      this.children,
      this.infants,
      this.cabinClass,
      this.booking})
      : super(key: key);

  final Flight flight;
  final String adults, children, infants;
  final CabinClass cabinClass;
  final Booking booking;

  @override
  _PassengerDetailsState createState() => _PassengerDetailsState();
}

class _PassengerDetailsState extends State<PassengerDetails> {
  TextEditingController _paxtitleController = TextEditingController();
  TextEditingController _firstnameController = TextEditingController();
  TextEditingController _lastnameController = TextEditingController();
  TextEditingController _paxageController = TextEditingController();
  TextEditingController _paxnationailtyController = TextEditingController();
  TextEditingController _paxdoctypeController = TextEditingController();
  TextEditingController _paxdocnumberController = TextEditingController();
  TextEditingController _paxdocissuerController = TextEditingController();
  TextEditingController _paxdocexpiryController = TextEditingController();
  TextEditingController _paxbirthdateController = TextEditingController();
  TextEditingController _paxphoneController = TextEditingController();
  TextEditingController _paxemailController = TextEditingController();
  BuildContext loadingContext;
  ScrollController scrollController = ScrollController();
  List<String> _list = ['Mr.', 'Mrs.', 'Miss.', 'Child', 'INFANT'];
  List<Map<String, String>> _docTypes = [
    {'code': 'PP', 'name': 'Passport'},
    {'code': 'ID', 'name': 'National ID'},
  ];

  List<Passenger> _passengerList = [];

  DateTime selectedDate = DateTime.now();

  int _numberOfPassengers;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _paxnationailtyController.text = 'KE';
    _paxdocissuerController.text = 'KE';

    _numberOfPassengers = int.parse(widget.adults) +
        int.parse(widget.children) +
        int.parse(widget.infants);
  }

  Future<void> _selectDate(BuildContext context) async {
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
      String formattedDate = DateFormat('yyyy/MM/dd').format(picked);

      setState(() {
        _paxbirthdateController.text = formattedDate;
      });
    }
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
      String formattedDate = DateFormat('yyyy/MM/dd').format(picked);

      setState(() {
        _paxdocexpiryController.text = formattedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            child: buildAppBar(context, 'Passenger Information'),
            preferredSize: Size(
              DeviceInfo(context).width,
              60,
            )),
        body: Padding(
            padding: const EdgeInsets.only(top: 8.0), child: buildBody()));
  }

  Widget buildBody() {
    return SingleChildScrollView(
      controller: scrollController,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildDescription('Passenger Information',
                description:
                    'Please enter the following details below to confirm booking your flight with ${widget.flight.airlineName}'),
            buildForm(),
          ],
        ),
      ),
    );
  }

  Widget buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Center(
                  child: Text(
                    'Enter Passenger ${_passengerList.length + 1}  Details',
                    style: TextStyle(
                        color: AppColors.appBarColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 20),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  'Title',
                  style: TextStyle(
                      color: AppColors.appBarColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 25.0),
                child: DropdownSearch<String>(
                  items: _list,
                  itemAsString: (item) {
                    _paxtitleController.text = item;
                    return item;
                  },
                  onChanged: (item) {
                    _paxtitleController.text = item;
                  },
                  selectedItem: _list[0],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  'First Name',
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
                        controller: _firstnameController,
                        autofocus: false,
                        decoration: InputDecorations.buildInputDecoration_1(),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  'Last Name',
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
                        controller: _lastnameController,
                        autofocus: false,
                        decoration: InputDecorations.buildInputDecoration_1(),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  'Birth Date',
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
                        readOnly: true,
                        controller: _paxbirthdateController,
                        autofocus: false,
                        decoration: InputDecorations.buildInputDecoration_1(
                            hint_text: '1990/01/01'),
                        onTap: () => _selectDate(context),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  'Phone Number',
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
                        controller: _paxphoneController,
                        autofocus: false,
                        decoration: InputDecorations.buildInputDecoration_1(),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  'Email Address',
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
                        controller: _paxemailController,
                        autofocus: false,
                        decoration: InputDecorations.buildInputDecoration_1(),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  'Age',
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
                        controller: _paxageController,
                        decoration: InputDecorations.buildInputDecoration_1(
                            hint_text: '18'),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  'Nationality',
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
                        controller: _paxnationailtyController,
                        readOnly: true,
                        decoration: InputDecorations.buildInputDecoration_1(),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  'Document Type',
                  style: TextStyle(
                      color: AppColors.appBarColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 25.0),
                child: DropdownSearch<Map<String, String>>(
                  items: _docTypes,
                  itemAsString: (item) {
                    _paxdoctypeController.text = item['code'];
                    return item['name'];
                  },
                  onChanged: (item) {
                    _paxdoctypeController.text = item['code'];
                  },
                  selectedItem: _docTypes[0],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  'Document Number',
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
                        controller: _paxdocnumberController,
                        autofocus: false,
                        decoration: InputDecorations.buildInputDecoration_1(
                            hint_text: '9919239123'),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  'Document Issuer',
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
                        controller: _paxdocissuerController,
                        readOnly: true,
                        decoration: InputDecorations.buildInputDecoration_1(),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  'Document Expiry',
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
                        readOnly: true,
                        controller: _paxdocexpiryController,
                        autofocus: false,
                        decoration: InputDecorations.buildInputDecoration_1(
                            hint_text: '2030/12/31'),
                        onTap: () => _selectExpiryDate(context),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 0.0),
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
                        'Next',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                      onPressed: () {
                        _onClickNext();
                      }),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  void _onClickNext() async {
    if (_firstnameController.text.isEmpty) {
      ToastComponent.showDialog('Please enter your first name',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else if (_lastnameController.text.isEmpty) {
      ToastComponent.showDialog('Please enter your last name',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else if (_paxbirthdateController.text.isEmpty) {
      ToastComponent.showDialog('Please enter your birth date',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else if (_paxphoneController.text.isEmpty) {
      ToastComponent.showDialog('Please enter the phone number',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else if (_paxemailController.text.isEmpty) {
      ToastComponent.showDialog('Please enter the email address',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else if (_paxageController.text.isEmpty) {
      ToastComponent.showDialog('Please enter your age',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else if (_paxdocnumberController.text.isEmpty) {
      ToastComponent.showDialog('Please enter your document number',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else if (_paxdocexpiryController.text.isEmpty) {
      ToastComponent.showDialog('Please enter your document expiry date',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    var _passenger = Passenger(
      paxtitle: _paxtitleController.text,
      firstname: _firstnameController.text,
      lastname: _lastnameController.text,
      paxage: _paxageController.text,
      paxnationailty: _paxnationailtyController.text,
      paxdoctype: _paxdoctypeController.text,
      paxdocnumber: _paxdocnumberController.text,
      paxdocissuer: _paxdocissuerController.text,
      paxdocexpiry: _paxdocexpiryController.text,
      paxbirthdate: _paxbirthdateController.text,
      paxphone: _paxphoneController.text,
      paxemail: _paxemailController.text.trim(),
    );
    setState(() {
      _passengerList.add(_passenger);
    });
    _paxtitleController.clear();
    _firstnameController.clear();
    _lastnameController.clear();
    _paxageController.clear();
    _paxdoctypeController.clear();
    _paxdocnumberController.clear();
    _paxdocexpiryController.clear();
    _paxbirthdateController.clear();
    _paxphoneController.clear();
    _paxemailController.clear();

    scrollController.animateTo(
        //go to top of scroll
        0, //scroll offset to go
        duration: Duration(milliseconds: 500), //duration of scroll
        curve: Curves.fastOutSlowIn //scroll type
        );

    if (_passengerList.length == _numberOfPassengers) {
      _confirmPage();
    }
  }

  loading(String loadingText) {
    showDialog(
        context: context,
        barrierDismissible: false,
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

  void _confirmPage() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return ConfirmBooking(
          title: 'Confirm Booking',
          bookingid: widget.booking.bookingid,
          passengers: _passengerList);
    }));
  }
}
