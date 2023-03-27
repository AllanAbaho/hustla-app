import 'dart:convert';
import 'dart:io';

import 'package:active_ecommerce_flutter/custom/box_decorations.dart';
import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/custom/input_decorations.dart';
import 'package:active_ecommerce_flutter/custom/resources.dart';
import 'package:active_ecommerce_flutter/custom/useful_elements.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_flutter/presenter/bottom_appbar_index.dart';
import 'package:active_ecommerce_flutter/repositories/add_shop_repository.dart';
import 'package:active_ecommerce_flutter/repositories/auth_repository.dart';
import 'package:active_ecommerce_flutter/repositories/job_repository.dart';
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

class PostJob extends StatefulWidget {
  PostJob(
      {Key key,
      this.parent_category_id = 0,
      this.parent_category_name = "",
      this.is_base_category = false,
      this.is_top_category = false,
      this.bottomAppbarIndex,
      this.sector})
      : super(key: key);

  final int parent_category_id;
  final String parent_category_name;
  final bool is_base_category;
  final bool is_top_category;
  final BottomAppbarIndex bottomAppbarIndex;
  final String sector;

  @override
  _PostJobState createState() => _PostJobState();
}

class _PostJobState extends State<PostJob> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _roleController = TextEditingController();
  TextEditingController _salaryController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _deadlineController = TextEditingController();
  TextEditingController _durationController = TextEditingController();
  TextEditingController _typeController = TextEditingController();
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
            child: buildAppBar(context),
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
                  'Role',
                  style: TextStyle(
                      color: MyTheme.accent_color, fontWeight: FontWeight.w600),
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
                        keyboardType: TextInputType.text,
                        controller: _roleController,
                        autofocus: false,
                        decoration: InputDecorations.buildInputDecoration_1(
                            hint_text: "Software developer"),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  'Location',
                  style: TextStyle(
                      color: MyTheme.accent_color, fontWeight: FontWeight.w600),
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
                        keyboardType: TextInputType.text,
                        controller: _locationController,
                        autofocus: false,
                        decoration: InputDecorations.buildInputDecoration_1(
                            hint_text: "Kampala, Uganda"),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  'Deadline',
                  style: TextStyle(
                      color: MyTheme.accent_color, fontWeight: FontWeight.w600),
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
                        keyboardType: TextInputType.text,
                        controller: _deadlineController,
                        autofocus: false,
                        decoration: InputDecorations.buildInputDecoration_1(
                            hint_text: "24th May 2023"),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  'salary',
                  style: TextStyle(
                      color: MyTheme.accent_color, fontWeight: FontWeight.w600),
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
                        keyboardType: TextInputType.text,
                        controller: _salaryController,
                        autofocus: false,
                        decoration: InputDecorations.buildInputDecoration_1(
                            hint_text: "1,000"),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  'Duration',
                  style: TextStyle(
                      color: MyTheme.accent_color, fontWeight: FontWeight.w600),
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
                        keyboardType: TextInputType.text,
                        controller: _durationController,
                        autofocus: false,
                        decoration: InputDecorations.buildInputDecoration_1(
                            hint_text: "4 weeks"),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  'Type',
                  style: TextStyle(
                      color: MyTheme.accent_color, fontWeight: FontWeight.w600),
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
                        keyboardType: TextInputType.text,
                        controller: _typeController,
                        autofocus: false,
                        decoration: InputDecorations.buildInputDecoration_1(
                            hint_text: "Part Time"),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  'Description',
                  style: TextStyle(
                      color: MyTheme.accent_color, fontWeight: FontWeight.w600),
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
                        keyboardType: TextInputType.text,
                        controller: _descriptionController,
                        autofocus: false,
                        decoration: InputDecorations.buildInputDecoration_1(
                            hint_text:
                                "Due to the expansion plans of the business, the role offers fantastic growth and progression for the candidate and you will be joining a team of 5 developers who carry a wealth of knowledge and experience."),
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
        child: creditForm(),
      ),
    );
  }

  onSubmit() async {
    var salary = _salaryController.text.toString();
    var role = _roleController.text.toString();
    var location = _locationController.text.toString();
    var deadline = _deadlineController.text.toString();
    var description = _descriptionController.text.toString();
    var duration = _durationController.text.toString();
    var type = _typeController.text.toString();
    if (role == "") {
      ToastComponent.showDialog('Please enter the job title',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else if (location == "") {
      ToastComponent.showDialog('Please enter the job location',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else if (deadline == "") {
      ToastComponent.showDialog('Please enter the application deadline',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else if (salary == "") {
      ToastComponent.showDialog('Please enter the job salary',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else if (duration == "") {
      ToastComponent.showDialog('Please enter the job duration',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else if (type == "") {
      ToastComponent.showDialog('Please enter the job type',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else if (description == "") {
      ToastComponent.showDialog('Please enter the job description',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    Map postData = {
      "name": role,
      "price": salary,
      "duration": duration,
      "location": location,
      "deadline": deadline,
      "type": type,
      "description": description,
      "category": widget.sector,
      "created_by": user_id.$
    };
    var data = jsonEncode(postData);
    loading();
    var addJobResponse = await JobRepository().addJob(
      data,
    );

    Navigator.of(loadingcontext).pop();

    if (addJobResponse.status != true) {
      ToastComponent.showDialog(addJobResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);
    } else {
      ToastComponent.showDialog(addJobResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Main();
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

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: MyTheme.accent_color,
      //centerTitle: true,
      leading: widget.is_base_category
          ? Builder(
              builder: (context) => Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                child: UsefulElements.backToMain(context,
                    go_back: false, color: "white"),
              ),
            )
          : Builder(
              builder: (context) => IconButton(
                icon: Icon(CupertinoIcons.arrow_left, color: MyTheme.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
      title: Text(
        getAppBarTitle(),
        style: TextStyle(
            fontSize: 16, color: MyTheme.white, fontWeight: FontWeight.bold),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  String getAppBarTitle() {
    String name = 'Post Job: ${widget.sector}';

    return name;
  }
}
