import 'package:active_ecommerce_flutter/custom/box_decorations.dart';
import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/custom/input_decorations.dart';
import 'package:active_ecommerce_flutter/custom/useful_elements.dart';
import 'package:active_ecommerce_flutter/data_model/sacco_list_response.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_flutter/presenter/bottom_appbar_index.dart';
import 'package:active_ecommerce_flutter/repositories/add_shop_repository.dart';
import 'package:active_ecommerce_flutter/repositories/auth_repository.dart';
import 'package:active_ecommerce_flutter/repositories/sacco_repository.dart';
import 'package:active_ecommerce_flutter/screens/filter.dart';
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

class JoinSacco extends StatefulWidget {
  JoinSacco(
      {Key key,
      this.parent_category_id = 0,
      this.parent_category_name = "",
      this.is_base_category = false,
      this.is_top_category = false,
      this.bottomAppbarIndex})
      : super(key: key);

  final int parent_category_id;
  final String parent_category_name;
  final bool is_base_category;
  final bool is_top_category;
  final BottomAppbarIndex bottomAppbarIndex;

  @override
  _JoinSaccoState createState() => _JoinSaccoState();
}

class _JoinSaccoState extends State<JoinSacco> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  BuildContext loadingcontext;
  List<Sacco> _saccoList = [];
  Sacco _selectedSacco;
  List<DropdownMenuItem<Sacco>> _dropdownSaccoListItems;

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

  Widget buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.symmetric(
                              vertical: BorderSide(
                                  color: MyTheme.accent_color, width: .5),
                              horizontal: BorderSide(
                                  color: MyTheme.accent_color, width: 1))),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: FittedBox(
                        child: new DropdownButton<Sacco>(
                          icon: Padding(
                            padding: app_language_rtl.$
                                ? const EdgeInsets.only(right: 18.0)
                                : const EdgeInsets.only(left: 18.0),
                            child:
                                Icon(Icons.expand_more, color: Colors.black54),
                          ),
                          hint: Text(
                            'Select Sacco',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                            ),
                          ),
                          style: TextStyle(color: Colors.black, fontSize: 13),
                          iconSize: 13,
                          underline: SizedBox(),
                          value: _selectedSacco,
                          items: _dropdownSaccoListItems,
                          onChanged: (Sacco selectedSacco) {
                            setState(() {
                              _selectedSacco = selectedSacco;
                            });
                          },
                        ),
                      ),
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
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Main();
      }));
    }
  }

  List<DropdownMenuItem<Sacco>> buildDropdownSaccoListItems(List saccoList) {
    List<DropdownMenuItem<Sacco>> items = List();
    for (Sacco saccoItem in saccoList) {
      items.add(
        DropdownMenuItem(
          value: saccoItem,
          child: Text(saccoItem.name),
        ),
      );
    }
    return items;
  }

  setDropDownValues() {
    setState(() {
      _dropdownSaccoListItems = buildDropdownSaccoListItems(_saccoList);
      _selectedSacco = _dropdownSaccoListItems[0].value;
    });
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
    String name = 'Join Sacco';

    return name;
  }

  getSaccos() async {
    var res = await SaccoRepository().getSaccoList();
    _saccoList.addAll(res.members);
    setDropDownValues();
  }
}
