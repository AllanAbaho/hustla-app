import 'package:hustla/custom/app_bar.dart';
import 'package:hustla/custom/device_info.dart';
import 'package:hustla/custom/input_decorations.dart';
import 'package:hustla/custom/page_description.dart';
import 'package:hustla/custom/resources.dart';
import 'package:hustla/screens/confirm_booking.dart';
import 'package:hustla/custom/toast_component.dart';
import 'package:hustla/data_model/confirm_booking_response.dart';
import 'package:hustla/my_theme.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

class EditPassenger extends StatefulWidget {
  EditPassenger({Key key, this.passengers, this.index, this.bookingid})
      : super(key: key);

  final List<Passenger> passengers;
  final int index, bookingid;

  @override
  _EditPassengerState createState() => _EditPassengerState();
}

class _EditPassengerState extends State<EditPassenger> {
  TextEditingController _paxtitleController = TextEditingController();
  TextEditingController _firstnameController = TextEditingController();
  TextEditingController _lastnameController = TextEditingController();
  TextEditingController _paxageController = TextEditingController();
  TextEditingController _paxnationailtyController = TextEditingController();
  TextEditingController _paxdoctypeController = TextEditingController();
  TextEditingController _paxdocnumberController = TextEditingController();
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
  List<Map<String, String>> _nations = [
    {'code': 'KE', 'name': 'Kenyan'},
    {'code': 'UG', 'name': 'Ugandan'},
  ];

  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _paxtitleController.text = widget.passengers[widget.index].paxtitle;
    _firstnameController.text = widget.passengers[widget.index].firstname;
    _lastnameController.text = widget.passengers[widget.index].lastname;
    _paxageController.text = widget.passengers[widget.index].paxage;
    _paxnationailtyController.text =
        widget.passengers[widget.index].paxnationailty;
    _paxdoctypeController.text = widget.passengers[widget.index].paxdoctype;
    _paxdocnumberController.text = widget.passengers[widget.index].paxdocnumber;
    _paxdocexpiryController.text = widget.passengers[widget.index].paxdocexpiry;
    _paxbirthdateController.text = widget.passengers[widget.index].paxbirthdate;
    _paxphoneController.text = widget.passengers[widget.index].paxphone;
    _paxemailController.text = widget.passengers[widget.index].paxemail;
    print(widget.passengers[widget.index].paxnationailty);
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
                    'Please enter the following details below to confirm passenger details'),
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
                    'Enter Passenger ${widget.index + 1}  Details',
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
                  selectedItem: widget.passengers[widget.index].paxtitle,
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
                child: DropdownSearch<Map<String, String>>(
                  items: _nations,
                  itemAsString: (item) {
                    _paxnationailtyController.text = item['code'];
                    return item['name'];
                  },
                  onChanged: (item) {
                    _paxnationailtyController.text = item['code'];
                  },
                  selectedItem: _nations.firstWhere((e) =>
                      e['code'] ==
                      widget.passengers[widget.index].paxnationailty),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  'Identification Type',
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
                  selectedItem: _docTypes.firstWhere((e) =>
                      e['code'] == widget.passengers[widget.index].paxdoctype),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  'Identification Number',
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
                  'Identification Expiry Date',
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
      ToastComponent.showDialog('Please enter your identification number',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else if (_paxdocexpiryController.text.isEmpty) {
      ToastComponent.showDialog('Please enter your identification expiry date',
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
      paxdocissuer: _paxnationailtyController.text,
      paxdocexpiry: _paxdocexpiryController.text,
      paxbirthdate: _paxbirthdateController.text,
      paxphone: _paxphoneController.text,
      paxemail: _paxemailController.text.trim(),
    );
    widget.passengers[widget.index] = _passenger;
    _confirmPage();
  }

  void _confirmPage() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return ConfirmBooking(
          title: 'Confirm Booking',
          bookingid: widget.bookingid,
          passengers: widget.passengers);
    }));
  }
}
