import 'dart:math';

import 'package:active_ecommerce_flutter/helpers/auth_helper.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/repositories/payment_repository.dart';
import 'package:active_ecommerce_flutter/screens/main.dart';
import 'package:active_ecommerce_flutter/screens/order_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:active_ecommerce_flutter/custom/input_decorations.dart';
import 'package:active_ecommerce_flutter/screens/login.dart';
import 'package:active_ecommerce_flutter/repositories/auth_repository.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:toast/toast.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterOTP extends StatefulWidget {
  RegisterOTP(
      {Key key,
      this.verify_by = "email",
      this.user_id,
      this.verification_code,
      this.selected_payment_method_key,
      this.phone})
      : super(key: key);
  final String verify_by, phone, verification_code;
  final int user_id;
  final String selected_payment_method_key;

  @override
  _RegisterOTPState createState() => _RegisterOTPState();
}

class _RegisterOTPState extends State<RegisterOTP> {
  //controllers
  TextEditingController _verificationCodeController = TextEditingController();
  @override
  void initState() {
    sendSMS();
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

  onTapResend() async {
    var resendCodeResponse = await AuthRepository()
        .getResendCodeResponse(widget.user_id, widget.verify_by);

    if (resendCodeResponse.result == false) {
      ToastComponent.showDialog(resendCodeResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);
    } else {
      ToastComponent.showDialog(resendCodeResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);
    }
  }

  sendSMS() async {
    print(widget.phone);
    print(widget.verification_code);
    var smsResponse = await AuthRepository()
        .authorizeOTPResponse(widget.verification_code, widget.phone);
    if (smsResponse.status == 'SUCCESS') {
      ToastComponent.showDialog('Please enter OTP',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else {
      ToastComponent.showDialog('OTP not sent please click resend',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }
  }

  onPressConfirm() async {
    var code = _verificationCodeController.text.toString();

    if (code == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context).otp_screen_verification_code_warning,
          gravity: Toast.center,
          duration: Toast.lengthLong);
      return;
    }

    var confirmCodeResponse =
        await AuthRepository().getConfirmCodeResponse(widget.user_id, code);

    if (confirmCodeResponse.result == false) {
      ToastComponent.showDialog(confirmCodeResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);
    } else {
      ToastComponent.showDialog(confirmCodeResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Login();
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    String VerifyBy = widget.verify_by; //phone or email
    final ScreenHeight = MediaQuery.of(context).size.height;
    final ScreenWidth = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Container(
              width: ScreenWidth * (3 / 4),
              child: Image.asset(
                  "assets/splash_login_registration_background_image.png"),
            ),
            Container(
              width: double.infinity,
              child: SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0, bottom: 15),
                    child: Container(
                      width: 75,
                      height: 75,
                      child: Image.asset('assets/app_icon.png'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Text(
                      'Verify your phone number',
                      style: TextStyle(
                          color: MyTheme.accent_color,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Container(
                        width: ScreenWidth * (3 / 4),
                        child: Text(
                            AppLocalizations.of(context)
                                .otp_screen_enter_verification_code_to_phone,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: MyTheme.dark_grey, fontSize: 14))),
                  ),
                  Container(
                    width: ScreenWidth * (3 / 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                height: 50,
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  controller: _verificationCodeController,
                                  autofocus: false,
                                  decoration:
                                      InputDecorations.buildInputDecoration_1(
                                          hint_text: "1 2 3 4 5 6"),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 40.0),
                          child: Container(
                            height: 45,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: MyTheme.textfield_grey, width: 1),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(12.0))),
                            child: FlatButton(
                              minWidth: MediaQuery.of(context).size.width,
                              //height: 50,
                              color: MyTheme.accent_color,
                              shape: RoundedRectangleBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12.0))),
                              child: Text(
                                AppLocalizations.of(context).otp_screen_confirm,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                              onPressed: () {
                                onPressConfirm();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 100),
                  //   child: InkWell(
                  //     onTap: () {
                  //       onTapResend();
                  //     },
                  //     child: Text(
                  //         AppLocalizations.of(context).otp_screen_resend_code,
                  //         textAlign: TextAlign.center,
                  //         style: TextStyle(
                  //             color: MyTheme.accent_color,
                  //             decoration: TextDecoration.underline,
                  //             fontSize: 13)),
                  //   ),
                  // ),
                ],
              )),
            )
          ],
        ),
      ),
    );
  }
}
