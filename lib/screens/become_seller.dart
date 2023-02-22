import 'package:active_ecommerce_flutter/custom/box_decorations.dart';
import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/custom/input_decorations.dart';
import 'package:active_ecommerce_flutter/custom/useful_elements.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_flutter/presenter/bottom_appbar_index.dart';
import 'package:active_ecommerce_flutter/repositories/add_shop_repository.dart';
import 'package:active_ecommerce_flutter/repositories/auth_repository.dart';
import 'package:active_ecommerce_flutter/screens/home.dart';
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

class BecomeSeller extends StatefulWidget {
  BecomeSeller(
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
  _BecomeSellerState createState() => _BecomeSellerState();
}

class _BecomeSellerState extends State<BecomeSeller> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordConfirmController = TextEditingController();
  BuildContext loadingcontext;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Stack(children: [
        Container(
          height: DeviceInfo(context).height / 9,
          width: DeviceInfo(context).width,
          color: MyTheme.accent_color,
          alignment: Alignment.topRight,
          child: Image.asset(
            "assets/background_1.png",
          ),
        ),
        Scaffold(
            backgroundColor: Colors.transparent,
            appBar: PreferredSize(
                child: buildAppBar(context),
                preferredSize: Size(
                  DeviceInfo(context).width,
                  80,
                )),
            body: buildBody()),
      ]),
    );
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
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      'Shop Name',
                      style: TextStyle(
                          color: MyTheme.accent_color,
                          fontWeight: FontWeight.w600),
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
                            controller: _nameController,
                            autofocus: false,
                            decoration: InputDecorations.buildInputDecoration_1(
                                hint_text: "Mwangi Collections"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      'Shop Email Address',
                      style: TextStyle(
                          color: MyTheme.accent_color,
                          fontWeight: FontWeight.w600),
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
                            controller: _emailController,
                            autofocus: false,
                            decoration: InputDecorations.buildInputDecoration_1(
                                hint_text: "mcollections@gmail.com"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      'Shop Address',
                      style: TextStyle(
                          color: MyTheme.accent_color,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Container(
                      height: 36,
                      child: TextField(
                        controller: _addressController,
                        autofocus: false,
                        decoration: InputDecorations.buildInputDecoration_1(
                            hint_text: "Mariba Building, Naivasha"),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      'Password',
                      style: TextStyle(
                          color: MyTheme.accent_color,
                          fontWeight: FontWeight.w600),
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
                            keyboardType: TextInputType.number,
                            controller: _passwordController,
                            autofocus: false,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            decoration: InputDecorations.buildInputDecoration_1(
                                hint_text: "• • • •"),
                          ),
                        ),
                        Text(
                          'Password must contain 4 digits',
                          style: TextStyle(
                              color: MyTheme.textfield_grey,
                              fontStyle: FontStyle.italic),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      AppLocalizations.of(context)
                          .registration_screen_retype_password,
                      style: TextStyle(
                          color: MyTheme.accent_color,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Container(
                      height: 36,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: _passwordConfirmController,
                        autofocus: false,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecorations.buildInputDecoration_1(
                            hint_text: "• • • •"),
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
    var name = _nameController.text.toString();
    var email = _emailController.text.toString();
    var address = _addressController.text.toString();
    var password = _passwordController.text.toString();
    var password_confirm = _passwordConfirmController.text.toString();

    if (name == "") {
      ToastComponent.showDialog('Please enter your shop name',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else if (email == "" || !isEmail(email)) {
      ToastComponent.showDialog('Please enter shop email address',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else if (address == "") {
      ToastComponent.showDialog('Please enter your shop address',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else if (password.length != 4) {
      ToastComponent.showDialog('Please enter a 4 digit password',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else if (password_confirm != password) {
      ToastComponent.showDialog('Passwords do not match',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }
    loading();
    var addShopResponse = await AddShopRepository().getAddShopResponse(
      name,
      email,
      address,
      password,
    );
    Navigator.of(loadingcontext).pop();

    if (addShopResponse.success == false) {
      ToastComponent.showDialog(addShopResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);
    } else {
      ToastComponent.showDialog(addShopResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Home();
      }));
      sendSMS();
    }
  }

  sendSMS() async {
    var message =
        'Shop has been added successfuly, Please visit hustlermarkets.com/login to add your products';
    await AuthRepository().authorizeOTPResponse(message, user_phone.$);
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
      backgroundColor: Colors.transparent,
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
    String name = 'Become Seller';

    return name;
  }
}
