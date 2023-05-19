import 'dart:convert';

import 'package:hustla/custom/app_bar.dart';
import 'package:hustla/custom/device_info.dart';
import 'package:hustla/custom/page_description.dart';
import 'package:hustla/custom/resources.dart';
import 'package:hustla/custom/spacers.dart';
import 'package:hustla/custom/toast_component.dart';
import 'package:hustla/data_model/destination_response.dart';
import 'package:hustla/data_model/flights_response.dart';
import 'package:hustla/my_theme.dart';
import 'package:hustla/repositories/airline_repository.dart';
import 'package:hustla/screens/passenger_details.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class FlightOptions extends StatefulWidget {
  FlightOptions(
      {Key key,
      this.title,
      this.departureDate,
      this.returnDate,
      this.flightsResponse,
      this.adults,
      this.children,
      this.infants,
      this.cabinClass,
      this.tripType})
      : super(key: key);

  final String title, departureDate, returnDate;
  final TripType tripType;
  final FlightsResponse flightsResponse;
  final String adults, children, infants;
  final CabinClass cabinClass;
  @override
  _FlightOptionsState createState() => _FlightOptionsState();
}

class _FlightOptionsState extends State<FlightOptions> {
  List<Flight> _flights;
  List<Flight> _outboundFlights;
  List<Flight> _inboundFlights;
  List<List<Flight>> _combinedFlights = [];
  BuildContext loadingcontext;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _flights = widget.flightsResponse.flights;

    _outboundFlights =
        _flights.where((flight) => flight.direction == 'outbound').toList();
    _inboundFlights =
        _flights.where((flight) => flight.direction == 'inbound').toList();

