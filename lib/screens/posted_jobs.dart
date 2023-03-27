import 'dart:convert';

import 'package:active_ecommerce_flutter/custom/box_decorations.dart';
import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/custom/spacers.dart';
import 'package:active_ecommerce_flutter/custom/useful_elements.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_flutter/presenter/bottom_appbar_index.dart';
import 'package:active_ecommerce_flutter/repositories/job_repository.dart';
import 'package:active_ecommerce_flutter/screens/apply_job.dart';
import 'package:active_ecommerce_flutter/screens/job_applicants.dart';
import 'package:active_ecommerce_flutter/screens/job_description.dart';
import 'package:active_ecommerce_flutter/screens/job_sectors.dart';
import 'package:active_ecommerce_flutter/screens/post_job.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/ui_sections/drawer.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:toast/toast.dart';
import 'package:active_ecommerce_flutter/screens/category_products.dart';
import 'package:active_ecommerce_flutter/repositories/category_repository.dart';
import 'package:shimmer/shimmer.dart';
import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PostedJobs extends StatefulWidget {
  PostedJobs(
      {Key key,
      this.parent_category_id = 0,
      this.parent_category_name = "",
      this.is_base_category = false,
      this.is_top_category = false,
      this.bottomAppbarIndex,
      this.banner,
      this.sector})
      : super(key: key);

  final int parent_category_id;
  final String parent_category_name;
  final bool is_base_category;
  final bool is_top_category;
  final BottomAppbarIndex bottomAppbarIndex;
  final String banner;
  final String sector;

  @override
  _PostedJobsState createState() => _PostedJobsState();
}

class _PostedJobsState extends State<PostedJobs> {
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
    String name = 'Posted Jobs';

    return name;
  }

  buildCategoryList() {
    Map myData = {
      "created_by": user_id.$,
    };
    var postData = jsonEncode(myData);
    var data = JobRepository().postedJobs(postData);
    return FutureBuilder(
        future: data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SingleChildScrollView(child: buildShimmer());
          }
          if (snapshot.hasError) {
            return Container(
              height: 10,
            );
          } else if (snapshot.hasData) {
            //snapshot.hasData
            var jobResponse = snapshot.data;
            if (jobResponse.jobs.length < 1) {
              return Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: Center(
                  child: Text(
                    'No jobs found',
                    style: TextStyle(
                        color: MyTheme.font_grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              );
            } else {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 3,
                  crossAxisCount: 1,
                ),
                itemCount: jobResponse.jobs.length,
                padding: EdgeInsets.only(left: 18, right: 18, bottom: 30),
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return buildCategoryItemCard(jobResponse, index);
                },
              );
            }
          } else {
            return SingleChildScrollView(child: buildShimmer());
          }
        });
  }

  Widget buildCategoryItemCard(jobResponse, index) {
    var itemWidth = ((DeviceInfo(context).width - 36));

    var jobStatus = jobResponse.jobs[index].status == 'Open' ? true : false;

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
                    jobResponse.jobs[index].name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: MyTheme.font_grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    jobResponse.jobs[index].duration,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: MyTheme.font_grey,
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    jobResponse.jobs[index].location,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: MyTheme.font_grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w300),
                  ),
                  Text(
                    jobResponse.jobs[index].type,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: MyTheme.font_grey,
                        fontSize: 13,
                        fontWeight: FontWeight.w100),
                  ),
                  Text(
                    jobResponse.jobs[index].deadline,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: MyTheme.font_grey,
                        fontSize: 12,
                        fontWeight: FontWeight.w100),
                  ),
                  Row(
                    children: [
                      FlutterSwitch(
                        width: 100.0,
                        height: 27.0,
                        valueFontSize: 13.0,
                        value: jobStatus,
                        borderRadius: 10.0,
                        showOnOff: true,
                        activeText: 'Open',
                        activeColor: Colors.green,
                        inactiveText: 'Closed',
                        onToggle: (val) async {
                          setState(() {
                            jobStatus = val;
                          });
                          print(val);
                          Map postData = {
                            "job_id": jobResponse.jobs[index].id,
                            "status": val ? 'Open' : 'Closed',
                          };
                          var data = jsonEncode(postData);
                          var changeJobStatusResponse =
                              await JobRepository().changeJobStatus(
                            data,
                          );

                          if (changeJobStatusResponse.status != true) {
                            ToastComponent.showDialog(
                                changeJobStatusResponse.message,
                                gravity: Toast.center,
                                duration: Toast.lengthLong);
                          } else {
                            ToastComponent.showDialog(
                                changeJobStatusResponse.message,
                                gravity: Toast.center,
                                duration: Toast.lengthLong);
                          }
                        },
                      ),
                      HSpace(itemWidth * 0.3),
                      GestureDetector(
                        onTap: () {
                          if (jobResponse.jobs[index].applications.length > 0)
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return JobApplicants(
                                    jobApplications:
                                        jobResponse.jobs[index].applications,
                                    banner:
                                        'https://i.guim.co.uk/img/media/e909d8da276dcaa25baca97b134d6d63e8664e75/0_36_6025_3615/master/6025.jpg?width=1200&height=1200&quality=85&auto=format&fit=crop&s=d8d409192183fbbd783d76323c04603e',
                                    sector: jobResponse.jobs[index].category,
                                  );
                                },
                              ),
                            );
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.person,
                              size: 16,
                              color: jobResponse.jobs[index].status == 'Open'
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            Text(
                              '${jobResponse.jobs[index].applications.length}',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color:
                                      jobResponse.jobs[index].status == 'Open'
                                          ? Colors.green
                                          : Colors.red,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300),
                            ),
                          ],
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
