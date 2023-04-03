import 'package:active_ecommerce_flutter/custom/app_bar.dart';
import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/custom/useful_elements.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebPage extends StatefulWidget {
  final String url;
  final bool is_base_category;

  WebPage({this.url, this.is_base_category = false});

  @override
  State<WebPage> createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  final _webKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            child: buildAppBar(context, 'Sponsored Advert'),
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
    return Column(
      key: _webKey,
      children: [
        Expanded(
          child: WebView(
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: widget.url,
            onPageStarted: (value) {
              // setState(() {
              //   ProgressHUD.of(_webKey.currentContext)
              //       .showWithText('Loading...');
              // });
            },
            onPageFinished: (value) {
              // setState(() {
              //   ProgressHUD.of(_webKey.currentContext).dismiss();
              // });
            },
          ),
        ),
      ],
    );
  }
}
