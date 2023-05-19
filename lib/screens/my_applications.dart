import 'dart:convert';

import 'package:hustla/custom/app_bar.dart';
import 'package:hustla/custom/box_decorations.dart';
import 'package:hustla/custom/device_info.dart';
import 'package:hustla/custom/page_description.dart';
import 'package:hustla/custom/spacers.dart';
import 'package:hustla/custom/useful_elements.dart';
import 'package:hustla/helpers/shimmer_helper.dart';
import 'package:hustla/presenter/bottom_appbar_index.dart';
import 'package:hustla/repositories/job_repository.dart';
import 'package:hustla/screens/apply_job.dart';
import 'package:hustla/screens/job_applicants.dart';
import 'package:hustla/screens/job_description.dart';
import 'package:hustla/screens/job_sectors.dart';
import 'package:hustla/screens/post_job.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hustla/my_theme.dart';
import 'package:hustla/ui_sections/drawer.dart';
import 'package:hustla/custom/toast_component.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:toast/toast.dart';
import 'package:hustla/screens/category_products.dart';
import 'package:hustla/repositories/category_repository.dart';
import 'package:shimmer/shimmer.dart';
import 'package:hustla/app_config.dart';
import 'package:hustla/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyApplications extends StatefulWidget {
  MyApplications({Key key, this.banner, this.title}) : super(key: key);

  final String banner;
  final String title;

  @override
  _MyApplicationsState createState() => _MyApplicationsState();
}

class _MyApplicationsState extends State<MyApplications> {
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
            child: buildAppBar(context, widget.title),
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
          buildDescription(widget.title,
              description:
                  'This comprises of a list of the jobs you have applied for'),
          buildCategoryList(),
          Container(
            height: 90,
          )
        ]))
      ],
    );
  }

  buildCategoryList() {
    Map myData = {
      "applicant_id": user_id.$,
    };
    var postData = jsonEncode(myData);
    var data = JobRepository().appliedJobs(postData);
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
            print(jobResponse.jobs);
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
                  Text(
                    jobResponse.jobs[index].status,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: jobResponse.jobs[index].status == 'Open'
                            ? Colors.green
                            : Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w100),
                  ),
                ],
              ),
            ),
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
      padding: EdgeInsets.only(left: 18, right: 18, bottom: 0),
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
