import 'dart:convert';
import 'dart:io';

import 'package:hustla/custom/app_bar.dart';
import 'package:hustla/custom/box_decorations.dart';
import 'package:hustla/custom/device_info.dart';
import 'package:hustla/custom/input_decorations.dart';
import 'package:hustla/custom/page_description.dart';
import 'package:hustla/custom/process_completed.dart';
import 'package:hustla/custom/resources.dart';
import 'package:hustla/custom/useful_elements.dart';
import 'package:hustla/helpers/shimmer_helper.dart';
import 'package:hustla/presenter/bottom_appbar_index.dart';
import 'package:hustla/repositories/add_shop_repository.dart';
import 'package:hustla/repositories/auth_repository.dart';
import 'package:hustla/repositories/job_repository.dart';
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

class PostJob extends StatefulWidget {
  PostJob({Key key, this.sector}) : super(key: key);

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
            child: buildAppBar(context, widget.sector),
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
                    color: AppColors.appBarColor,
                    fontWeight: FontWeight.w300,
                    fontSize: 16,
                  ),
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
                    color: AppColors.appBarColor,
                    fontWeight: FontWeight.w300,
                    fontSize: 16,
                  ),
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
                    color: AppColors.appBarColor,
                    fontWeight: FontWeight.w300,
                    fontSize: 16,
                  ),
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
                  'Salary',
                  style: TextStyle(
                    color: AppColors.appBarColor,
                    fontWeight: FontWeight.w300,
                    fontSize: 16,
                  ),
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
                    color: AppColors.appBarColor,
                    fontWeight: FontWeight.w300,
                    fontSize: 16,
                  ),
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
                    color: AppColors.appBarColor,
                    fontWeight: FontWeight.w300,
                    fontSize: 16,
                  ),
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
                    color: AppColors.appBarColor,
                    fontWeight: FontWeight.w300,
                    fontSize: 16,
                  ),
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
            buildDescription(widget.sector,
                description:
                    'Please fill in the following details in the form below to post a job in the ${widget.sector} sector.'),
            creditForm(),
          ],
        ),
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
    var status = 'Open';
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
      "status": status,
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
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return ProcessCompleted(
          description: 'Congratulations, your job was posted successfully!',
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
