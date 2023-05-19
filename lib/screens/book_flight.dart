import 'dart:io';

import 'package:hustla/custom/app_bar.dart';
import 'package:hustla/custom/device_info.dart';
import 'package:hustla/custom/input_decorations.dart';
import 'package:hustla/custom/page_description.dart';
import 'package:hustla/custom/resources.dart';
import 'package:hustla/data_model/destination_response.dart';
import 'package:hustla/repositories/airline_repository.dart';
import 'package:hustla/repositories/top_up_repository.dart';
import 'package:hustla/screens/flight_options.dart';
import 'package:hustla/screens/main.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:hustla/my_theme.dart';
import 'package:hustla/custom/toast_component.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import 'package:hustla/helpers/shared_value_helper.dart';

class BookFlight extends StatefulWidget {
  BookFlight({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _BookFlightState createState() => _BookFlightState();
}

class _BookFlightState extends State<BookFlight> {
  TextEditingController _fromController = TextEditingController();
  TextEditingController _toController = TextEditingController();
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  TextEditingController _adultsController = TextEditingController();
  TextEditingController _childrenController = TextEditingController();
  TextEditingController _infantsController = TextEditingController();
  TextEditingController _classController = TextEditingController();
  BuildContext loadingcontext;

  int adults, children, infants;

  List<Destination> _list = [];
  List<TripType> _tripTypes = [
    TripType('One Way', 'OW'),
    TripType('Round Trip', 'RT'),
  ];

  List<CabinClass> _cabinClasses = [
    CabinClass('Economy', 'ECO'),
    CabinClass('Business', 'BIZ'),
    CabinClass('Premium Economy', 'PRM'),
    CabinClass('First Class', 'FST'),
  ];

  CabinClass _selectedCabinClass;
  TripType _selectedTripType;
  DateTime selectedDate = DateTime.now().add(
    Duration(days: 1),
  );
  DateTime selectedEndDate = DateTime.now().add(
    Duration(days: 10),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDestinations();
    _startDateController.text = DateFormat('yyyy/MM/dd').format(selectedDate);
    _endDateController.text = DateFormat('yyyy/MM/dd').format(selectedEndDate);

    _selectedCabinClass = _cabinClasses[0];
    adults = 1;
    children = 0;
    infants = 0;
    _adultsController.text = adults.toString();
    _childrenController.text = children.toString();
    _infantsController.text = infants.toString();
    _selectedTripType = _tripTypes[0];
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
        _startDateController.text = formattedDate;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedEndDate,
      firstDate: selectedEndDate,
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
    if (picked != null && picked != selectedEndDate) {
      String formattedDate = DateFormat('yyyy/MM/dd').format(picked);

      setState(() {
        _endDateController.text = formattedDate;
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
            )),
        body: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: _list.isEmpty
              ? Center(
                  child: CircularProgressIndicator(
                    color: MyTheme.accent_color,
                  ),
                )
              : buildBody(),
        ));
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
                child: Text(
                  'Trip Type',
                  style: TextStyle(
                      color: AppColors.appBarColor,
                      fontWeight: FontWeight.w300,
                      fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 25.0),
                child: DropdownSearch<TripType>(
                  items: _tripTypes,
                  itemAsString: (item) {
                    return item.name;
                  },
                  onChanged: (item) {
                    print(_selectedTripType.code);
                    setState(() {
                      _selectedTripType = item;
                    });
                  },
                  selectedItem: _tripTypes[0],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  'Departing From',
                  style: TextStyle(
                      color: AppColors.appBarColor,
                      fontWeight: FontWeight.w300,
                      fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 25.0),
                child: DropdownSearch<Destination>(
                  items: _list,
                  itemAsString: (item) {
                    _fromController.text = item.code;
                    return item.name;
                  },
                  onChanged: (item) {
                    _fromController.text = item.code;
                  },
                  selectedItem: _list[4],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  'Destination',
                  style: TextStyle(
                      color: AppColors.appBarColor,
                      fontWeight: FontWeight.w300,
                      fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 25.0),
                child: DropdownSearch<Destination>(
                  items: _list,
                  itemAsString: (item) {
                    _toController.text = item.code;
                    return item.name;
                  },
                  onChanged: (item) {
                    _toController.text = item.code;
                  },
                  selectedItem: _list[9],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  'Departure Date',
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
                        controller: _startDateController,
                        readOnly: true,
                        decoration: InputDecorations.buildInputDecoration_1(
                            hint_text: "2023/04/05"),
                        onTap: () => _selectDate(context),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: _selectedTripType.code == 'RT',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text(
                        'Return Date',
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
                              controller: _endDateController,
                              readOnly: true,
                              decoration:
                                  InputDecorations.buildInputDecoration_1(
                                      hint_text: "2023/04/05"),
                              onTap: () => _selectEndDate(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  'Number of Adults',
                  style: TextStyle(
                      color: AppColors.appBarColor,
                      fontWeight: FontWeight.w300,
                      fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 25.0),
                child: Container(
                  height: 36,
                  child: TextField(
                    keyboardType: TextInputType.text,
                    controller: _adultsController,
                    readOnly: true,
                    decoration: InputDecorations.buildInputDecoration_1(
                        suffix: Container(
                      width: DeviceInfo(context).width * .24,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                              adults++;
                              setState(() {
                                _adultsController.text = adults.toString();
                              });
                            },
                            icon: Icon(Icons.add),
                          ),
                          IconButton(
                            onPressed: () {
                              if (adults > 0) {
                                adults--;
                                setState(() {
                                  _adultsController.text = adults.toString();
                                });
                              }
                            },
                            icon: Icon(Icons.remove),
                          ),
                        ],
                      ),
                    )),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  'Number of Children',
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
                        controller: _childrenController,
                        readOnly: true,
                        decoration: InputDecorations.buildInputDecoration_1(
                            suffix: Container(
                          width: DeviceInfo(context).width * .24,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  children++;
                                  setState(() {
                                    _childrenController.text =
                                        children.toString();
                                  });
                                },
                                icon: Icon(Icons.add),
                              ),
                              IconButton(
                                onPressed: () {
                                  if (children > 0) {
                                    children--;
                                    setState(() {
                                      _childrenController.text =
                                          children.toString();
                                    });
                                  }
                                },
                                icon: Icon(Icons.remove),
                              ),
                            ],
                          ),
                        )),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  'Number of Infants',
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
                        controller: _infantsController,
                        readOnly: true,
                        decoration: InputDecorations.buildInputDecoration_1(
                            suffix: Container(
                          width: DeviceInfo(context).width * .24,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  infants++;
                                  setState(() {
                                    _infantsController.text =
                                        infants.toString();
                                  });
                                },
                                icon: Icon(Icons.add),
                              ),
                              IconButton(
                                onPressed: () {
                                  if (infants > 0) {
                                    infants--;
                                    setState(() {
                                      _infantsController.text =
                                          infants.toString();
                                    });
                                  }
                                },
                                icon: Icon(Icons.remove),
                              ),
                            ],
                          ),
                        )),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  'Class',
                  style: TextStyle(
                      color: AppColors.appBarColor,
                      fontWeight: FontWeight.w300,
                      fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 25.0),
                child: DropdownSearch<CabinClass>(
                  items: _cabinClasses,
                  itemAsString: (item) {
                    _classController.text = item.code;
                    return item.name;
                  },
                  onChanged: (item) {
                    _selectedCabinClass = item;
                  },
                  selectedItem: _selectedCabinClass,
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
                description:
                    'Please fill in the form below to book your air ticket.'),
            buildForm(),
          ],
        ),
      ),
    );
  }

  onSubmit() async {
    var from = _fromController.text.toString();
    var to = _toController.text.toString();
    var start = _startDateController.text.toString();
    var end = _selectedTripType.code == 'RT'
        ? _endDateController.text.toString()
        : '';
    var adults = _adultsController.text.toString();
    var child = _childrenController.text.toString();
    var infant = _infantsController.text.toString();
    var cabinCode = _selectedCabinClass.code;

    loading('Please wait...');
    print(end);

    var flightsResponse = await AirlineRepository()
        .getFlights(from, to, start, adults, child, infant, cabinCode, end);
    Navigator.of(loadingcontext).pop();
    if (flightsResponse.success == false) {
      ToastComponent.showDialog(flightsResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);
    } else {
      if (flightsResponse.count == 0) {
        ToastComponent.showDialog('No flights found',
            gravity: Toast.center, duration: Toast.lengthLong);
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return FlightOptions(
                  title: 'Flight Options',
                  flightsResponse: flightsResponse,
                  adults: adults,
                  children: child,
                  infants: infant,
                  cabinClass: _selectedCabinClass,
                  tripType: _selectedTripType,
                  departureDate: start,
                  returnDate: end);
            },
          ),
        );
      }
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

  getDestinations() async {
    var _destinations = await AirlineRepository().getDestinations();
    setState(() {
      _list = _destinations.destinations;
    });
  }
}
