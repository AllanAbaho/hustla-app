import 'package:hustla/custom/app_bar.dart';
import 'package:hustla/custom/device_info.dart';
import 'package:hustla/custom/page_description.dart';
import 'package:hustla/custom/process_completed.dart';
import 'package:hustla/custom/resources.dart';
import 'package:hustla/custom/useful_elements.dart';
import 'package:hustla/data_model/destination_response.dart';
import 'package:hustla/data_model/sacco_list_response.dart';
import 'package:hustla/presenter/bottom_appbar_index.dart';
import 'package:hustla/repositories/sacco_repository.dart';
import 'package:hustla/screens/main.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hustla/my_theme.dart';
import 'package:hustla/custom/toast_component.dart';
import 'package:toast/toast.dart';
import 'package:hustla/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class JoinSacco extends StatefulWidget {
  JoinSacco({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _JoinSaccoState createState() => _JoinSaccoState();
}

class _JoinSaccoState extends State<JoinSacco> {
  BuildContext loadingcontext;
  List<Sacco> _saccoList = [];
  Sacco _selectedSacco;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSaccos();
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
          child: _saccoList.isEmpty
              ? Center(
                  child: CircularProgressIndicator(
                  color: MyTheme.accent_color,
                ))
              : buildBody(),
        ));
  }

  Widget buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildDescription(widget.title,
                description: 'Please select the sacco you want to join'),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      'Select Sacco',
                      style: TextStyle(
                          color: AppColors.appBarColor,
                          fontWeight: FontWeight.w300,
                          fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 25.0),
                    child: DropdownSearch<Sacco>(
                      items: _saccoList,
                      itemAsString: (item) {
                        return item.name;
                      },
                      onChanged: (item) {
                        setState(() {
                          _selectedSacco = item;
                        });
                      },
                      selectedItem: _saccoList[0],
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
        ),
      ),
    );
  }

  onSubmit() async {
    var name = _selectedSacco.name;
    loading();
    var joinSaccoResponse = await SaccoRepository().joinSacco(name);
    Navigator.of(loadingcontext).pop();

    if (joinSaccoResponse.status != 'SUCCESS') {
      ToastComponent.showDialog(joinSaccoResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);
    } else {
      ToastComponent.showDialog(joinSaccoResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return ProcessCompleted(
          description: 'Congratulations, you joined sacco successfully!',
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
              CircularProgressIndicator(
                color: MyTheme.accent_color,
              ),
              SizedBox(
                width: 10,
              ),
              Text("${AppLocalizations.of(context).loading_text}"),
            ],
          ));
        });
  }

  getSaccos() async {
    var res = await SaccoRepository().getSaccoList();
    setState(() {
      _saccoList = res.members;
    });
  }
}
