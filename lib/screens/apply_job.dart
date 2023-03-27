import 'dart:convert';
import 'dart:io';

import 'package:active_ecommerce_flutter/custom/box_decorations.dart';
import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/custom/input_decorations.dart';
import 'package:active_ecommerce_flutter/custom/resources.dart';
import 'package:active_ecommerce_flutter/custom/useful_elements.dart';
import 'package:active_ecommerce_flutter/data_model/job_response.dart';
import 'package:active_ecommerce_flutter/helpers/file_helper.dart';
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
import 'package:file_picker/file_picker.dart';

class ApplyJob extends StatefulWidget {
  ApplyJob(
      {Key key,
      this.parent_category_id = 0,
      this.parent_category_name = "",
      this.is_base_category = false,
      this.is_top_category = false,
      this.job,
      this.bottomAppbarIndex})
      : super(key: key);

  final int parent_category_id;
  final String parent_category_name;
  final Job job;
  final bool is_base_category;
  final bool is_top_category;
  final BottomAppbarIndex bottomAppbarIndex;

  @override
  _ApplyJobState createState() => _ApplyJobState();
}

class _ApplyJobState extends State<ApplyJob> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _nameController =
      TextEditingController(text: user_name.$);
  TextEditingController _emailController =
      TextEditingController(text: user_email.$);
  TextEditingController _phoneController =
      TextEditingController(text: user_phone.$);
  TextEditingController _resumeController = TextEditingController();
  BuildContext loadingcontext;
  FilePickerResult result;
  File _file;

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
                  'Full Name',
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
                        readOnly: true,
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
                  'Email Address',
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
                        readOnly: true,
                        keyboardType: TextInputType.text,
                        controller: _emailController,
                        autofocus: false,
                        decoration: InputDecorations.buildInputDecoration_1(
                            hint_text: "allan.abaho@gmail.com"),
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
                        readOnly: true,
                        keyboardType: TextInputType.text,
                        controller: _phoneController,
                        autofocus: false,
                        decoration: InputDecorations.buildInputDecoration_1(
                            hint_text: "0700460044"),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  'Upload Resume',
                  style: TextStyle(
                      color: MyTheme.accent_color, fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: TextField(
                            readOnly: true,
                            keyboardType: TextInputType.text,
                            controller: _resumeController,
                            autofocus: false,
                            decoration: InputDecorations.buildInputDecoration_1(
                                hint_text: "No file selected"),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: FlatButton(
                            color: MyTheme.dark_font_grey,
                            shape: RoundedRectangleBorder(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(6.0))),
                            child: Text(
                              'Upload',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                            onPressed: () async {
                              result = await FilePicker.platform.pickFiles(
                                type: FileType.custom,
                                allowedExtensions: ['pdf'],
                              );
                              if (result != null) {
                                setState(() {
                                  _resumeController.text =
                                      result.files.single.name;
                                  _file = File(result.files.single.path);
                                });
                              } else {
                                print("No file selected");
                              }
                            }),
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
    var resume = _resumeController.text.toString();
    if (resume == "") {
      ToastComponent.showDialog('Please upload your resume',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }
    String base64File = FileHelper.getBase64FormateFile(_file.path);

    Map postData = {
      "job_id": widget.job.id,
      "applicant_id": user_id.$,
      "status": 'Review',
      "portfolio": resume,
      "created_by": user_id.$,
      "file": base64File
    };
    var data = jsonEncode(postData);
    loading();
    var postJobApplicationResponse = await JobRepository().postJobApplication(
      data,
    );

    Navigator.of(loadingcontext).pop();

    if (postJobApplicationResponse.status != true) {
      ToastComponent.showDialog(postJobApplicationResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);
    } else {
      ToastComponent.showDialog(postJobApplicationResponse.message,
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
    String name = widget.job.name;

    return name;
  }
}
