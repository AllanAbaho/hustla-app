import 'dart:convert';
import 'dart:io';

import 'package:hustla/app_config.dart';
import 'package:hustla/custom/device_info.dart';
import 'package:hustla/custom/image_box.dart';
import 'package:hustla/custom/resources.dart';
import 'package:hustla/custom/useful_elements.dart';
import 'package:hustla/helpers/file_helper.dart';
import 'package:hustla/my_theme.dart';
import 'package:hustla/repositories/profile_repository.dart';
import 'package:hustla/screens/common_webview_screen.dart';
import 'package:hustla/screens/register_otp.dart';
import 'package:hustla/ui_elements/auth_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hustla/custom/input_decorations.dart';
import 'package:hustla/custom/intl_phone_input.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:hustla/screens/otp.dart';
import 'package:hustla/screens/login.dart';
import 'package:hustla/custom/toast_component.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toast/toast.dart';
import 'package:hustla/repositories/auth_repository.dart';
import 'package:hustla/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:validators/validators.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  String _register_by = "email"; //phone or email
  PhoneNumber phoneCode = PhoneNumber(isoCode: 'KE', dialCode: "+254");

  String _phone = "";
  bool _isAgree = false;
  String _gender = 'M';
  File imgFileFront, imgFileBack;
  DateTime selectedDate = DateTime.now();
  BuildContext loadingcontext;

  //controllers
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _birthDateController = TextEditingController();
  TextEditingController _ninController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordConfirmController = TextEditingController();

  @override
  void initState() {
    //on Splash Screen hide statusbar
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    super.initState();
  }

  @override
  void dispose() {
    //before going to other screen show statusbar
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }

  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime picked = await showDatePicker(
  //       context: context,
  //       initialDate: selectedDate,
  //       firstDate: DateTime(2015, 8),
  //       lastDate: DateTime(2101));
  //   if (picked != null && picked != selectedDate) {
  //     String formattedDate = DateFormat('yyyy-MM-dd').format(picked);

  //     setState(() {
  //       _birthDateController.text = formattedDate;
  //     });
  //   }
  // }

  onPressSignUp() async {
    var nin = _ninController.text.toString();
    var uname = _usernameController.text.toString();
    var email = _emailController.text.toString();
    var fname = _firstNameController.text.toString();
    var lname = _lastNameController.text.toString();
    // var gender = _gender;
    // var dob = _birthDateController.text.toString();
    var password = _passwordController.text.toString();
    var password_confirm = _passwordConfirmController.text.toString();
    var phone = _phone;

    if (fname == "") {
      ToastComponent.showDialog('Please enter your first name',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else if (lname == "") {
      ToastComponent.showDialog('Please enter your last name',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else if (email == "" || !isEmail(email)) {
      ToastComponent.showDialog('Please enter your email address',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else if (_phone.length < 13) {
      ToastComponent.showDialog('Please make sure phone number is correct',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
      // } else if (dob == "") {
      //   ToastComponent.showDialog('Please enter your date of birth',
      //       gravity: Toast.center, duration: Toast.lengthLong);
      //   return;
    } else if (nin == "") {
      ToastComponent.showDialog('Please enter your ID number',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else if (imgFileFront == null) {
      ToastComponent.showDialog('Please upload a front picture',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else if (imgFileBack == null) {
      ToastComponent.showDialog('Please upload a back picture',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else if (uname == "") {
      ToastComponent.showDialog('Please enter your username',
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
    final List<int> imageBytesFront = imgFileFront.readAsBytesSync();
    var frontImage = base64Encode(imageBytesFront);
    final List<int> imageBytesBack = imgFileBack.readAsBytesSync();
    var backImage = base64Encode(imageBytesBack);
    // print(backImage);
    // return;
    loading();
    var signupResponse = await AuthRepository().getSignupResponse(
      uname,
      fname,
      lname,
      // dob,
      // gender,
      nin,
      phone,
      frontImage,
      backImage,
      email,
      password,
    );
    Navigator.of(loadingcontext).pop();

    if (signupResponse.result == false) {
      ToastComponent.showDialog(signupResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);
    } else {
      ToastComponent.showDialog(signupResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return RegisterOTP(
            verification_code: signupResponse.verification_code,
            user_id: signupResponse.user_id,
            phone: phone);
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

  @override
  Widget build(BuildContext context) {
    final _screen_height = MediaQuery.of(context).size.height;
    final _screen_width = MediaQuery.of(context).size.width;
    return AuthScreen.buildScreen(
        context,
        "${AppLocalizations.of(context).registration_screen_join} " +
            AppConfig.app_name,
        buildBody(context, _screen_width));
  }

  Widget buildImageSection(BuildContext context, String imageType) {
    return ImageBox(
      img: imageType == 'Back' ? imgFileBack : imgFileFront,
    ).onTap(() {
      showDialog(
        context: context,
        builder: (context) {
          final AlertDialog dialog = AlertDialog(
            content: Text('Choose'),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Expanded(
                      child: SizedBox(
                        height: 54,
                        child: ElevatedButton(
                          onPressed: () async {
                            final ImagePicker picker = ImagePicker();
                            final XFile image = await picker.pickImage(
                              source: ImageSource.gallery,
                              imageQuality: 25,
                            );
                            setState(() {
                              if (imageType == 'Back')
                                imgFileBack = File(image.path);
                              else if (imageType == 'Front')
                                imgFileFront = File(image.path);
                              Navigator.pop(context);
                            });
                          },
                          child: Text(
                            'Gallery',
                            // color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // HSpace.md,
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Expanded(
                      child: SizedBox(
                        height: 54,
                        child: ElevatedButton(
                          onPressed: () async {
                            final ImagePicker picker = ImagePicker();
                            final XFile image = await picker.pickImage(
                              source: ImageSource.camera,
                              imageQuality: 25,
                            );
                            setState(() {
                              if (imageType == 'Back')
                                imgFileBack = File(image.path);
                              else if (imageType == 'Front')
                                imgFileFront = File(image.path);
                              Navigator.pop(context);
                            });
                          },
                          child: Text(
                            'Camera',
                            // color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
          return dialog;
        },
      );
    });
  }

  Column buildBody(BuildContext context, double _screen_width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: _screen_width * (3 / 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  'First Name',
                  style: TextStyle(
                      color: AppColors.appBarColor,
                      fontWeight: FontWeight.w300,
                      fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      height: 36,
                      child: TextField(
                        controller: _firstNameController,
                        autofocus: false,
                        decoration: InputDecorations.buildInputDecoration_1(
                            hint_text: "mwangi"),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  'Last Name',
                  style: TextStyle(
                      color: AppColors.appBarColor,
                      fontWeight: FontWeight.w300,
                      fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      height: 36,
                      child: TextField(
                        controller: _lastNameController,
                        autofocus: false,
                        decoration: InputDecorations.buildInputDecoration_1(
                            hint_text: "kamau"),
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
                      color: AppColors.appBarColor,
                      fontWeight: FontWeight.w300,
                      fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      height: 36,
                      child: TextField(
                        controller: _emailController,
                        autofocus: false,
                        decoration: InputDecorations.buildInputDecoration_1(
                            hint_text: "mwangi@gmail.com"),
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
                      color: AppColors.appBarColor,
                      fontWeight: FontWeight.w300,
                      fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      height: 48,
                      child: CustomInternationalPhoneNumberInput(
                        onInputChanged: (PhoneNumber number) {
                          setState(() {
                            _phone = number.phoneNumber;
                          });
                        },
                        onInputValidated: (bool value) {
                          print(value);
                        },
                        // selectorConfig: SelectorConfig(
                        //   selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                        // ),
                        ignoreBlank: false,
                        autoValidateMode: AutovalidateMode.disabled,
                        selectorTextStyle: TextStyle(
                          color: MyTheme.font_grey,
                        ),
                        initialValue: phoneCode,
                        textFieldController: _phoneNumberController,
                        formatInput: true,
                        keyboardType: TextInputType.numberWithOptions(
                            signed: true, decimal: true),
                        inputDecoration:
                            InputDecorations.buildInputDecoration_phone(
                                hint_text: "700 000 000"),
                        onSaved: (PhoneNumber number) {
                          //print('On Saved: $number');
                        },
                        // isEnabled: false,
                      ),
                    ),
                  ],
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(bottom: 4.0),
              //   child: Text(
              //     'Date Of Birth',
              //     style: TextStyle(
              //         color: AppColors.appBarColor, fontWeight: FontWeight.w300,fontSize: 16),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(bottom: 25),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.end,
              //     children: [
              //       Container(
              //         height: 36,
              //         child: TextField(
              //           controller: _birthDateController,
              //           autofocus: false,
              //           decoration: InputDecorations.buildInputDecoration_1(
              //               hint_text: "1999-09-09"),
              //           onTap: () => _selectDate(context),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(bottom: 4.0),
              //   child: Text(
              //     'Gender',
              //     style: TextStyle(
              //         color: AppColors.appBarColor, fontWeight: FontWeight.w300,fontSize: 16),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(bottom: 25),
              //   child: Container(
              //       height: 36,
              //       child: Row(
              //         children: <Widget>[
              //           Radio(
              //             value: 'M',
              //             groupValue: _gender,
              //             onChanged: (value) {
              //               setState(() {
              //                 _gender = value;
              //               });
              //             },
              //           ),
              //           Text('Male'),
              //           Radio(
              //             value: 'F',
              //             groupValue: _gender,
              //             onChanged: (value) {
              //               setState(() {
              //                 _gender = value;
              //               });
              //             },
              //           ),
              //           Text('Female'),
              //         ],
              //       )),
              // ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  'National ID Number',
                  style: TextStyle(
                      color: AppColors.appBarColor,
                      fontWeight: FontWeight.w300,
                      fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: Container(
                  height: 36,
                  child: TextField(
                    controller: _ninController,
                    autofocus: false,
                    decoration: InputDecorations.buildInputDecoration_1(
                        hint_text: "CM94562312AWEYRI"),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            'ID Front Picture',
                            style: TextStyle(
                                color: AppColors.appBarColor,
                                fontWeight: FontWeight.w300,
                                fontSize: 16),
                          ),
                        ),
                        buildImageSection(context, 'Front'),
                      ],
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            'ID Back Picture',
                            style: TextStyle(
                                color: AppColors.appBarColor,
                                fontWeight: FontWeight.w300,
                                fontSize: 16),
                          ),
                        ),
                        buildImageSection(context, 'Back'),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  'Username',
                  style: TextStyle(
                      color: AppColors.appBarColor,
                      fontWeight: FontWeight.w300,
                      fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: Container(
                  height: 36,
                  child: TextField(
                    controller: _usernameController,
                    autofocus: false,
                    decoration: InputDecorations.buildInputDecoration_1(
                        hint_text: "nganga"),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  'Password',
                  style: TextStyle(
                      color: AppColors.appBarColor,
                      fontWeight: FontWeight.w300,
                      fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 25),
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
                            hint_text: "• • • • • • • •"),
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
                      color: AppColors.appBarColor,
                      fontWeight: FontWeight.w300,
                      fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 25),
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
                        hint_text: "• • • • • • • •"),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 15,
                      width: 15,
                      child: Checkbox(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                          value: _isAgree,
                          onChanged: (newValue) {
                            _isAgree = newValue;
                            setState(() {});
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Container(
                        width: DeviceInfo(context).width - 130,
                        child: RichText(
                            maxLines: 2,
                            text: TextSpan(
                                style: TextStyle(
                                    color: MyTheme.font_grey, fontSize: 12),
                                children: [
                                  TextSpan(
                                    text: "I agree to the",
                                  ),
                                  TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CommonWebviewScreen(
                                                      page_name:
                                                          "Terms Conditions",
                                                      url:
                                                          "${AppConfig.RAW_BASE_URL}/mobile-page/terms",
                                                    )));
                                      },
                                    style:
                                        TextStyle(color: MyTheme.accent_color),
                                    text: " Terms Conditions",
                                  ),
                                  TextSpan(
                                    text: " &",
                                  ),
                                  TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CommonWebviewScreen(
                                                      page_name:
                                                          "Privacy Policy",
                                                      url:
                                                          "${AppConfig.RAW_BASE_URL}/mobile-page/privacy-policy",
                                                    )));
                                      },
                                    text: " Privacy Policy",
                                    style:
                                        TextStyle(color: MyTheme.accent_color),
                                  )
                                ])),
                      ),
                    )
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
                      AppLocalizations.of(context)
                          .registration_screen_register_sign_up,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                          fontSize: 16),
                    ),
                    onPressed: _isAgree
                        ? () {
                            onPressSignUp();
                          }
                        : null,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                        child: Text(
                      AppLocalizations.of(context)
                          .registration_screen_already_have_account,
                      style: TextStyle(color: MyTheme.font_grey, fontSize: 12),
                    )),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      child: Text(
                        AppLocalizations.of(context).registration_screen_log_in,
                        style: TextStyle(
                            color: MyTheme.accent_color,
                            fontWeight: FontWeight.w300,
                            fontSize: 16),
                      ),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Login();
                        }));
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