    for (var outboundFlight in _outboundFlights) {
      for (var inboundFlight in _inboundFlights) {
        _combinedFlights.add([outboundFlight, inboundFlight]);
      }
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
            padding: const EdgeInsets.only(top: 8.0), child: buildBody()));
  }

  Widget buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildDescription(widget.title,
                description:
                    'Please select one of the following available options'),
            buildDateTime(),
            widget.tripType.code == 'OW'
                ? buildOutboundFlights(context, _outboundFlights)
                : buildCombinedFlights(context, _combinedFlights),
          ],
        ),
      ),
    );
  }

  Widget buildDateTime() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Text(
            'Departure: ',
            style: TextStyle(
                color: MyTheme.font_grey,
                fontSize: 15,
                fontWeight: FontWeight.w100),
          ),
          Text(
            '${_outboundFlights[0].departureTime.substring(0, 11)}',
            style: TextStyle(
                color: AppColors.dashboardColor,
                fontSize: 15,
                fontWeight: FontWeight.w300),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.14),
          Visibility(
            visible: widget.tripType.code == 'RT',
            child: Text(
              'Return: ',
              style: TextStyle(
                  color: MyTheme.font_grey,
                  fontSize: 15,
                  fontWeight: FontWeight.w100),
            ),
          ),
          Visibility(
            visible: widget.tripType.code == 'RT',
            child: Text(
              widget.returnDate,
              style: TextStyle(
                  color: AppColors.dashboardColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w300),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOutboundFlights(BuildContext context, List<Flight> flights) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 3.7,
        crossAxisCount: 1,
      ),
      itemCount: flights.length,
      padding: EdgeInsets.only(left: 8, right: 8, bottom: 30),
      scrollDirection: Axis.vertical,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return buildSingleCard(context, flights, index);
      },
    );
  }

  Widget buildCombinedFlights(
      BuildContext context, List<List<Flight>> combinedFlights) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 2.5,
        crossAxisCount: 1,
      ),
      itemCount: combinedFlights.length,
      padding: EdgeInsets.only(left: 8, right: 8, bottom: 30),
      scrollDirection: Axis.vertical,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return buildCombinedCard(context, combinedFlights, index);
      },
    );
  }

  Widget buildSingleCard(
      BuildContext context, List<Flight> flights, int index) {
    var _taxFare = double.parse(flights[index].fare.tax);

    var itemWidth = (DeviceInfo(context).width);
    var _adultFare = int.parse(widget.adults) > 0
        ? double.parse(widget.adults) *
                double.parse(flights[index].fare.adultFare) +
            _taxFare
        : 0;
    var _childrenFare = int.parse(widget.children) > 0
        ? double.parse(widget.children) *
                double.parse(flights[index].fare.childFare) +
            _taxFare
        : 0;
    var _infantFare = int.parse(widget.infants) > 0
        ? double.parse(widget.infants) *
                double.parse(flights[index].fare.infantFare) +
            _taxFare
        : 0;

    String _totalFare =
        (_adultFare + _childrenFare + _infantFare).toStringAsFixed(2);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.appBarColor),
          borderRadius: BorderRadius.circular(10),
          color: Colors.white70,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 20,
              spreadRadius: 0.0,
              offset: Offset(0.0, 10.0), // shadow direction: bottom right
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(6),
                          topLeft: Radius.circular(6)),
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/placeholder.png',
                        image: flights[index].airlineLogo,
                        fit: BoxFit.cover,
                        width: itemWidth / 10,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${flights[index].departureTime.substring(11, 16)}  -  ${flights[index].arrivalTime.substring(11, 16)}',
                    // textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: AppColors.dashboardColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w300),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '${flights[index].fromcode}  ->  ${flights[index].tocode}  ',
                    // textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 12,
                    ),
                  ),
                  VSpace.md,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.man,
                        size: 15,
                      ),
                      Text(
                        '${widget.adults}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: MyTheme.font_grey,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(
                        Icons.boy,
                        size: 15,
                      ),
                      Text(
                        '${widget.children}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: MyTheme.font_grey,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(
                        Icons.child_care,
                        size: 15,
                      ),
                      SizedBox(width: 2),
                      Text(
                        '${widget.infants}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: MyTheme.font_grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${widget.tripType.name}',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '${widget.cabinClass.name}',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    'USD $_totalFare',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 12,
                    ),
                  ),
                  Spacer(),
                  SizedBox(
                    height: 30,
                    child: ElevatedButton(
                      onPressed: () {
                        _onSubmit(flights[index], null);
                      },
                      // ignore: sort_child_properties_last
                      child: Text(
                        'Book Now',
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: MyTheme.accent_color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // <-- Radius
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCombinedCard(
      BuildContext context, List<List<Flight>> flights, int index) {
    var itemWidth = (DeviceInfo(context).width);
    Flight outBound = flights[index][0];
    Flight inBound = flights[index][1];

    var _outBoundTax = double.parse(outBound.fare.tax);
    var _inBoundTax = double.parse(inBound.fare.tax);

    var _outBoundAdultFare = int.parse(widget.adults) > 0
        ? double.parse(widget.adults) * double.parse(outBound.fare.adultFare) +
            _outBoundTax
        : 0;
    var _inBoundAdultFare = int.parse(widget.adults) > 0
        ? double.parse(widget.adults) * double.parse(inBound.fare.adultFare) +
            _inBoundTax
        : 0;
    var _totalAdultFare = _outBoundAdultFare + _inBoundAdultFare;

    var _outBoundChildrenFare = int.parse(widget.children) > 0
        ? double.parse(widget.children) *
                double.parse(outBound.fare.childFare) +
            _outBoundTax
        : 0;
    var _inBoundChildrenFare = int.parse(widget.children) > 0
        ? double.parse(widget.children) * double.parse(inBound.fare.childFare) +
            _inBoundTax
        : 0;
    var _totalChildrenFare = _outBoundChildrenFare + _inBoundChildrenFare;

    var _outBoundInfantFare = int.parse(widget.infants) > 0
        ? double.parse(widget.infants) *
                double.parse(outBound.fare.infantFare) +
            _outBoundTax
        : 0;
    var _inBoundInfantFare = int.parse(widget.infants) > 0
        ? double.parse(widget.infants) * double.parse(inBound.fare.infantFare) +
            _inBoundTax
        : 0;
    var _totalInfantFare = _outBoundInfantFare + _inBoundInfantFare;

    String _totalFare =
        (_totalAdultFare + _totalChildrenFare + _totalInfantFare)
            .toStringAsFixed(2);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.appBarColor),
          borderRadius: BorderRadius.circular(10),
          color: Colors.white70,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 20,
              spreadRadius: 0.0,
              offset: Offset(0.0, 10.0), // shadow direction: bottom right
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(6),
                                  topLeft: Radius.circular(6)),
                              child: FadeInImage.assetNetwork(
                                placeholder: 'assets/placeholder.png',
                                image: outBound.airlineLogo,
                                fit: BoxFit.cover,
                                width: itemWidth / 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${outBound.departureTime.substring(11, 16)}  -  ${outBound.arrivalTime.substring(11, 16)}',
                            // textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: AppColors.dashboardColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w300),
                          ),
                          Text(
                            '${outBound.fromcode}  ->  ${outBound.tocode}  ',
                            // textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: MyTheme.font_grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(6),
                                    topLeft: Radius.circular(6)),
                                child: FadeInImage.assetNetwork(
                                  placeholder: 'assets/placeholder.png',
                                  image: inBound.airlineLogo,
                                  fit: BoxFit.cover,
                                  width: itemWidth / 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${inBound.departureTime.substring(11, 16)}  -  ${inBound.arrivalTime.substring(11, 16)}',
                              // textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: AppColors.dashboardColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300),
                            ),
                            Text(
                              '${inBound.fromcode}  ->  ${inBound.tocode}  ',
                              // textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: MyTheme.font_grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 45, top: 8.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.man,
                          size: 15,
                        ),
                        Text(
                          '${widget.adults}',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: MyTheme.font_grey,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(
                          Icons.boy,
                          size: 15,
                        ),
                        Text(
                          '${widget.children}',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: MyTheme.font_grey,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(
                          Icons.child_care,
                          size: 15,
                        ),
                        SizedBox(width: 2),
                        Text(
                          '${widget.infants}',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: MyTheme.font_grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${widget.tripType.name}',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 12,
                    ),
                  ),
                  VSpace.md,
                  Text(
                    '${widget.cabinClass.name}',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 12,
                    ),
                  ),
                  VSpace.md,
                  Text(
                    'USD $_totalFare',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 12,
                    ),
                  ),
                  Spacer(),
                  SizedBox(
                    height: 30,
                    child: ElevatedButton(
                      onPressed: () {
                        _onSubmit(outBound, inBound);
                      },
                      // ignore: sort_child_properties_last
                      child: Text(
                        'Book Now',
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: MyTheme.accent_color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // <-- Radius
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSubmit(Flight outbound, Flight inbound) async {
    List<Map<String, dynamic>> bookings = [];
    bookings.add({
      "fromcode": outbound.fromcode,
      "tocode": outbound.tocode,
      "flightid": outbound.flightid,
      "fareid": outbound.fareid
    });

    if (widget.tripType.code == 'RT') {
      bookings.add({
        "fromcode": inbound.fromcode,
        "tocode": inbound.tocode,
        "flightid": inbound.flightid,
        "fareid": inbound.fareid
      });
    }
    var data = {
      'aerocrs': {
        'parms': {
          'triptype': widget.tripType.code,
          'adults': widget.adults,
          'child': widget.children,
          'infant': widget.infants,
          "bookflight": bookings
        },
      }
    };
    var postData = jsonEncode(data);
    loading('Please wait...');

    var bookingResponse = await AirlineRepository().createBooking(postData);
    Navigator.of(loadingcontext).pop();
    if (bookingResponse.success == false) {
      bookingResponse.errors.forEach((error) {
        ToastComponent.showDialog(error,
            gravity: Toast.center, duration: Toast.lengthLong);
      });
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return PassengerDetails(
          adults: widget.adults,
          children: widget.children,
          infants: widget.infants,
          cabinClass: widget.cabinClass,
          booking: bookingResponse.booking,
        );
      }));
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
