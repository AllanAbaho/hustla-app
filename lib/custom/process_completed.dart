import 'dart:convert';

import 'package:hustla/custom/app_bar.dart';
import 'package:hustla/custom/device_info.dart';
import 'package:hustla/custom/input_decorations.dart';
import 'package:hustla/custom/page_description.dart';
import 'package:hustla/custom/resources.dart';
import 'package:hustla/custom/toast_component.dart';
import 'package:hustla/helpers/shared_value_helper.dart';
import 'package:hustla/my_theme.dart';
import 'package:hustla/repositories/top_up_repository.dart';
import 'package:hustla/screens/main.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:toast/toast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProcessCompleted extends StatefulWidget {
  ProcessCompleted({Key key, this.description}) : super(key: key);

  final String description;

  @override
  _ProcessCompletedState createState() => _ProcessCompletedState();
}

class _ProcessCompletedState extends State<ProcessCompleted> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            child: buildAppBar(context, 'Process Completed'),
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
            buildDescription('Process Completed',
                description: widget.description),
            Center(
              child: LottieBuilder.asset('assets/images/success.json'),
            ),
            FlatButton(
                minWidth: MediaQuery.of(context).size.width,
                disabledColor: MyTheme.grey_153,
                height: 50,
                color: MyTheme.accent_color,
                shape: RoundedRectangleBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(6.0))),
                child: Text(
                  'OK',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Main(go_back: false);
                  }));
                }),
          ],
        ),
      ),
    );
  }
}
