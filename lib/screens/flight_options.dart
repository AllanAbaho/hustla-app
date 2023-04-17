import 'dart:convert';

import 'package:active_ecommerce_flutter/custom/app_bar.dart';
import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/custom/page_description.dart';
import 'package:active_ecommerce_flutter/custom/resources.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:active_ecommerce_flutter/data_model/destination_response.dart';
import 'package:active_ecommerce_flutter/data_model/flights_response.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/repositories/airline_repository.dart';
import 'package:active_ecommerce_flutter/screens/passenger_details.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class FlightOptions extends StatefulWidget {
  FlightOptions(
      {Key key,
      this.title,
      this.flightsResponse,
      this.adults,
      this.children,
      this.infants,
      this.cabinClass,
      this.tripType})
      : super(key: key);

  final String title;
  final TripType tripType;
  final FlightsResponse flightsResponse;
  final String adults, children, infants;
  final CabinClass cabinClass;
  @override
  _FlightOptionsState createState() => _FlightOptionsState();
}

class _FlightOptionsState extends State<FlightOptions> {
  List<Flight> _flights;
  BuildContext loadingcontext;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _flights = widget.flightsResponse.flights;
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
            buildCategoryList(context, _flights),
          ],
        ),
      ),
    );
  }

  Widget buildCategoryList(BuildContext context, List<Flight> flights) {
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
        return buildCategoryItemCard(context, flights, index);
      },
    );
  }

  Widget buildCategoryItemCard(
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    '${flights[index].departureTime.substring(11, 16)}  -  ${flights[index].arrivalTime.substring(11, 16)}',
                    // textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: AppColors.dashboardColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '${flights[index].fromcode}  ->  ${flights[index].tocode}  ',
                    // textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '${flights[index].departureTime.substring(0, 11)}',
                    // textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 12,
                    ),
                  ),
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
                        _onSubmit(flights[index]);
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

  void _onSubmit(Flight flight) async {
    var data = {
      'aerocrs': {
        'parms': {
          'triptype': widget.tripType.code,
          'adults': widget.adults,
          'child': widget.children,
          'infant': widget.infants,
          "bookflight": [
            {
              "fromcode": flight.fromcode,
              "tocode": flight.tocode,
              "flightid": flight.flightid,
              "fareid": flight.fareid
            },
          ],
        },
      }
    };
    var postData = jsonEncode(data);
    loading('Please wait...');

    var bookingResponse = await AirlineRepository().createBooking(postData);
    Navigator.of(loadingcontext).pop();
    if (bookingResponse.success == false) {
      ToastComponent.showDialog('Could not create booking',
          gravity: Toast.center, duration: Toast.lengthLong);
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return PassengerDetails(
          flight: flight,
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
