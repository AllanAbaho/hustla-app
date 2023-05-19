import 'dart:convert';

import 'package:hustla/custom/box_decorations.dart';
import 'package:hustla/custom/device_info.dart';
import 'package:hustla/custom/spacers.dart';
import 'package:hustla/custom/useful_elements.dart';
import 'package:hustla/data_model/job_response.dart';
import 'package:hustla/helpers/shimmer_helper.dart';
import 'package:hustla/presenter/bottom_appbar_index.dart';
import 'package:hustla/repositories/job_repository.dart';
import 'package:hustla/screens/apply_job.dart';
import 'package:hustla/screens/job_description.dart';
import 'package:hustla/screens/job_sectors.dart';
import 'package:hustla/screens/post_job.dart';
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
import 'package:url_launcher/url_launcher.dart';

class JobApplicants extends StatefulWidget {
  JobApplicants(
      {Key key,
      this.parent_category_id = 0,
      this.parent_category_name = "",
      this.is_base_category = false,
      this.is_top_category = false,
      this.bottomAppbarIndex,
      this.banner,
      this.sector,
      this.jobApplications})
      : super(key: key);

  final int parent_category_id;
  final String parent_category_name;
  final bool is_base_category;
  final bool is_top_category;
  final BottomAppbarIndex bottomAppbarIndex;
  final String banner;
  final String sector;
  final List<JobApplication> jobApplications;

  @override
  _JobApplicantsState createState() => _JobApplicantsState();
}

class _JobApplicantsState extends State<JobApplicants> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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

  Widget buildBody() {
    return CustomScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverList(
            delegate: SliverChildListDelegate([
          buildCategoryList(),
          Container(
            height: widget.is_base_category ? 60 : 90,
          )
        ]))
      ],
    );
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
    String name = '${widget.sector} Applications';

    return name;
  }

  buildCategoryList() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 3,
        crossAxisCount: 1,
      ),
      itemCount: widget.jobApplications.length,
      padding: EdgeInsets.only(left: 18, right: 18, bottom: 30),
      scrollDirection: Axis.vertical,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return buildCategoryItemCard(widget.jobApplications, index);
      },
    );
  }

  Widget buildCategoryItemCard(applications, index) {
    var itemWidth = ((DeviceInfo(context).width - 36));

    return Container(
      decoration: BoxDecorations.buildBoxDecoration_1(),
      child: Container(
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(6),
                        topLeft: Radius.circular(6)),
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/placeholder.png',
                      image: widget.banner,
                      width: itemWidth * 0.2,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    applications[index].user.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: MyTheme.font_grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    applications[index].user.email,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: MyTheme.font_grey,
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    applications[index].user.phone,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: MyTheme.font_grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w300),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          launch(
                            'mailto:${applications[index].user.email}?subject=Job Interview&body=Hello ${applications[index].user.name},',
                          );
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.email,
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ),
                      HSpace.md,
                      GestureDetector(
                        onTap: () {
                          launch("tel://${applications[index].user.phone}");
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.call,
                              color: MyTheme.accent_color,
                            ),
                          ],
                        ),
                      ),
                      HSpace.md,
                      GestureDetector(
                        onTap: () {
                          launch(
                            'sms:${applications[index].user.phone}?body=Hello ${applications[index].user.name},',
                          );
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.sms,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                      ),
                      HSpace.md,
                      GestureDetector(
                        onTap: () {
                          launch(
                              "https://wa.me/${applications[index].user.phone}?text=Hello ${applications[index].user.name},");
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.whatsapp,
                              color: Colors.green,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  VSpace.sm,
                  Row(
                    children: [
                      Icon(Icons.file_copy),
                      GestureDetector(
                        onTap: () {
                          // launch(applications[index].portfolio);
                          launch(
                              'https://www.africau.edu/images/default/sample.pdf');
                        },
                        child: Text(
                          'View Resume',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: MyTheme.font_grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w100),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildBottomContainer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),

      height: widget.is_base_category ? 0 : 80,
      //color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                width: (MediaQuery.of(context).size.width - 32),
                height: 40,
                child: FlatButton(
                  minWidth: MediaQuery.of(context).size.width,
                  //height: 50,
                  color: MyTheme.accent_color,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(8.0))),
                  child: Text(
                    AppLocalizations.of(context)
                            .category_list_screen_all_products_of +
                        " " +
                        widget.parent_category_name,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return CategoryProducts(
                        category_id: widget.parent_category_id,
                        category_name: widget.parent_category_name,
                      );
                    }));
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildShimmer() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 1,
        crossAxisCount: 3,
      ),
      itemCount: 18,
      padding: EdgeInsets.only(
          left: 18, right: 18, bottom: widget.is_base_category ? 30 : 0),
      scrollDirection: Axis.vertical,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecorations.buildBoxDecoration_1(),
          child: ShimmerHelper().buildBasicShimmer(),
        );
      },
    );
  }
}
